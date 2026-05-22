// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IReferral.sol";

contract Referral is Ownable, IReferral {

    uint256 public constant MAX_GENERATION = 10;

    address public immutable topAddress;

    mapping(address => address) public referrer;

    mapping(address => address[]) public directReferrals;

    mapping(address => bool) public hasBound;

    event ReferralBound(address indexed user, address indexed referrer);

    constructor(address topAddress_) {
        topAddress = topAddress_;
        referrer[topAddress] = address(0);
        hasBound[topAddress] = true;
    }

    function bind(address _referrer) external {
        require(!hasBound[msg.sender], "Already bound");
        require(_referrer != address(0), "Invalid referrer");
        require(_referrer != msg.sender, "Cannot refer yourself");
        require(hasBound[_referrer], "parent must be bind!");
        require(msg.sender != topAddress, "child can not topAddress!");

        referrer[msg.sender] = _referrer;
        directReferrals[_referrer].push(msg.sender);
        hasBound[msg.sender] = true;

        emit ReferralBound(msg.sender, _referrer);
    }

    function getUpline(address user) external view returns (address[] memory) {
        address[] memory upline = new address[](MAX_GENERATION);
        address current = referrer[user];
        uint256 count = 0;

        for (uint256 i = 0; i < MAX_GENERATION && current != address(0); i++) {
            upline[count] = current;
            count++;
            current = referrer[current];
        }

        address[] memory result = new address[](count);
        for (uint256 i = 0; i < count; i++) {
            result[i] = upline[i];
        }

        return result;
    }

    function getReferrals(address user, uint256 num)public view returns(address[] memory) {
        address[] memory ups = new address[](num);
        address cur = referrer[user];
        uint256 i = 0;
        while (cur != address(0) && i < num) {
            ups[i] = cur;
            unchecked { i++; }
            cur = referrer[cur];
        }
        if (i < num) {
            assembly { mstore(ups, i) }
        }
        return ups;
    }

    function getDirectReferrals(address user) external view returns (address[] memory) {
        return directReferrals[user];
    }

    function getDirectReferralCount(address user) external view returns (uint256) {
        return directReferrals[user].length;
    }

    function getReferralInfo(address user) external view returns (
        address _referrer,
        uint256 _directCount,
        bool _hasBound
    ) {
        return (
            referrer[user],
            directReferrals[user].length,
            hasBound[user]
        );
    }

}
