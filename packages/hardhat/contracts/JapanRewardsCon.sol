// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardYen is ERC20, Ownable {
    uint256 public cashbackPercentage;
    mapping(address => uint256) public points;

    constructor(uint256 initialSupply, uint256 _cashbackPercentage) ERC20("RewardYen", "RYEN") {
        _mint(msg.sender, initialSupply);
        cashbackPercentage = _cashbackPercentage;
    }

    function setCashbackPercentage(uint256 _cashbackPercentage) public onlyOwner {
        cashbackPercentage = _cashbackPercentage;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        bool success = super.transfer(recipient, amount);
        if (success) {
            uint256 cashback = (amount * cashbackPercentage) / 100;
            points[recipient] += cashback;
        }
        return success;
    }

    function redeemPoints(address account, uint256 amount) public onlyOwner {
        require(points[account] >= amount, "Not enough points");
        points[account] -= amount;
        _mint(account, amount);
    }
}
