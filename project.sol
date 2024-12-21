// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FinancialStrategyGame {
    string public name = "Financial Strategy Game";
    string public symbol = "FSG";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => bool) public hasClaimedReward;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event RewardClaimed(address indexed player, uint256 reward);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply * 10**uint256(decimals);
        balanceOf[owner] = totalSupply;
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function rewardPlayer(address player, uint256 reward) public onlyOwner {
        require(!hasClaimedReward[player], "Player has already claimed reward");
        require(balanceOf[owner] >= reward, "Insufficient reward balance");

        hasClaimedReward[player] = true;
        balanceOf[owner] -= reward;
        balanceOf[player] += reward;
        emit RewardClaimed(player, reward);
    }

    function checkRewardEligibility(address player) public view returns (bool) {
        return !hasClaimedReward[player];
    }
}
