//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "forge-std/Test.sol";
import "forge-std/console.sol";
import {hack} from "../../src/ethernaut/goodSamatitan.sol";

contract hackSamatitan is Test {
    hack hackit;
    uint fork;
    string sepolia = vm.envString("sepolia_url");
    address coin = 0xa1eBb0a73312734fcdB4E73B713CB42fddE2ADCb;

    function setUp() public {
        vm.createFork(sepolia);
        vm.selectFork(fork);
    }

    function test_hackIt() public {
        assertEq(vm.activeFork(), fork);
        // deploy the hack contract :
        hackit = new hack();
        hackit.callIt();
        (, bytes memory balance) = coin.call(
            abi.encodeWithSignature("balances(address)", address(hackit))
        );
        uint balanceHack = abi.decode(balance, (uint));
        console.log(balanceHack);
    }
}
