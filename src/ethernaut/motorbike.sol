//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract hackMotobike {
    function kill() public {
        selfdestruct(payable(address(0)));
    }
}
