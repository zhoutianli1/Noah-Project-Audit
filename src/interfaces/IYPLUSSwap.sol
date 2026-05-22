// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IYPLUSSwap {
    function addDailyBuyQuota(address user, uint256 amount) external;
    function addOneTimeBuyQuota(address user, uint256 quota) external;
}
