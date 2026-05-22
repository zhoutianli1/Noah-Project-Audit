基础功能依赖 ：它唯一需要的标准“外部组件”是：
  ERC20 / ERC721 标准实现。
  Ownable 权限管理。
  ReentrancyGuard 防重入。
  SafeERC20 安全转账。
这些全部包含在 OpenZeppelin v4.9.6 中。

下载依赖：forge install OpenZeppelin/openzeppelin-contracts@v4.9.6

项目的业务逻辑（质押、层级、代币税收）都是自创的，并没有引用像 Chainlink、LayerZero 或 AAVE 这样的大型第三方协议。

