// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract JapanRewardsCoin is ERC20, Ownable {
    uint256 public jackpotPool;
    uint256 public jackpotFeeRate;
    uint256 public jackpotWinRate;
    uint256 public fixedCashbackPointAmount;
    uint256 public cashbackPointRate;
    mapping(address => uint256) public points;

    event JackpotWon(address indexed winner, uint256 amount);
    event FixedCashbackPointAmount(address indexed recipient, uint256 amount);
    event CashbackPointRate(address indexed recipient, uint256 amount);

    // Struct for location-based permissions
    struct Location {
        bool isAllowed;
        uint256 maxAmount;
    }
    mapping(address => Location) public locationPermissions;

    constructor(uint256 initialSupply, uint256 _fixedCashbackPointAmount, uint256 _cashbackPointRate, uint256 _jackpotFeeRate) ERC20("JapanRewardsCoin", "JPRC") {
        _mint(msg.sender, initialSupply);
        fixedCashbackPointAmount = _fixedCashbackPointAmount;
        cashbackPointRate = _cashbackPointRate;
        jackpotFeeRate = _jackpotFeeRate;
        jackpotWinRate = 5;
    }

    function setCashback(uint256 _fixedCashbackPointAmount, uint256 _cashbackPointRate) public onlyOwner {
        fixedCashbackPointAmount = _fixedCashbackPointAmount;
        cashbackPointRate = _cashbackPointRate;
    }

    function setJackpotFeeRate(uint256 _jackpotFeeRate) public onlyOwner {
        jackpotFeeRate = _jackpotFeeRate;
    }

    function setJackpotWinRate(uint256 _jackpotWinRate) public onlyOwner {
        jackpotWinRate = _jackpotWinRate;
    }

    function setLocationPermission(address account, bool isAllowed, uint256 maxAmount) public onlyOwner {
        locationPermissions[account] = Location(isAllowed, maxAmount);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        // require(locationPermissions[recipient].isAllowed, "Recipient location not allowed for transactions");

        uint256 fee = (amount * jackpotFeeRate) / 100;
        jackpotPool += fee;
        uint256 amountAfterFee = amount - fee;

        bool success = super.transfer(recipient, amountAfterFee);
        if (success) {
            // Fixed cashback
            points[recipient] += fixedCashbackPointAmount;
            emit FixedCashbackPointAmount(recipient, fixedCashbackPointAmount);

            // Percentage cashback
            uint256 cashback = (amount * cashbackPointRate) / 100;
            points[recipient] += cashback;
            emit CashbackPointRate(recipient, cashback);

            // Jackpot logic
            if (random() % 100 < jackpotWinRate) { 
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
