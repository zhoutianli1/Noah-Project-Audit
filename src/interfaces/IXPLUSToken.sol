// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IXPLUSToken is IERC20 {
    function recycleLiquidity(uint256 amount) external;
    function getUserTotalBuyValue(address user) external view returns (uint256);
    function uniswapV2Pair() external view returns (address);
    function interactionContract() external view returns (address);
}
