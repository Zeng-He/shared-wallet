//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Whitelisted.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

contract Wallet is Whitelisted {
    using SafeMath for uint;

    uint public internalBalance;
    uint public dailyWithdrawalAllowance;
    uint public dailyWithdrawalRemaining;
    uint public lastWithdrawalResetTime;

    constructor () {
        dailyWithdrawalAllowance = 100;
        dailyWithdrawalRemaining = dailyWithdrawalAllowance;
        lastWithdrawalResetTime = block.timestamp;
    }

    receive () payable external {
        internalBalance = internalBalance.add(msg.value);
        emit Logging("Che te dejaron plata gil");
    }

    fallback () payable external {
        internalBalance = internalBalance.add(msg.value);
        emit Logging("Che te dejaron plata gil");
    }

    function SetDailyWithdrawalAllowance(uint _amount) public OnlyOwner {
        // update remaining allowance based in the difference of the new amount
        //dailyWithdrawalRemaining = uint(int(dailyWithdrawalRemaining) + int(_amount - dailyWithdrawalAllowance));
        dailyWithdrawalAllowance = _amount;
    }

    // yes.. I like to be specific as hell
    function IsMoreThanADayAfterLastWithdrawalAmountReset() public view returns(bool) {
        return (block.timestamp - lastWithdrawalResetTime) > 1 days;
    }

    function MoveLastWithdrawaResetlToThePast() public {
        lastWithdrawalResetTime = lastWithdrawalResetTime - 1 days;
    }

    function WithdrawMoney(uint _amount) public payable OnlyWhitelisted {
        // if more than a day went through after last allowance amount reset
        // reset remaining withdrawal allowance
        if(IsMoreThanADayAfterLastWithdrawalAmountReset()) {
            lastWithdrawalResetTime = block.timestamp;
            dailyWithdrawalRemaining = dailyWithdrawalAllowance;
        }

        if(!IsOwner()) {
            require(_amount <= dailyWithdrawalRemaining,
            "Que ondaa, no podes sacar mas plata de la que te dejan por hoy gato");
            dailyWithdrawalRemaining = dailyWithdrawalRemaining.sub(_amount);
        }

        internalBalance = internalBalance.sub(_amount);
        payable(msg.sender).transfer(_amount);
        emit Logging("Disfruta tu plata careta");
    }
}