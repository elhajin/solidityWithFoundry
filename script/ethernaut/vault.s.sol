// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "forge-std/Script.sol";

contract unlockme is Script {
    //i used cast to fetch the data from the 1 slot of the storage of the deployed contract
    // then i call the unlock function passing the data that i get from reading the evm ;
    /*
    data to pass(aka password): 
    address contract on sepolia: 0x1494bD82bf2C5840E1D712910588FD7a972592b8
    */
    address lock = 0x1494bD82bf2C5840E1D712910588FD7a972592b8;
    bytes32 password =
        0x412076657279207374726f6e67207365637265742070617373776f7264203a29;

    function run() public {
        vm.startBroadcast();
        (bool ok, ) = lock.call(
            abi.encodeWithSignature("unlock(bytes32)", password)
        );
        require(ok, "tx failed");
        vm.stopBroadcast();
    }
}
