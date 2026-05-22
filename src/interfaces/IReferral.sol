// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IReferral {
    function referrer(address user) external view returns (address);
    function hasBound(address user) external view returns (bool);
    function bind(address _referrer) external;
    function getUpline(address user) external view returns (address[] memory);
    function getReferrals(address user, uint256 num) external view returns (address[] memory);
    function getDirectReferrals(address user) external view returns (address[] memory);
    function getDirectReferralCount(address user) external view returns (uint256);
    function getReferralInfo(address user) external view returns (address _referrer, uint256 _directCount, bool _hasBound);
}
