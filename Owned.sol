//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./EventEmitter.sol";

contract Owned is EventEmitter {
    address owner;

    constructor () {
        owner = payable(msg.sender);
        emit Logging("Vamoooo se creo la app putooh");
    }

    modifier OnlyOwner {
        require(IsOwner(), "Vos no sos el duenho capo, tomatela");
        _;
    }

    function IsOwner() internal view returns(bool) {
        return msg.sender == owner;
    }

    function destroySmartContract(address payable _to) OnlyOwner public {
        emit Logging("Al tachooo, se termino la joda");
        /* hardwired to */selfdestruct(_to);
    }
}