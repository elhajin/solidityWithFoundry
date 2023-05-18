// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "forge-std/console.sol";
import {hackDexTwo} from "../../src/ethernaut/dexTwo.sol";

contract hack is Script {
    hackDexTwo hackit;

    function run() public {
        vm.startBroadcast();
        hackit = new hackDexTwo();
        hackit.attack();
        vm.stopBroadcast();
    }
}
