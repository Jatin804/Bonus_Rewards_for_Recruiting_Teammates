// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BonusRewards {
    address public owner;
    mapping(address => uint256) public rewards;
    event RewardAssigned(address indexed recruiter, address indexed recruit, uint256 amount);
    event RewardClaimed(address indexed recruiter, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action.");
        _;
    }

    modifier hasRewards() {
        require(rewards[msg.sender] > 0, "No rewards available to claim.");
        _;
    }

    function assignReward(address recruiter, address recruit, uint256 amount) external onlyOwner {
        require(recruiter != address(0) && recruit != address(0), "Invalid addresses.");
        require(amount > 0, "Reward amount must be greater than zero.");
        
        rewards[recruiter] += amount;
        emit RewardAssigned(recruiter, recruit, amount);
    }

    function claimReward() external hasRewards {
        uint256 rewardAmount = rewards[msg.sender];
        rewards[msg.sender] = 0;

        payable(msg.sender).transfer(rewardAmount);
        emit RewardClaimed(msg.sender, rewardAmount);
    }

    function deposit() external payable onlyOwner {
        require(msg.value > 0, "Must deposit non-zero amount.");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
