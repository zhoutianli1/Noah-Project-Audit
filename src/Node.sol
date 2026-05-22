// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Node
 * @dev 由反编译代码重构而来的节点分红合约
 */
contract Node is Ownable, ReentrancyGuard {
    
    struct NodeInfo {
        address owner;
        uint256 creationTime;
        uint256 totalClaimed;
        bool isActive;
    }

    IERC20 public constant USDT = IERC20(0x55d398326f99059fF775485246999027B3197955);
    uint256 public constant MAX_NODES = 2000;

    NodeInfo[] public nodes;
    mapping(address => uint256[]) public userNodeIndices;
    mapping(address => bool) public isNode;
    uint256 public nodeCount;
    
    uint256 public rewardPool;
    uint256 public accRewardPerNode;
    mapping(uint256 => uint256) public nodeRewardDebt; // 记录每个节点上次结算时的 accRewardPerNode
    
    bool public rewardEnabled;

    event RewardAdded(uint256 amount, uint256 newAccReward);
    event RewardClaimed(address indexed user, uint256 indexed nodeIndex, uint256 amount);
    event NodeAdded(address indexed user, uint256 nodeIndex, uint256 timestamp);
    event NodeTransferred(uint256 indexed nodeIndex, address indexed from, address indexed to);
    event RewardEnabledUpdated(bool enabled);

    constructor() Ownable() {}

    // --- 核心逻辑 ---

    /**
     * @dev 更新全局每节点累计收益
     * 对应原代码中的 0x161b
     */
    function updateRewards() public {
        uint256 currentBalance = USDT.balanceOf(address(this));
        
        if (currentBalance > rewardPool && nodeCount > 0 && rewardEnabled) {
            uint256 newRewards = currentBalance - rewardPool;
            rewardPool = currentBalance;
            // 使用 1e18 精度计算
            accRewardPerNode += (newRewards * 1e18) / nodeCount;
            emit RewardAdded(newRewards, accRewardPerNode);
        }
    }

    /**
     * @dev 计算指定节点的待领取收益
     * 对应原代码中的 0x14b8
     */
    function pendingReward(uint256 index) public view returns (uint256) {
        if (index >= nodes.length) return 0;
        NodeInfo storage node = nodes[index];
        
        if (node.isActive && rewardEnabled) {
            uint256 reward = (accRewardPerNode - nodeRewardDebt[index]) / 1e18;
            return reward;
        }
        return 0;
    }

    /**
     * @dev 领取节点收益
     */
    function claimNodeReward(uint256 index) public nonReentrant {
        require(index < nodes.length, "Invalid node");
        NodeInfo storage node = nodes[index];
        require(msg.sender == node.owner, "Not node owner");
        require(node.isActive, "Node not active");
        require(rewardEnabled, "Reward not enabled");

        updateRewards(); // 领取前先同步全局收益

        uint256 reward = pendingReward(index);
        require(reward > 0, "No reward to claim");

        // 更新节点账本
        nodeRewardDebt[index] = accRewardPerNode;
        node.totalClaimed += reward;
        rewardPool -= reward;

        USDT.transfer(msg.sender, reward);
        
        emit RewardClaimed(msg.sender, index, reward);
    }

    // --- 管理员功能 ---

    function addNode(address account) public onlyOwner {
        require(account != address(0), "Invalid address");
        require(nodeCount < MAX_NODES, "Exceeds max nodes");
        require(!isNode[account], "User is already a node");

        uint256 index = nodes.length;
        nodes.push(NodeInfo({
            owner: account,
            creationTime: block.timestamp,
            totalClaimed: 0,
            isActive: true
        }));

        userNodeIndices[account].push(index);
        nodeRewardDebt[index] = accRewardPerNode; // 设置起始收益锚点
        isNode[account] = true;
        nodeCount++;

        emit NodeAdded(account, index, block.timestamp);
    }

    function batchAddNodes(address[] calldata accounts) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            addNode(accounts[i]);
        }
    }

    function setRewardEnabled(bool value) external onlyOwner {
        rewardEnabled = value;
        emit RewardEnabledUpdated(value);
    }

    function setNodeActive(uint256 index, bool active) external onlyOwner {
        require(index < nodes.length, "Invalid node");
        nodes[index].isActive = active;
    }

    // --- 用户功能 ---

    function transferNode(uint256 index, address newOwner) public nonReentrant {
        require(index < nodes.length, "Invalid node");
        NodeInfo storage node = nodes[index];
        require(node.owner == msg.sender, "Not node owner");
        require(newOwner != address(0) && newOwner != msg.sender, "Invalid recipient");
        require(!isNode[newOwner], "User already has a node");

        // 转移前自动结算当前收益
        uint256 reward = pendingReward(index);
        if (reward > 0) {
            nodeRewardDebt[index] = accRewardPerNode;
            node.totalClaimed += reward;
            rewardPool -= reward;
            USDT.transfer(msg.sender, reward);
        }

        // 维护旧所有者的索引列表
        uint256[] storage oldIndices = userNodeIndices[msg.sender];
        for (uint256 i = 0; i < oldIndices.length; i++) {
            if (oldIndices[i] == index) {
                oldIndices[i] = oldIndices[oldIndices.length - 1];
                oldIndices.pop();
                break;
            }
        }
        if (oldIndices.length == 0) isNode[msg.sender] = false;

        // 设置新所有者
        node.owner = newOwner;
        userNodeIndices[newOwner].push(index);
        isNode[newOwner] = true;

        emit NodeTransferred(index, msg.sender, newOwner);
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