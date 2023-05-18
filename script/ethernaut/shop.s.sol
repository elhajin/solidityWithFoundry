//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import {hackShop} from "../../src/ethernaut/shop.sol";
import "forge-std/console.sol";

contract deployHakcShop is Script {
    function run() public {
        vm.startBroadcast();
        hackShop hak = new hackShop();
        hak.callbuy();
        vm.stopBroadcast();
    }
}
