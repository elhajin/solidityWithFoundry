// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/counter.sol";

contract CounterTest is Test {
    Counter public counter;
    address ownBy;

    //setUp should be public or external:
    function setUp() public {
        counter = new Counter();
        console.log("the contract is deployed at ", address(counter));
    }

    function test_sum(uint x) public {
        counter.sum(x);
        uint newVal = counter.result();
        assertEq(newVal, x);
    }

    function testFailDec() public {
        counter.dec(1);
    }

    function test_decWithError() public {
        vm.expectRevert(stdError.arithmeticError); //this refer to type of error
        counter.dec(2);
    }

    function test_changeOwner() public {
        assertEq(counter.owner(), address(this));
        counter.changeOwner(address(counter));
        address newOwner = counter.owner();
        assertEq(newOwner, address(counter));
    }

    function test_ChangeOwnerFail() public {
        vm.prank(address(120));
        vm.expectRevert("modifier fail check -NOT OWNER-"); //it'takes message error
        counter.changeOwner(address(counter));
    }
}
/* TEST KEYWORDS:
- assertNotEq(value1, value2) : that the provided values not equal;
-
*/
