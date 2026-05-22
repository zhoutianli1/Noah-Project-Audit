// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./interfaces/IUniswap.sol";
import "./interfaces/IXPLUSToken.sol";
import "./interfaces/IReferral.sol";
import "./interfaces/IYPLUSSwap.sol";

contract Staking is Ownable, ReentrancyGuard {

    uint256 public constant DENOMINATOR = 10000;
    uint256 public constant SECONDS_PER_DAY = 86400;

    struct StakingPlan {
        uint256 duration;
        uint256 timeUnit;
        uint256 dailyRate;
        bool enabled;
    }

    StakingPlan[3] public plans;

    struct StakingOrder {
        uint256 planId;
        uint256 amount;
        uint256 startTime;
        uint256 endTime;
        uint256 lastClaimTime;
        uint256 claimedReward;
        bool isWithdrawn;
    }

    IERC20 public immutable USDT;
    IXPLUSToken public immutable XPLUS;
    IUniswapV2Router02 public immutable router;
    IReferral public referral;
    IYPLUSSwap public yplusSwap;

    mapping(address => StakingOrder[]) public userOrders;

    mapping(address => uint256) public userTotalStaked;

    mapping(address => uint256) public userTotalWithdrawn;

    uint256 public maxStakePerTx = 1000 ether;
    uint256 public globalRatePerMinute = 5;
    uint256 public dailyQuotaRate = 10000;

    uint256 public lastGlobalStakeTime;
    uint256 public globalStakedInMinute;

    address public xplusAirdropAddress;
    address public marketingAddress;

    uint256 public accumulatedYplusFee;
    uint256 public accumulatedXplusFee;
    uint256 public accumulatedS7Reward;

    uint256 public slippageTolerance = 50;

    mapping(address => uint256) public teamPerformance;

    mapping(address => uint256) public directPerformance;

    mapping(address => uint256) public zonePerformance;

    struct Level {
        uint256 requiredZonePerformance;
        uint256 rewardRate;
        uint256 yplusBuyQuota;
        string name;
    }

    Level[8] public levels;

    mapping(address => uint256) public userLevel;

    mapping(address => uint256) public highestLevelReached;

    address[] public s7Users;
    mapping(address => bool) public isS7User;
    mapping(address => uint256) public s7UserIndex;

    event Staked(
        address indexed user,
        uint256 indexed orderId,
        uint256 planId,
        uint256 amount,
        uint256 endTime
    );
    event RewardClaimed(address indexed user, uint256 indexed orderId, uint256 reward);
    event Withdrawn(address indexed user, uint256 indexed orderId, uint256 principal, uint256 reward);
    event GenerationRewardPaid(address indexed user, address indexed from, uint256 amount, uint256 generation);
    event TeamRewardPaid(address indexed user, uint256 amount, uint256 level);
    event S7RewardDistributed(uint256 totalAmount, uint256 userCount, uint256 amountPerUser);
    event LevelUpdated(address indexed user, uint256 oldLevel, uint256 newLevel);
    event S7UserAdded(address indexed user);
    event S7UserRemoved(address indexed user);

    constructor(
        address _usdt,
        address _xplus,
        address _router,
        address _referral,
        address _yplusSwap,
        address _xplusAirdropAddress,
        address _marketingAddress
    ) {
        require(_usdt != address(0), "Invalid USDT");
        require(_xplus != address(0), "Invalid XPLUS");
        require(_router != address(0), "Invalid router");
        require(_referral != address(0), "Invalid referral");
        require(_yplusSwap != address(0), "Invalid yplusSwap");

        USDT = IERC20(_usdt);
        XPLUS = IXPLUSToken(_xplus);
        router = IUniswapV2Router02(_router);
        yplusSwap = IYPLUSSwap(_yplusSwap);
        referral = IReferral(_referral);

        xplusAirdropAddress = _xplusAirdropAddress;
        marketingAddress = _marketingAddress;

        plans[0] = StakingPlan(30, SECONDS_PER_DAY, 120, true);
        plans[1] = StakingPlan(60, SECONDS_PER_DAY, 140, true);
        plans[2] = StakingPlan(90, SECONDS_PER_DAY, 160, true);

        USDT.approve(address(router), type(uint256).max);
        IERC20(_xplus).approve(address(router), type(uint256).max);

        levels[0] = Level(0, 0, 0, "S0");
        levels[1] = Level(3_000 ether, 500, 0, "S1");
        levels[2] = Level(10_000 ether, 1000, 0, "S2");
        levels[3] = Level(50_000 ether, 1500, 100 ether, "S3");
        levels[4] = Level(250_000 ether, 2000, 300 ether, "S4");
        levels[5] = Level(1_500_000 ether, 2500, 1000 ether, "S5");
        levels[6] = Level(6_000_000 ether, 3000, 2000 ether, "S6");
        levels[7] = Level(20_000_000 ether, 3500, 5000 ether, "S7");
    }

    function stake(uint256 planId, uint256 amount) external nonReentrant {
        require(planId < 3, "Invalid plan");
        require(plans[planId].enabled, "Plan disabled");
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= maxStakePerTx, "Exceeds max stake per tx");

        _checkGlobalLimit(amount);

        USDT.transferFrom(msg.sender, address(this), amount);

        _processStakingFunds(amount, address(0xdead));

        StakingPlan memory plan = plans[planId];
        uint256 startTime = block.timestamp;
        uint256 endTime = startTime + (plan.duration * plan.timeUnit);

        userOrders[msg.sender].push(StakingOrder({
            planId: planId,
            amount: amount,
            startTime: startTime,
            endTime: endTime,
            lastClaimTime: startTime,
            claimedReward: 0,
            isWithdrawn: false
        }));

        uint256 orderId = userOrders[msg.sender].length - 1;

        userTotalStaked[msg.sender] += amount;

        _updatePerformance(msg.sender, amount, true);

        address userReferrer = referral.referrer(msg.sender);
        if (userReferrer != address(0)) {
            uint256 dailyQuota = amount / dailyQuotaRate;
            if (dailyQuota > 0) {
                yplusSwap.addDailyBuyQuota(userReferrer, dailyQuota);
            }
        }

        emit Staked(msg.sender, orderId, planId, amount, endTime);
    }

    function _processStakingFunds(uint256 amount, address to) private {
        uint256 half = amount / 2;
        uint256 otherHalf = amount - half;

        uint256 xplusBalBefore = XPLUS.balanceOf(address(this));

        address[] memory path = new address[](2);
        path[0] = address(USDT);
        path[1] = address(XPLUS);

        _swapUsdtForTokens(half, address(this));

        uint256 actualXplusAmount = XPLUS.balanceOf(address(this)) - xplusBalBefore;

        router.addLiquidity(
            address(XPLUS),
            address(USDT),
            actualXplusAmount,
            otherHalf,
            0,
            0,
            to,
            block.timestamp
        );
    }

    function _getGlobalLimitData() private view returns (
        uint256 maxPerMinute,
        uint256 used,
        bool windowReset,
        uint256 timeUntilReset
    ) {
        uint256 poolBalance = _getPoolUSDTReserve();
        maxPerMinute = (poolBalance * globalRatePerMinute) / DENOMINATOR;

        windowReset = block.timestamp >= lastGlobalStakeTime + 60;

        if (windowReset) {
            used = 0;
            timeUntilReset = 0;
        } else {
            used = globalStakedInMinute;
            timeUntilReset = (lastGlobalStakeTime + 60) - block.timestamp;
        }

        return (maxPerMinute, used, windowReset, timeUntilReset);
    }

    function _checkGlobalLimit(uint256 amount) private {
        (uint256 maxPerMinute, uint256 used, bool windowReset, ) = _getGlobalLimitData();

        if (windowReset) {
            lastGlobalStakeTime = block.timestamp;
            globalStakedInMinute = 0;
            used = 0;
        }

        require(used + amount <= maxPerMinute, "Exceeds global limit");

        globalStakedInMinute += amount;
    }

    function _getPoolUSDTReserve() private view returns (uint256 usdtReserve) {
        address pair = XPLUS.uniswapV2Pair();

        if (pair == address(0)) return 0;

        IUniswapV2Pair pairContract = IUniswapV2Pair(pair);
        (uint112 reserve0, uint112 reserve1, ) = pairContract.getReserves();

        address token0 = pairContract.token0();
        if (token0 == address(USDT)) {
            usdtReserve = uint256(reserve0);
        } else {
            usdtReserve = uint256(reserve1);
        }

        return usdtReserve;
    }

    function calculateReward(address user, uint256 orderId) public view returns (uint256) {
        StakingOrder memory order = userOrders[user][orderId];
        if (order.isWithdrawn) return 0;

        StakingPlan memory plan = plans[order.planId];

        uint256 currentTime = block.timestamp;
        uint256 timeElapsed = currentTime - order.lastClaimTime;

        if (timeElapsed == 0) return 0;

        uint256 principal = order.amount + order.claimedReward;

        uint256 perSecondRate = _calculatePerSecondRate(plan.dailyRate);

        uint256 maxElapsedTime = plan.duration * plan.timeUnit;
        if (timeElapsed > maxElapsedTime) {
            timeElapsed = maxElapsedTime;
        }

        uint256 totalAmount = (principal * _powu(perSecondRate, timeElapsed)) / 1e18;

        return totalAmount > principal ? totalAmount - principal : 0;
    }

    function _powu(uint256 base, uint256 exp) private pure returns (uint256 result) {
        result = 1e18;
        while (exp > 0) {
            if (exp & 1 != 0) {
                result = (result * base) / 1e18;
            }
            base = (base * base) / 1e18;
            exp >>= 1;
        }
    }

    function _calculatePerSecondRate(uint256 dailyRate) private pure returns (uint256) {
        uint256 rateIncrement = (dailyRate * 1e18) / (DENOMINATOR * SECONDS_PER_DAY);
        return 1e18 + rateIncrement;
    }

    function claimReward(uint256 orderId) external nonReentrant {
        require(orderId < userOrders[msg.sender].length, "Invalid order");
        StakingOrder storage order = userOrders[msg.sender][orderId];
        require(!order.isWithdrawn, "Already withdrawn");

        uint256 reward = calculateReward(msg.sender, orderId);
        require(reward > 0, "No reward to claim");

        _checkTurboMechanism(msg.sender, (reward * 5000) / DENOMINATOR);

        order.lastClaimTime = block.timestamp;
        order.claimedReward += reward;

        uint256 usdtBefore = USDT.balanceOf(address(this));
        uint256 xplusBefore = XPLUS.balanceOf(address(this));

        address[] memory path = new address[](2);
        path[0] = address(XPLUS);
        path[1] = address(USDT);

        router.swapTokensForExactTokens(
            reward,
            xplusBefore,
            path,
            address(this),
            block.timestamp
        );

        uint256 xplusUsed = xplusBefore - XPLUS.balanceOf(address(this));
        uint256 usdtGot = USDT.balanceOf(address(this)) - usdtBefore;

        uint256 actualReward = (usdtGot * 5000) / DENOMINATOR;
        uint256 distributePortion = usdtGot - actualReward;

        USDT.transfer(msg.sender, actualReward);

        if (distributePortion > 0) {
            _distributeRewards(msg.sender, distributePortion);
        }

        XPLUS.recycleLiquidity(xplusUsed);

        userTotalWithdrawn[msg.sender] += actualReward;

        emit RewardClaimed(msg.sender, orderId, actualReward);
    }

    function withdraw(uint256 orderId) external nonReentrant {
        require(orderId < userOrders[msg.sender].length, "Invalid order");
        StakingOrder storage order = userOrders[msg.sender][orderId];
        require(!order.isWithdrawn, "Already withdrawn");
        require(block.timestamp >= order.endTime, "Not expired yet");

        uint256 currentReward = calculateReward(msg.sender, orderId);
        uint256 principal = order.amount;
        uint256 totalReward = principal + currentReward;

        _checkTurboMechanism(msg.sender, (currentReward * 5000) / DENOMINATOR);

        uint256 usdtBefore = USDT.balanceOf(address(this));
        uint256 xplusBefore = XPLUS.balanceOf(address(this));

        address[] memory path = new address[](2);
        path[0] = address(XPLUS);
        path[1] = address(USDT);

        router.swapTokensForExactTokens(
            totalReward,
            xplusBefore,
            path,
            address(this),
            block.timestamp
        );

        uint256 xplusUsed = xplusBefore - XPLUS.balanceOf(address(this));
        uint256 usdtGot = USDT.balanceOf(address(this)) - usdtBefore;

        uint256 interest = usdtGot > principal ? usdtGot - principal : 0;

        uint256 actualReward = (interest * 5000) / DENOMINATOR;
        uint256 distributePortion = interest - actualReward;

        if (distributePortion > 0) {
            _distributeRewards(msg.sender, distributePortion);
        }

        USDT.transfer(msg.sender, principal + actualReward);

        XPLUS.recycleLiquidity(xplusUsed);

        order.isWithdrawn = true;
        order.lastClaimTime = block.timestamp;
        order.claimedReward += actualReward;

        userTotalStaked[msg.sender] -= principal;

        _updatePerformance(msg.sender, principal, false);

        userTotalWithdrawn[msg.sender] += actualReward;

        emit Withdrawn(msg.sender, orderId, principal, actualReward);
    }

    function _checkTurboMechanism(address user, uint256 withdrawAmount) private view {
        uint256 totalWithdrawn = userTotalWithdrawn[user] + withdrawAmount;
        uint256 totalBuyAmount = XPLUS.getUserTotalBuyValue(user);

        require(totalWithdrawn <= totalBuyAmount, "Exceeds turbo limit: XPLUS buy amount insufficient");
    }

    function _distributeRewards(address user, uint256 totalReward) private {
        uint256 generationReward = (totalReward * 1000) / DENOMINATOR;
        _distributeGenerationRewards(user, generationReward);

        uint256 teamReward = (totalReward * 7000) / DENOMINATOR;
        _distributeTeamRewards(user, teamReward);

        uint256 yplusFee = (totalReward * 1000) / DENOMINATOR;
        accumulatedYplusFee += yplusFee;

        if (accumulatedYplusFee >= 100 ether) {
            _swapUsdtForTokens(accumulatedYplusFee, address(yplusSwap));
            accumulatedYplusFee = 0;
        }

        uint256 xplusFee = totalReward - generationReward - teamReward - yplusFee;
        accumulatedXplusFee += xplusFee;
        if (accumulatedXplusFee >= 100 ether) {
            _swapUsdtForTokens(accumulatedXplusFee, xplusAirdropAddress);
            accumulatedXplusFee = 0;
        }
    }

    function _distributeGenerationRewards(address user, uint256 totalAmount) private {
        address[] memory upline = referral.getUpline(user);
        uint256 rewardPerGen = totalAmount / 10;
        uint256 distributed = 0;

        for (uint256 i = 0; i < upline.length && i < 10; i++) {
            if (upline[i] == address(0)) break;

            USDT.transfer(upline[i], rewardPerGen);
            distributed += rewardPerGen;
            emit GenerationRewardPaid(upline[i], user, rewardPerGen, i + 1);
        }

        if (distributed < totalAmount) {
            USDT.transfer(marketingAddress, totalAmount - distributed);
        }
    }

    function _distributeTeamRewards(address user, uint256 totalAmount) private {
        address[] memory upline = referral.getReferrals(user, 50);
        uint256 lastLevel = 0;
        uint256 distributedAmount = 0;

        for (uint256 i = 0; i < upline.length; i++) {
            if (upline[i] == address(0)) break;

            uint256 currentLevel = userLevel[upline[i]];

            if (currentLevel > lastLevel) {
                uint256 rate = levels[currentLevel].rewardRate - levels[lastLevel].rewardRate;
                uint256 reward = (totalAmount * rate * 20) / (DENOMINATOR * 7);

                if (reward > 0) {
                    if (currentLevel == 7) {
                        accumulatedS7Reward += reward;
                        distributedAmount += reward;

                        if (accumulatedS7Reward >= 100 ether) {
                            _distributeS7Rewards();
                        }
                    } else {
                        USDT.transfer(upline[i], reward);
                        distributedAmount += reward;
                        emit TeamRewardPaid(upline[i], reward, currentLevel);
                    }
                }

                lastLevel = currentLevel;

                if (currentLevel == 7) {
                    break;
                }
            }
        }

        if (distributedAmount < totalAmount) {
            USDT.transfer(marketingAddress, totalAmount - distributedAmount);
        }
    }

    function _distributeS7Rewards() private {
        if (accumulatedS7Reward == 0) return;

        uint256 userCount = s7Users.length;

        if (userCount == 0) {
            USDT.transfer(marketingAddress, accumulatedS7Reward);
            accumulatedS7Reward = 0;
            return;
        }

        uint256 rewardPerUser = accumulatedS7Reward / userCount;
        uint256 totalDistributed = 0;

        for (uint256 i = 0; i < userCount; i++) {
            USDT.transfer(s7Users[i], rewardPerUser);
            emit TeamRewardPaid(s7Users[i], rewardPerUser, 7);
            totalDistributed += rewardPerUser;
        }

        emit S7RewardDistributed(totalDistributed, userCount, rewardPerUser);

        accumulatedS7Reward = 0;
    }

    function _swapUsdtForTokens(uint256 usdtAmount, address to) private {
        address[] memory path = new address[](2);
        path[0] = address(USDT);
        path[1] = address(XPLUS);

        uint256[] memory expectedAmounts = router.getAmountsOut(usdtAmount, path);
        uint256 minOutput = (expectedAmounts[1] * slippageTolerance) / 100;

        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            usdtAmount,
            minOutput,
            path,
            to,
            block.timestamp
        );
    }

    function _updatePerformance(address user, uint256 amount, bool isAdd) private {
        address[] memory uplines = referral.getReferrals(user, 50);
        for (uint256 i = 0; i < uplines.length; i++) {
            if (uplines[i] == address(0)) break;

            if(i == 0){
                if (isAdd) {
                    directPerformance[uplines[i]] += amount;
                } else {
                    if (directPerformance[uplines[i]] >= amount) {
                        directPerformance[uplines[i]] -= amount;
                    } else {
                        directPerformance[uplines[i]] = 0;
                    }
                }
            }

            if (isAdd) {
                teamPerformance[uplines[i]] += amount;
            } else {
                if (teamPerformance[uplines[i]] >= amount) {
                    teamPerformance[uplines[i]] -= amount;
                } else {
                    teamPerformance[uplines[i]] = 0;
                }
            }

            _updateZonePerformance(uplines[i]);

            _checkAndUpdateLevel(uplines[i]);
        }
    }

    function _updateZonePerformance(address user) private {
        address[] memory directs = referral.getDirectReferrals(user);
        uint256 maxBranchPerformance = 0;
        uint256 totalBranchPerformance = 0;

        for (uint256 i = 0; i < directs.length; i++) {
            uint256 branchPerformance = userTotalStaked[directs[i]] + teamPerformance[directs[i]];
            if (branchPerformance > maxBranchPerformance) {
                maxBranchPerformance = branchPerformance;
            }
            totalBranchPerformance += branchPerformance;
        }

        zonePerformance[user] = totalBranchPerformance - maxBranchPerformance;
    }

    function _checkAndUpdateLevel(address user) private {
        uint256 zonePerf = zonePerformance[user];
        uint256 oldLevel = userLevel[user];
        uint256 newLevel = _calculateLevel(zonePerf);

        if (newLevel != oldLevel) {
            userLevel[user] = newLevel;

            if (newLevel > highestLevelReached[user]) {
                uint256 oldHighest = highestLevelReached[user];
                highestLevelReached[user] = newLevel;

                if (newLevel >= 3) {
                    for (uint256 lvl = oldHighest + 1; lvl <= newLevel; lvl++) {
                        if (lvl >= 3 && lvl <= 7) {
                            uint256 quota = levels[lvl].yplusBuyQuota;
                            if (quota > 0) {
                                yplusSwap.addOneTimeBuyQuota(user, quota);
                            }
                        }
                    }
                }
            }

            if (newLevel == 7 && oldLevel != 7) {
                _addS7User(user);
            } else if (oldLevel == 7 && newLevel != 7) {
                _removeS7User(user);
            }

            emit LevelUpdated(user, oldLevel, newLevel);
        }
    }

    function _calculateLevel(uint256 zonePerf) private view returns (uint256) {
        for (uint256 i = 7; i > 0; i--) {
            if (zonePerf >= levels[i].requiredZonePerformance) {
                return i;
            }
        }
        return 0;
    }

    function _addS7User(address user) private {
        if (!isS7User[user]) {
            s7UserIndex[user] = s7Users.length;
            s7Users.push(user);
            isS7User[user] = true;
            emit S7UserAdded(user);
        }
    }

    function _removeS7User(address user) private {
        if (isS7User[user]) {
            uint256 index = s7UserIndex[user];
            uint256 lastIndex = s7Users.length - 1;

            if (index != lastIndex) {
                address lastUser = s7Users[lastIndex];
                s7Users[index] = lastUser;
                s7UserIndex[lastUser] = index;
            }

            s7Users.pop();
            delete isS7User[user];
            delete s7UserIndex[user];

            emit S7UserRemoved(user);
        }
    }

    function updateLevel(address user) public {
        _checkAndUpdateLevel(user);
    }

    function getUserLevel(address user) external view returns (uint256) {
        return userLevel[user];
    }

    function getUserLevelInfo(address user) external view returns (
        uint256 level,
        uint256 highestLevel,
        string memory name,
        uint256 rewardRate,
        uint256 yplusBuyQuota,
        uint256 currentZonePerf,
        uint256 nextLevelRequired
    ) {
        level = userLevel[user];
        highestLevel = highestLevelReached[user];
        Level memory levelInfo = levels[level];

        name = levelInfo.name;
        rewardRate = levelInfo.rewardRate;
        yplusBuyQuota = levelInfo.yplusBuyQuota;
        currentZonePerf = zonePerformance[user];

        if (level < 7) {
            nextLevelRequired = levels[level + 1].requiredZonePerformance;
        } else {
            nextLevelRequired = 0;
        }

        return (level, highestLevel, name, rewardRate, yplusBuyQuota, currentZonePerf, nextLevelRequired);
    }

    function getLevelConfig(uint256 level) external view returns (Level memory) {
        require(level <= 7, "Invalid level");
        return levels[level];
    }

    function getAllLevelConfigs() external view returns (Level[8] memory) {
        return levels;
    }

    function calculateUserLevel(address user) external view returns (uint256) {
        uint256 zonePerf = zonePerformance[user];
        return _calculateLevel(zonePerf);
    }

    function manualAllocation() external nonReentrant {
        _distributeS7Rewards();

        if (accumulatedYplusFee > 0) {
            USDT.transfer(address(yplusSwap), accumulatedYplusFee);
            accumulatedYplusFee = 0;
        }

        if (accumulatedXplusFee > 0) {
            _swapUsdtForTokens(accumulatedXplusFee, xplusAirdropAddress);
            accumulatedXplusFee = 0;
        }

        uint256 remainingUsdt = USDT.balanceOf(address(this));
        if (remainingUsdt > 0) {
            address pair = XPLUS.uniswapV2Pair();
            if (pair != address(0)) {
                USDT.transfer(pair, remainingUsdt);
                IUniswapV2Pair(pair).sync();
            }
        }
    }

    function getUserOrders(address user) external view returns (StakingOrder[] memory) {
        return userOrders[user];
    }

    function getUserStats(address user) external view returns (
        uint256 totalStaked,
        uint256 totalWithdrawn,
        uint256 orderCount,
        uint256 activeOrderCount
    ) {
        totalStaked = userTotalStaked[user];
        totalWithdrawn = userTotalWithdrawn[user];
        orderCount = userOrders[user].length;

        for (uint256 i = 0; i < userOrders[user].length; i++) {
            if (!userOrders[user][i].isWithdrawn) {
                activeOrderCount++;
            }
        }

        return (totalStaked, totalWithdrawn, orderCount, activeOrderCount);
    }

    function batchCalculateRewards(address user, uint256[] calldata orderIds)
        external
        view
        returns (uint256[] memory rewards)
    {
        rewards = new uint256[](orderIds.length);
        for (uint256 i = 0; i < orderIds.length; i++) {
            rewards[i] = calculateReward(user, orderIds[i]);
        }
        return rewards;
    }

    function getAvailableGlobalLimit() external view returns (
        uint256 maxPerMinute,
        uint256 used,
        bool windowReset,
        uint256 timeUntilReset
    ) {
        return _getGlobalLimitData();
    }

    function stakeForUSDT(uint256 amount) external nonReentrant{
        require(amount > 0, "Amount must be greater than 0");

        USDT.transferFrom(msg.sender, address(this), amount);
        _processStakingFunds(amount, msg.sender);
    }

    function setReferral(address _referral) external onlyOwner {
        referral = IReferral(_referral);
    }

    function setYPLUSSwap(address _yplusSwap) external onlyOwner {
        yplusSwap = IYPLUSSwap(_yplusSwap);
    }

    function setMaxStakePerTx(uint256 _max) external onlyOwner {
        maxStakePerTx = _max;
    }

    function setGlobalRatePerMinute(uint256 _rate) external onlyOwner {
        require(_rate <= 1000, "Rate too high");
        globalRatePerMinute = _rate;
    }

    function setDailyQuotaRate(uint256 _rate) external onlyOwner {
        require(_rate >= 100 && _rate <= 100000, "Rate must be 100-100000");
        dailyQuotaRate = _rate;
    }

    function setPlan(uint256 planId, uint256 duration, uint256 timeUnit, uint256 dailyRate, bool enabled) external onlyOwner {
        require(planId < 3, "Invalid plan");
        require(timeUnit > 0, "Invalid timeUnit");
        require(duration > 0, "Duration must be positive");
        require(dailyRate > 0 && dailyRate <= 1000, "Daily rate out of range");
        require(duration <= type(uint256).max / timeUnit, "Duration overflow");
        plans[planId] = StakingPlan(duration, timeUnit, dailyRate, enabled);
    }

    function setAddresses(
        address _xplusAirdrop,
        address _marketing
    ) external onlyOwner {
        xplusAirdropAddress = _xplusAirdrop;
        marketingAddress = _marketing;
    }

    function setSlippageTolerance(uint256 _slippageTolerance) external onlyOwner {
        require(_slippageTolerance >= 50 && _slippageTolerance <= 100, "Slippage must be 50-100");
        slippageTolerance = _slippageTolerance;
    }

    function setLevelConfig(
        uint256 level,
        uint256 requiredPerformance,
        uint256 rewardRate,
        uint256 yplusBuyQuota,
        string memory name
    ) external onlyOwner {
        require(level > 0 && level <= 7, "Invalid level");
        require(rewardRate <= 10000, "Invalid reward rate");

        levels[level] = Level(requiredPerformance, rewardRate, yplusBuyQuota, name);
    }

    function emergencyWithdraw(address token, uint256 amount) external onlyOwner {
        if (token == address(0)) {
            payable(owner()).transfer(amount);
        } else {
            IERC20(token).transfer(owner(), amount);
        }
    }

    receive() external payable {}
}
