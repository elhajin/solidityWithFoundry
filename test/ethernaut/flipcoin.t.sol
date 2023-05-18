//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {CoinFlip} from "../../src/ethernaut/coinflip.sol";

contract testFlip is Test {
    CoinFlip coinflip;

    function setUp() public {
        coinflip = new CoinFlip();
    }

    function test_coinflip() public {
        coinflip.flip(false);
        uint num = coinflip.consecutiveWins();
        assertEq(num, 1);
    }
}
