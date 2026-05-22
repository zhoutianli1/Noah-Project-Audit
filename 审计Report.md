# Noah Project 智能合约安全审计报告

**报告版本：** v1.0  
**审计日期：** 2026-05-22  
**风险等级：**  **EXTREME RISK (极高风险)**  
**审计结论：** 项目存在多处严重的安全后门与逻辑缺陷，表现出明显的“资金盘”特征，建议禁止任何形式的资金交互。

---

## 1. 审计概述

### 1.1 审计范围
本次审计覆盖了 Noah 生态系统的核心业务合约：
- **XPULS.sol**: 生态主代币（包含复杂的税收与流动性操纵逻辑）
- **Staking.sol**: 核心入金质押逻辑
- **NoahNFT.sol**: NFT 铸造与质押系统
- **yplusSwap.sol**: YPLUS 代币的 OTC 交易中心
- **Node.sol**: 节点分红管理系统
- **Referral.sol**: 层级推荐系统

### 1.2 风险统计
| 风险等级 | 数量 | 状态 |
| :--- | :--- | :--- |
|  **Critical (致命)** | 3 | 待处理 |
|  **High (高危)** | 4 | 待处理 |
|  **Medium (中危)** | 2 | 待处理 |
|  **Low/Info (低危)** | 5+ | 待处理 |

---

## 2. 核心漏洞详情

### 2.1 [Critical] 管理员任意资金提取权限 (Emergency Withdrawal)
- **位置**：[XPULS.sol:L486](src/Token/XPULS.sol#L486), [Staking.sol:L830](src/Staking.sol#L830), [NoahNFT.sol:L75](src/NoahNFT.sol#L75)
- **描述**：所有核心合约均包含 `emergencyWithdraw` 或 `GetUSDTReward` 函数，允许管理员提取合约中存储的所有代币（USDT/XPULS）。
- **风险**：管理员私钥一旦泄露或项目方有意跑路，用户本金将瞬间清零。
- **举例**：在 [NoahNFT.sol:L75-79](src/NoahNFT.sol#L75-79) 中，`GetUSDTReward` 没有任何逻辑限制，只要是 `reward_addr` 即可提走所有 USDT。

### 2.2 [Critical] 质押即销毁：NFT 永久丢失风险
- **位置**：[NoahNFT.sol:L186](src/NoahNFT.sol#L186) 中的 `stakeNFTs` 函数
- **描述**：用户调用质押功能后，合约直接将 NFT 发送到黑洞地址 `0x...dEaD`。
- **风险**：该逻辑属于“自杀式”质押，用户无法通过任何函数赎回 NFT，所有权在技术层面已永久丧失。
- **代码实证**：`transferFrom(msg.sender, blackHole, tokenId);` 其中 `blackHole` 在 [L19](src/NoahNFT.sol#L19) 定义为死地址。

### 2.3 [High] 瞬时价格操纵漏洞 (Flash Loan Attack)
- **位置**：[yplusSwap.sol:L94-101](src/yplusSwap.sol#L94-L101) 中的 `getYPlusPrice` 函数
- **描述**：YPLUS 的定价完全依赖于合约内 XPULS 的实时余额（`xplusPoolBalance`）。
- **风险**：攻击者可利用闪电贷借入巨量 XPULS 并转账给合约，瞬间拉高 YPLUS 价格，随后卖出手中持有的 YPLUS 获利。
- **建议**：接入 Chainlink 预言机或使用 Uniswap V3 的 TWAP。

### 2.4 [High] 28% 超高额“利润税”
- **位置**：[XPULS.sol:L233-270](src/Token/XPULS.sol#L233-270) 的 `_transfer` 逻辑
- **描述**：合约监控用户的买入成本，若卖出时有盈利，将对增值部分征收高达 28% 的“利润税”。
- **风险**：极大地损害了投资者的利益，且该税率可由管理员随时修改。

---

## 3. 专项审计：分类检查清单

### 3.1 权限安全
- [x] **多签钱包**： 未使用。所有 Owner 权限均为 EOA 地址。见 [NoahNFT.sol:L53](src/NoahNFT.sol#L53)。
- [x] **时间锁 (Timelock)**： 未使用。参数修改立即生效。见 [NoahNFT.sol:L69](src/NoahNFT.sol#L69)。

### 3.2 逻辑安全
- [x] **重入攻击**： 风险。如 [NoahNFT.sol:L75-79](src/NoahNFT.sol#L75-79) 缺乏重入保护且先执行转账。
- [x] **女巫攻击**： 高风险。[Referral.sol:L27](src/Referral.sol#L27) 绑定逻辑无任何门槛，易被批量刷奖。

### 3.3 经济模型
- [x] **庞氏特征**： 确定。[Staking.sol:L432](src/Staking.sol#L432) 的 `Turbo` 机制强制老用户必须买入代币才能提现。

---

## 4. 结论与建议

**审计意见：不通过 (FAILED)**

该项目更像是一个精密设计的“抽毯子 (Rug Pull)”工具，而非去中心化金融协议。建议立即停止所有资金交互。

---
