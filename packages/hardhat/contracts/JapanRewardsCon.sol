// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract JapanRewardsCon is ERC20, Ownable {
    uint256 public fixedCashback;
    uint256 public percentageCashback;
    uint256 public jackpotPercentage;
    uint256 public jackpotPool;
    mapping(address => uint256) public points;

    event JackpotWon(address indexed winner, uint256 amount);
    event FixedCashback(address indexed recipient, uint256 amount);
    event PercentageCashback(address indexed recipient, uint256 amount);

    // Struct for location-based permissions
    struct Location {
        bool isAllowed;
        uint256 maxAmount;
    }
    mapping(address => Location) public locationPermissions;

    constructor(uint256 initialSupply, uint256 _fixedCashback, uint256 _percentageCashback, uint256 _jackpotPercentage) ERC20("JapanRewardsCon", "JPRC") {
        _mint(msg.sender, initialSupply);
        fixedCashback = _fixedCashback;
        percentageCashback = _percentageCashback;
        jackpotPercentage = _jackpotPercentage;
    }

    function setCashback(uint256 _fixedCashback, uint256 _percentageCashback) public onlyOwner {
        fixedCashback = _fixedCashback;
        percentageCashback = _percentageCashback;
    }

    function setJackpotPercentage(uint256 _jackpotPercentage) public onlyOwner {
        jackpotPercentage = _jackpotPercentage;
    }

    function setLocationPermission(address account, bool isAllowed, uint256 maxAmount) public onlyOwner {
        locationPermissions[account] = Location(isAllowed, maxAmount);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(locationPermissions[recipient].isAllowed, "Recipient location not allowed for transactions");

        uint256 fee = (amount * jackpotPercentage) / 100;
        jackpotPool += fee;
        uint256 amountAfterFee = amount - fee;

        bool success = super.transfer(recipient, amountAfterFee);
        if (success) {
            // Fixed cashback
            points[recipient] += fixedCashback;
            emit FixedCashback(recipient, fixedCashback);

            // Percentage cashback
            uint256 cashback = (amount * percentageCashback) / 100;
            points[recipient] += cashback;
            emit PercentageCashback(recipient, cashback);

            // Jackpot logic
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
