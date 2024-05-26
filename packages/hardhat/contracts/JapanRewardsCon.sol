// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardYen is ERC20, Ownable {
    uint256 public cashbackPercentage;
    uint256 public jackpotPercentage;
    uint256 public jackpotPool;
    mapping(address => uint256) public points;

    event JackpotWon(address indexed winner, uint256 amount);

    constructor(uint256 initialSupply, uint256 _cashbackPercentage, uint256 _jackpotPercentage) ERC20("RewardYen", "RYEN") {
        _mint(msg.sender, initialSupply);
        cashbackPercentage = _cashbackPercentage;
        jackpotPercentage = _jackpotPercentage;
    }

    function setCashbackPercentage(uint256 _cashbackPercentage) public onlyOwner {
        cashbackPercentage = _cashbackPercentage;
    }

    function setJackpotPercentage(uint256 _jackpotPercentage) public onlyOwner {
        jackpotPercentage = _jackpotPercentage;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 fee = (amount * jackpotPercentage) / 100;
        jackpotPool += fee;
        uint256 amountAfterFee = amount - fee;

        bool success = super.transfer(recipient, amountAfterFee);
        if (success) {
            uint256 cashback = (amount * cashbackPercentage) / 100;
            points[recipient] += cashback;

            if (random() % 100 < 5) { // 5% の確率でジャックポット
                uint256 jackpotAmount = jackpotPool;
                jackpotPool = 0;
                _mint(recipient, jackpotAmount);
                emit JackpotWon(recipient, jackpotAmount);
            }
        }
        return success;
    }

    function redeemPoints(address account, uint256 amount) public onlyOwner {
        require(points[account] >= amount, "Not enough points");
        points[account] -= amount;
        _mint(account, amount);
    }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
    }
}
