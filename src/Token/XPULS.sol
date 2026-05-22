// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../interfaces/IUniswap.sol";

//Distributor：辅助合约，用于安全转移 USDT
contract Distributor {
    constructor(address usdt) {
        IERC20(usdt).approve(msg.sender, type(uint256).max);
    }
}

abstract contract FirstLaunch {
    uint40 public launchedAtTimestamp;

    function launch() internal {
        require(launchedAtTimestamp == 0, "Already launched");
        launchedAtTimestamp = uint40(block.timestamp);
    }
}
/*
这是一个带复杂税收 + 利润税 + 反卖机制的 ERC20 token，部署在 BSC 上，专为流动性池（XPULS/USDT）设计。


*/

contract XPLUSToken is ERC20, Ownable, ReentrancyGuard, FirstLaunch {

    uint256 public constant TOTAL_SUPPLY = 1_000_000_000 ether;

    address public marketingAddress;
    address public nodeAddress;
    address public yplusSwapAddress;
    address public protectionFundAddress;
    address public interactionContract;//质押合约地址

    address public immutable USDT;
    address public uniswapV2Pair;
    IUniswapV2Router02 public immutable uniswapV2Router;
    Distributor public immutable distributor;

    bool private inSwap;
    bool public presale;
    uint40 public coldTime = 1 minutes;

    uint256 public swapTokensAtAmount = 5000 ether;
    uint256 public slippageTolerance = 50;

    uint256 public totalBuyTaxRate = 350;
    uint256 public totalSellTaxRate = 350;
    uint256 public totalProfitTaxRate = 2800;

    mapping(address => bool) public isExcludedFromFee;
    //用户买入记录（tOwnedU、userTotalBuyValue、lastBuyTime）——用于计算“利润税”。
    mapping(address => uint256) public userTotalBuyValue;
    mapping(address => uint256) public tOwnedU;
    mapping(address => uint40) public lastBuyTime;

    struct POOLUStatus {
        uint112 bal;
        uint40 t;
    }

    POOLUStatus public poolStatus;

    uint256 public accumulatedInjectYplusFee;
    uint256 public accumulatedMarketingFee;
    uint256 public accumulatedNodeFee;
    uint256 public accumulatedAddLPFee;
    uint256 public accumulatedProtectionFee;

    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 usdtReceived,
        uint256 tokensIntoLiquidity
    );

    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor(
        address _usdt,
        address _router,
        address _marketingAddress,
        address _nodeAddress,
        address _protectionFundAddress
    ) ERC20("XPULS", "XPULS") {
        require(_usdt != address(0), "Invalid USDT address");
        require(_router != address(0), "Invalid router address");

        USDT = _usdt;
        uniswapV2Router = IUniswapV2Router02(_router);

        distributor = new Distributor(_usdt);

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
            address(this),
            USDT
        );

        marketingAddress = _marketingAddress;
        nodeAddress = _nodeAddress;
        protectionFundAddress = _protectionFundAddress;

        _mint(msg.sender, TOTAL_SUPPLY);

        isExcludedFromFee[msg.sender] = true;
        isExcludedFromFee[address(this)] = true;
        isExcludedFromFee[_marketingAddress] = true;
        isExcludedFromFee[_nodeAddress] = true;
        isExcludedFromFee[_protectionFundAddress] = true;

        _approve(address(this), address(uniswapV2Router), type(uint256).max);
        IERC20(USDT).approve(address(uniswapV2Router), type(uint256).max);
    }

    function setPresale() external onlyOwner {
        presale = true;
        launch();
        updatePoolReserve();
    }

    function updatePoolReserve() public {
        if (block.timestamp >= poolStatus.t + 1 hours){
            poolStatus.t = uint40(block.timestamp);
            (uint112 reserveU, ) = getMyReserves(uniswapV2Pair);
            poolStatus.bal = reserveU;
        }
    }

    function updatePoolReserve(uint112 reserveU) private {
        if (block.timestamp >= poolStatus.t + 1 hours) {
            poolStatus.t = uint40(block.timestamp);
            poolStatus.bal = reserveU;
        }
    }

    function getMyReserves(
        address pair
    ) internal view returns (uint112 uReserve, uint112 tokenReserve) {
        (uint112 reserve0, uint112 reserve1, ) = IUniswapV2Pair(pair)
            .getReserves();
        address token0 = IUniswapV2Pair(pair).token0();

        if (token0 == address(this)) {
            return (reserve1, reserve0);
        } else {
            return (reserve0, reserve1);
        }
    }

    function _getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256 amountOut) {
        uint256 amountInWithFee = amountIn * 9975;
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = (reserveIn * 10000) + amountInWithFee;
        amountOut = numerator / denominator;
    }

    function _getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) internal pure returns (uint256 amountIn) {
        require(amountOut > 0, "Insufficient output amount");
        require(reserveIn > 0 && reserveOut > 0, "Insufficient liquidity");

        uint256 numerator = reserveIn * amountOut * 10000;
        uint256 denominator = (reserveOut - amountOut) * 9975;
        amountIn = (numerator / denominator) + 1;
    }
    //重写了标准 ERC20 转移逻辑，只在 Pair 买卖时触发税收。
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        //白名单
        if (
            isExcludedFromFee[sender] || isExcludedFromFee[recipient] || inSwap
        ) {
            super._transfer(sender, recipient, amount);
            return;
        }
        //买入（Pair 是 sender）
        if (uniswapV2Pair == sender) {
            require(presale, "pre");
            (uint112 reserveU, uint112 reserveThis) = getMyReserves(uniswapV2Pair);
            //买入上限：不超过池子 token 储备的 10%。
            require(amount <= reserveThis / 10, "max cap buy");
            updatePoolReserve(reserveU);
            uint256 amountUBuy = _getAmountIn(amount, reserveU, reserveThis);
            tOwnedU[recipient] = tOwnedU[recipient] + amountUBuy;
            userTotalBuyValue[recipient] = userTotalBuyValue[recipient] + amountUBuy;
            //Buy Tax 3.5%，先暂存在本合约，后续分配。
            uint256 totalBuyFee = (amount * totalBuyTaxRate) / 10000;
            uint256 amountToUser = amount - totalBuyFee;        
            //10/35（≈1%） → accumulatedInjectYplusFee（后续转给 yplusSwapAddress）。
            uint256 injectYplusFee = (totalBuyFee * 10) / 35;
            //剩余 25/35（≈2.5%） → accumulatedAddLPFee（后续做 LP）。
            uint256 addLPFee = totalBuyFee - injectYplusFee;

            accumulatedInjectYplusFee += injectYplusFee;
            accumulatedAddLPFee += addLPFee;

            super._transfer(sender, address(this), totalBuyFee);
            super._transfer(sender, recipient, amountToUser);
        } else if (uniswapV2Pair == recipient) {//卖出（Pair 是 recipient）
            require(presale, "pre");
            require(block.timestamp >= lastBuyTime[sender] + coldTime, "cold");
            (uint112 reserveU, uint112 reserveThis) = getMyReserves(uniswapV2Pair);
            //卖出上限：不超过池子 token 储备的 10%。
            require(amount <= reserveThis / 10, "max cap sell");
            updatePoolReserve(reserveU);
            uint256 totalAccumulatedFees = accumulatedInjectYplusFee +
                accumulatedMarketingFee +
                accumulatedNodeFee +
                accumulatedAddLPFee +
                accumulatedProtectionFee;
            //在每次卖出时，先检查是否需要将累计的费用转换并分配（如果达到阈值）
            //累积费用达到 swapTokensAtAmount（默认 5000 XPULS）时，触发 _swapAndDistribute。
            if (shouldSwapTokenForFund(totalAccumulatedFees)) {
                _swapAndDistribute();
            }

            uint256 baseSellTax = (amount * totalSellTaxRate) / 10000;
            //10/35（≈1%） → 直接 burn 到 dead 地址。
            uint256 burnFee = (baseSellTax * 10) / 35;
            //15/35（≈2.5%） → accumulatedMarketingFee（后续转给 marketingAddress）。
            uint256 marketingFee = (baseSellTax * 15) / 35;
            //10/35 → accumulatedNodeFee（后续转给 nodeAddress）。
            uint256 nodeFee = baseSellTax - burnFee - marketingFee;

            super._transfer(sender, address(0xdead), burnFee);
            super._transfer(sender, address(this), marketingFee + nodeFee);
            accumulatedMarketingFee += marketingFee;
            accumulatedNodeFee += nodeFee;

            uint256 amountAfterBaseTax = amount - baseSellTax;
            uint256 amountUOut = _getAmountOut(
                amountAfterBaseTax,
                reserveThis,
                reserveU
            );
            //利润税计算：计算逻辑基于用户历史买入 USDT 价值 vs 当前卖出等值 USDT。
            uint256 profitTax = 0;
            //如果用户持有的 tOwnedU（买入记录）足以覆盖当前卖出对应的 USDT 价值，则仅扣除基础卖出税，不额外征收利润税。
            if (tOwnedU[sender] >= amountUOut) {
                unchecked {
                    tOwnedU[sender] = tOwnedU[sender] - amountUOut;
                }
            } //如果用户持有的 tOwnedU 不足以覆盖当前卖出对应的 USDT 价值，则对差额部分征收利润税。
            else if (tOwnedU[sender] > 0 && tOwnedU[sender] < amountUOut) {
                uint256 profitU = amountUOut - tOwnedU[sender];
                uint256 profitTokens = _getAmountOut(profitU, reserveU, reserveThis);

                profitTax = (profitTokens * totalProfitTaxRate) / 10000;
                tOwnedU[sender] = 0;
            } else //如果用户没有 tOwnedU（买入记录），则对全部卖出金额对应的 USDT 价值征收利润税。
            {
                profitTax = (amountAfterBaseTax * totalProfitTaxRate) / 10000;
                tOwnedU[sender] = 0;
            }
            //利润税分配：
            if (profitTax > 0) {
                super._transfer(sender, address(this), profitTax);
                // accumulatedMarketingFee（后续转给 marketingAddress）；
                uint256 marketingAmount = (profitTax * 8) / 28;
                // accumulatedNodeFee（后续转给 nodeAddress）
                uint256 nodeAmount = (profitTax * 8) / 28;
                // accumulatedInjectYplusFee（后续转给 yplusSwapAddress）；
                uint256 injectAmount = (profitTax * 4) / 28;
                // accumulatedProtectionFee（后续转给 protectionFundAddress）。
                uint256 protectionAmount = profitTax - marketingAmount - nodeAmount - injectAmount;
                accumulatedMarketingFee += marketingAmount;
                accumulatedNodeFee += nodeAmount;
                accumulatedInjectYplusFee += injectAmount;
                accumulatedProtectionFee += protectionAmount;
            }

            super._transfer(
                sender,
                recipient,
                amount - baseSellTax - profitTax
            );
        } else {
            super._transfer(sender, recipient, amount);
        }
    }

    function shouldSwapTokenForFund(
        uint256 amount
    ) internal view returns (bool) {
        if (amount >= swapTokensAtAmount && !inSwap) {
            return true;
        } else {
            return false;
        }
    }
    //当累计的费用达到设定的阈值时，_swapAndDistribute 会被触发，执行以下操作：
    //lockTheSwap 防止 swap 重入--_swapAndDistribute里面会调用swap，lockTheSwap会设置 inSwap = true，直接走普通转账，跳过所有税费逻辑。
    //等 _swapAndDistribute 完成，inSwap 恢复 false，一切恢复正常
    function _swapAndDistribute() private lockTheSwap {
        //Yplus fee 直接转给 yplusSwapAddress
        if (accumulatedInjectYplusFee > 0 && yplusSwapAddress != address(0)) {
            super._transfer(address(this), yplusSwapAddress, accumulatedInjectYplusFee);
            accumulatedInjectYplusFee = 0;
        }
    //Marketing/Node/Protection fee → swap 为 USDT 转给对应地址。
        if (accumulatedMarketingFee > 0 && marketingAddress != address(0)) {
            _swapTokensForUSDT(accumulatedMarketingFee, marketingAddress);
            accumulatedMarketingFee = 0;
        }

        if (accumulatedNodeFee > 0 && nodeAddress != address(0)) {
            _swapTokensForUSDT(accumulatedNodeFee, nodeAddress);
            accumulatedNodeFee = 0;
        }

        if (accumulatedProtectionFee > 0 && protectionFundAddress != address(0)) {
            _swapTokensForUSDT(accumulatedProtectionFee, protectionFundAddress);
            accumulatedProtectionFee = 0;
        }

        if (accumulatedAddLPFee > 0) {
            _swapAndLiquify(accumulatedAddLPFee);
            accumulatedAddLPFee = 0;
        }
    }

    function _swapTokensForUSDT(uint256 tokenAmount, address to) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = USDT;

        uint256[] memory amounts = uniswapV2Router.getAmountsOut(
            tokenAmount,
            path
        );
        uint256 expectedOutput = amounts[1];

        uint256 minOutput = (expectedOutput * slippageTolerance) / 100;

        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount,
            minOutput,
            path,
            to,
            block.timestamp
        );
    }

    function _swapAndLiquify(uint256 tokens) private {
        uint256 half = tokens / 2;
        uint256 otherHalf = tokens - half;

        uint256 initialBalance = IERC20(USDT).balanceOf(address(distributor));

        _swapTokensForUSDT(half, address(distributor));

        uint256 afterBal = IERC20(USDT).balanceOf(address(distributor));
        if (afterBal <= initialBalance) {
            return;
        }
        uint256 newBalance = afterBal - initialBalance;

        IERC20(USDT).transferFrom(
            address(distributor),
            address(this),
            newBalance
        );

        if (newBalance > 0) {
            uniswapV2Router.addLiquidity(
                address(this),
                USDT,
                otherHalf,
                newBalance,
                0,
                0,
                address(0xdead),
                block.timestamp
            );

            emit SwapAndLiquify(half, newBalance, otherHalf);
        }
    }
    //仅 interactionContract（质押合约）可调用，从 Pair 中转移最多 1/3 LP 代币给调用者（用于项目内部机制）。
    function recycleLiquidity(uint256 amount) external nonReentrant {
        require(msg.sender == interactionContract, "Only interaction contract");

        uint256 pairBalance = balanceOf(uniswapV2Pair);
        require(pairBalance >= amount, "Insufficient liquidity");

        uint256 maxRecycleAmount = pairBalance / 3;
        uint256 actualAmount = amount > maxRecycleAmount
            ? maxRecycleAmount
            : amount;

        super._transfer(uniswapV2Pair, msg.sender, actualAmount);

        IUniswapV2Pair(uniswapV2Pair).sync();
    }

    function getUserTotalBuyValue(
        address user
    ) external view returns (uint256) {
        return userTotalBuyValue[user];
    }

    function setInteractionContract(address _contract) external onlyOwner {
        interactionContract = _contract;
        isExcludedFromFee[_contract] = true;
    }

    function setYPLUSSwapAddress(address _address) external onlyOwner {
        yplusSwapAddress = _address;
    }

    function setMarketingAddress(address _address) external onlyOwner {
        marketingAddress = _address;
        isExcludedFromFee[_address] = true;
    }

    function setNodeAddress(address _address) external onlyOwner {
        nodeAddress = _address;
        isExcludedFromFee[_address] = true;
    }

    function setProtectionFundAddress(address _address) external onlyOwner {
        protectionFundAddress = _address;
        isExcludedFromFee[_address] = true;
    }

    function setSwapTokensAtAmount(uint256 _amount) external onlyOwner {
        swapTokensAtAmount = _amount;
    }

    function setSlippageTolerance(uint256 _slippageTolerance) external onlyOwner {
        require(_slippageTolerance >= 50 && _slippageTolerance <= 100, "Slippage must be 50-100");
        slippageTolerance = _slippageTolerance;
    }

    function setTotalBuyTaxRate(uint256 _rate) external onlyOwner {
        require(_rate <= 5000, "Buy tax cannot exceed 50%");
        totalBuyTaxRate = _rate;
    }

    function setTotalSellTaxRate(uint256 _rate) external onlyOwner {
        require(_rate <= 5000, "Sell tax cannot exceed 50%");
        totalSellTaxRate = _rate;
    }

    function setTotalProfitTaxRate(uint256 _rate) external onlyOwner {
        require(_rate <= 5000, "Profit tax cannot exceed 50%");
        totalProfitTaxRate = _rate;
    }

    function setExcludedFromFee(
        address account,
        bool excluded
    ) external onlyOwner {
        isExcludedFromFee[account] = excluded;
    }

    function batchSetExcludedFromFee(address[] calldata accounts, bool excluded) external onlyOwner {
        require(accounts.length <= 100, "Too many accounts");
        for (uint256 i = 0; i < accounts.length; i++) {
            isExcludedFromFee[accounts[i]] = excluded;
        }
    }

    function manualSwapAndDistribute() external onlyOwner {
        _swapAndDistribute();
    }

    function emergencyWithdraw(
        address token,
        uint256 amount
    ) external onlyOwner {
        if (token == address(0)) {
            (bool success, ) = payable(owner()).call{value: amount}("");
            require(success, "ETH transfer failed");
        } else {
            IERC20(token).transfer(owner(), amount);
        }
    }

    receive() external payable {}
}
