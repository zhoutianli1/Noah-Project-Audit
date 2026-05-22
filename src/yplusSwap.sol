// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IUniswap.sol";

interface IXPLUSToken is IERC20 {
    function uniswapV2Pair() external view returns (address);
}

/**
 * @title YPlusSwap
 * @dev 由反编译代码重构而来的 YPlus OTC 交易与配额管理合约

 - 在 getYPlusPrice 函数中，YPLUS 的价格并不是由市场供需决定的，而是基于：
- xplusPoolBalance （合约内持有的 XPULS 余额）
- getYPlusCirculatingSupply （市场流通量）
- 风险 ：管理员可以通过向合约转入/转出 XPULS 代币，在没有任何真实买卖的情况下，瞬间拉升或砸低 YPLUS 的价格。
 */
contract YPlusSwap is Ownable, ReentrancyGuard {
    
    // --- 状态变量 ---
    
    IERC20 public constant USDT = IERC20(0x55d398326f99059fF775485246999027B3197955);
    IXPLUSToken public constant XPLUS = IXPLUSToken(0xabAe909cd93Bc2ddf90086f9aA6C3f8e154E8228);
    IERC20 public constant YPLUS = IERC20(0xBf39C2FCef95e2c9e299e34b3d233bA1Ecd7C1A4);
    IUniswapV2Router02 public constant router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    uint256 public constant TAX_DENOMINATOR = 10000;
    uint256 public constant SELL_TAX_BURN = 250;     // 2.5% 销毁
    uint256 public constant SELL_TAX_MARKETING = 250; // 2.5% 营销
    uint256 public constant QUOTA_RESET_TIME = 24 hours;

    address public marketingAddress;
    uint256 public xplusPoolBalance; // 内部记录的 XPLUS 余额

    bool public tradingEnabled;
    bool public publicBuyEnabled;

    mapping(address => bool) public authorizedContracts;

    // 配额管理
    mapping(address => uint256) public dailyBuyQuota;       // 每日总额度
    mapping(address => uint256) public dailyUsedQuota;      // 每日已用额度
    mapping(address => uint256) public lastQuotaResetTime;  // 上次额度重置时间
    
    mapping(address => uint256) public oneTimeBuyQuota;     // 一次性总额度
    mapping(address => uint256) public oneTimeUsedQuota;    // 一次性已用额度

    // --- 事件 ---
    
    event Sell(address indexed user, uint256 yplusAmount, uint256 xplusAmount, uint256 timestamp);
    event Buy(address indexed user, uint256 xplusAmount, uint256 yplusAmount, uint256 timestamp);
    event ContractAuthorized(address indexed addr, bool isAuthorized);
    event TradingEnabled(uint256 timestamp);
    event PublicBuyEnabled(bool enabled);
    event DailyQuotaUpdated(address indexed user, uint256 amount);
    event OneTimeQuotaUpdated(address indexed user, uint256 amount);
    event QuotaReset(address indexed user, uint256 timestamp);

    constructor(address _marketing) Ownable() {
        marketingAddress = _marketing;
    }

    // --- 修饰符 ---
    
    modifier onlyAuthorized() {
        require(msg.sender == owner() || authorizedContracts[msg.sender], "Not authorized");
        _;
    }

    // --- 核心价格逻辑 ---

    /**
     * @dev 获取 XPLUS 在 Uniswap 的价格 (以 1e18 精度表示的 USDT 价值)
     * 对应原代码中的 0x168d
     */
    function getXPlusPrice() public view returns (uint256) {
        address pair = XPLUS.uniswapV2Pair();
        require(pair != address(0), "Invalid pair");
        
        IUniswapV2Pair pairContract = IUniswapV2Pair(pair);
        (uint112 reserve0, uint112 reserve1, ) = pairContract.getReserves();
        
        address token0 = pairContract.token0();
        uint256 reserveU = (token0 == address(USDT)) ? uint256(reserve0) : uint256(reserve1);
        uint256 reserveX = (token0 == address(USDT)) ? uint256(reserve1) : uint256(reserve0);
        
        require(reserveX > 0, "Invalid reserves");
        return (reserveU * 1e18) / reserveX;
    }

    /**
     * @dev 获取 YPLUS 的内部计算价格
     * 对应原代码中的 0x152f 和 0x1334
     */
    function getYPlusPrice() public view returns (uint256) {
        uint256 circulatingSupply = getYPlusCirculatingSupply();
        if (circulatingSupply == 0) return 0;
        
        // 价格公式：(xplusPoolBalance * 1e18 / circulatingSupply) * XPlusPrice / 1e18
        uint256 priceInXPlus = (xplusPoolBalance * 1e18) / circulatingSupply;
        return (priceInXPlus * getXPlusPrice()) / 1e18;
    }

    function getYPlusCirculatingSupply() public view returns (uint256) {
        uint256 total = YPLUS.totalSupply();
        uint256 inContract = YPLUS.balanceOf(address(this));
        uint256 inDead = YPLUS.balanceOf(0x000000000000000000000000000000000000dEaD);
        
        if (total <= (inContract + inDead)) return 0;
        return total - inContract - inDead;
    }

    // --- 交易功能 ---

    /**
     * @dev 使用 XPLUS 购买 YPLUS (使用每日配额)
     * 对应原代码中的 0x9a244d1b
     */
    function buyWithDailyQuota(uint256 xplusAmount) external nonReentrant returns (uint256) {
        require(tradingEnabled, "Trading not enabled");
        require(xplusAmount > 0, "Invalid amount");

        _syncPoolBalance();

        if (!publicBuyEnabled) {
            // 检查并重置每日额度
            if (block.timestamp >= lastQuotaResetTime[msg.sender] + QUOTA_RESET_TIME) {
                dailyUsedQuota[msg.sender] = 0;
                lastQuotaResetTime[msg.sender] = block.timestamp;
                emit QuotaReset(msg.sender, block.timestamp);
            }
            
            require(dailyBuyQuota[msg.sender] - dailyUsedQuota[msg.sender] >= xplusAmount, "Insufficient daily quota");
            dailyUsedQuota[msg.sender] += xplusAmount;
        }

        return _executeBuy(xplusAmount);
    }

    /**
     * @dev 使用 XPLUS 购买 YPLUS (使用一次性配额)
     * 对应原代码中的 0x2aef5959
     */
    function buyWithOneTimeQuota(uint256 xplusAmount) external nonReentrant returns (uint256) {
        require(tradingEnabled, "Trading not enabled");
        require(xplusAmount > 0, "Invalid amount");

        _syncPoolBalance();

        if (!publicBuyEnabled) {
            require(oneTimeBuyQuota[msg.sender] - oneTimeUsedQuota[msg.sender] >= xplusAmount, "Insufficient one-time quota");
            oneTimeUsedQuota[msg.sender] += xplusAmount;
        }

        return _executeBuy(xplusAmount);
    }

    function _executeBuy(uint256 xplusAmount) private returns (uint256) {
        uint256 yplusPrice = getYPlusPrice();
        require(yplusPrice > 0, "Invalid price");
        
        // 计算应得 YPLUS：(xplusAmount * XPlusPrice) / yplusPrice
        uint256 yplusAmount = (xplusAmount * getXPlusPrice()) / yplusPrice;
        require(YPLUS.balanceOf(address(this)) >= yplusAmount, "Insufficient YPLUS in pool");

        XPLUS.transferFrom(msg.sender, address(this), xplusAmount);
        xplusPoolBalance += xplusAmount;
        YPLUS.transfer(msg.sender, yplusAmount);

        emit Buy(msg.sender, xplusAmount, yplusAmount, block.timestamp);
        return yplusAmount;
    }

    /**
     * @dev 卖出 YPLUS 换取 XPLUS
     * 对应原代码中的 sell (0xe4849b32)
     */
    function sell(uint256 yplusAmount) external nonReentrant {
        require(tradingEnabled, "Trading not enabled");
        require(yplusAmount > 0, "Invalid amount");

        _syncPoolBalance();

        // 计算卖出税
        uint256 burnTax = (yplusAmount * SELL_TAX_BURN) / TAX_DENOMINATOR;
        uint256 marketingTax = (yplusAmount * SELL_TAX_MARKETING) / TAX_DENOMINATOR;
        uint256 netYPlusAmount = yplusAmount - burnTax - marketingTax;

        // 计算应得 XPLUS
        uint256 yplusPrice = getYPlusPrice();
        uint256 xplusPrice = getXPlusPrice();
        uint256 xplusAmount = (netYPlusAmount * yplusPrice) / xplusPrice;

        require(xplusPoolBalance >= xplusAmount, "Insufficient XPLUS in pool");

        YPLUS.transferFrom(msg.sender, address(this), yplusAmount);
        
        // 处理税收
        if (burnTax > 0) YPLUS.transfer(0x000000000000000000000000000000000000dEaD, burnTax);
        if (marketingTax > 0) YPLUS.transfer(marketingAddress, marketingTax);

        xplusPoolBalance -= xplusAmount;
        XPLUS.transfer(msg.sender, xplusAmount);

        emit Sell(msg.sender, yplusAmount, xplusAmount, block.timestamp);
    }

    // --- 管理功能 ---

    function addDailyBuyQuota(address user, uint256 amount) external onlyAuthorized {
        dailyBuyQuota[user] += amount;
        emit DailyQuotaUpdated(user, amount);
    }

    function addOneTimeBuyQuota(address user, uint256 amount) external onlyAuthorized {
        oneTimeBuyQuota[user] += amount;
        emit OneTimeQuotaUpdated(user, amount);
    }

    function setAuthorizedContract(address addr, bool isAuthorized) external onlyOwner {
        authorizedContracts[addr] = isAuthorized;
        emit ContractAuthorized(addr, isAuthorized);
    }

    function setTradingEnabled(bool enabled) external onlyOwner {
        tradingEnabled = enabled;
        if(enabled) emit TradingEnabled(block.timestamp);
    }

    function setPublicBuyEnabled(bool enabled) external onlyOwner {
        publicBuyEnabled = enabled;
        emit PublicBuyEnabled(enabled);
    }

    function setMarketingAddress(address _addr) external onlyOwner {
        marketingAddress = _addr;
    }

    function _syncPoolBalance() private {
        uint256 actualBalance = XPLUS.balanceOf(address(this));
        if (actualBalance != xplusPoolBalance) {
            xplusPoolBalance = actualBalance;
        }
    }

    // --- 紧急处理 ---

    function emergencyWithdraw(address token, uint256 amount) external onlyOwner {
        if (token == address(0)) {
            payable(owner()).transfer(amount);
        } else {
            IERC20(token).transfer(owner(), amount);
        }
    }

    receive() external payable {}
}
