//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "forge-std/console.sol";

import {hack} from "../../src/ethernaut/goodSamatitan.sol";

contract hackIt is Script {
    // deploy the cantract hack
    // call the funtion callIt() from the hack contract
    hack newHack;

    function run() public {
        vm.startBroadcast();
        newHack = new hack();
        newHack.callIt();
        vm.stopBroadcast();
    }
}
