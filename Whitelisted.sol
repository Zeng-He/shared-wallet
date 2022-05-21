//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Owned.sol";

contract Whitelisted is Owned {

    mapping(address => bool) addresses;

    constructor () {
        addresses[msg.sender] = true;
    }

    function whitelistAddress(address _address) OnlyOwner public {
        addresses[_address] = true;
        emit Logging("Te habilitaron tu cuenta perro");
    }

    function blacklistAddress(address _address) OnlyOwner public {
        addresses[_address] = false;
        emit Logging("Uuuhh te mataron la cuenta bolastristes");
    }

    function IsWhitelisted(address _address) internal view returns(bool){
        return addresses[_address];
    }

    modifier OnlyWhitelisted {
        require(IsWhitelisted(msg.sender), "Pero quien te conoce papa");
        _;
    }
}