//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {proxy} from "../../src/upps-proxy/UPPSPROXY.sol";
import {MainV1} from "../../src/upps-proxy/versions/mainV1.sol";
import {MainV2} from "../../src/upps-proxy/versions/mainV2.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract testProxy is Test {
    // define our contract objects;
    proxy upp;
    MainV1 logic;
    MainV2 logic2;
    address own = address(123);
    bytes data = _getData("elhaj", "haj", 1000e18, own, 1e18);
    bytes32 slot =
        0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7;

    function setUp() public {
        //deploy the logic contract

        logic = new MainV1();

        vm.prank(own);
        upp = new proxy(address(logic), data);
    }

    function test_initialize() public {
        //check if you can call initialize more then once
        vm.expectRevert("already initialized");
        (bool seccess, ) = address(upp).call(data);
        assertFalse(seccess);
        //check if you can call initialize() from the implementation contract
        vm.expectRevert("already initialized");
        (bool ok, ) = address(logic).call(data);
        assertFalse(ok);
        // check if the initialize() did it's work as a constructor;
        (, bytes memory dat) = address(upp).call(
            abi.encodeWithSignature("balanceOf(address)", own)
        );
        assertEq(abi.decode(dat, (uint256)), 1000e18);
        (, bytes memory ddat) = address(upp).call(
            abi.encodeWithSignature("name()")
        );
        assertEq(abi.decode(ddat, (string)), "elhaj");
        (, bytes memory ddata) = address(upp).call(
            abi.encodeWithSignature("rewardPerDay()")
        );
        assertEq(abi.decode(ddata, (uint256)), 1e18);
    }

    function test_checkAddressImplementation() public {
        // check if the proxy stores the address of the implementation in the right slot

        address fromSlot = address(
            uint160(uint256(bytes32(vm.load(address(upp), slot))))
        );
        console.log(fromSlot, address(logic));
        assertEq(fromSlot, address(logic));
    }

    function test_upgrade() public {
        // deploy the mainV2
        logic2 = new MainV2();
        // try to upgrade from a non owner call
        vm.prank(address(3333));

        (bool ok, bytes memory revertedWith) = address(upp).call(
            abi.encodeWithSignature("upgrade(address)", address(logic2))
        );
        assertEq(
            abi.encodeWithSignature("Error(string)", "not owner"),
            revertedWith
        );
        assertTrue(!ok, "true");
        // try to upgrade with owner
        vm.startPrank(own);
        (bool okk, ) = address(upp).call(
            abi.encodeWithSignature("upgrade(address)", address(logic2))
        );
        assertTrue(okk);
        // check if the new implementaion is in the correct slot:
        address inSlot = address(
            uint160(uint256(bytes32(vm.load(address(upp), slot))))
        );
        assertEq(inSlot, address(logic2), "the address is diffrent");
        // now change the owner
        (bool changed, ) = address(upp).call(
            abi.encodeWithSignature("changeOwner(address)", address(8888))
        );
        require(changed, "call to change the owner failed");
        (, bytes memory owner) = address(upp).staticcall(
            abi.encodeWithSignature("owner()")
        );
        address newOwner = abi.decode(owner, (address));
        assertEq(newOwner, address(8888), "the owner did not change");
        // send token to a new address :
        (bool okkk, ) = address(upp).call(
            abi.encodeWithSignature(
                "transfer(address,uint256)",
                address(123456),
                1e19
            )
        ); //send 10token
        require(okkk, "send 10 token failed");
        // try to add the address to blacklist with NoN owner call
        (bool addToBlack, bytes memory reverted) = address(upp).call(
            abi.encodeWithSignature("addToBlackList(address)", address(123456))
        );
        assertFalse(addToBlack, "addtoBlacklist returned true");
        assertEq(
            reverted,
            abi.encodeWithSignature("Error(string)", "not owner")
        );
        // try to send token before blakclisted:
        vm.stopPrank();
        vm.startPrank(address(123456));
        (bool kk, ) = address(upp).call(
            abi.encodeWithSignature(
                "transfer(address,uint256)",
                address(2),
                2e18
            )
        );
        require(kk, "failed to send token even before blacklisted");
        (, bytes memory balance) = address(upp).staticcall(
            abi.encodeWithSignature("balanceOf(address)", address(123456))
        );
        assertEq(
            abi.decode(balance, (uint)),
            8e18,
            "the balance after sent did not match"
        );
        // add the address to blacklist with owner call
        vm.stopPrank();
        vm.startPrank(address(8888));
        (bool addtoblack, ) = address(upp).call(
            abi.encodeWithSignature("addToBlackList(address)", address(123456))
        );
        assertTrue(addtoblack, "addtoblack with owner returned false");
        (, bytes memory datata) = address(upp).staticcall(
            abi.encodeWithSignature("isBlackList(address)", address(123456))
        );
        assertTrue(abi.decode(datata, (bool)));
        vm.stopPrank();
        // try to send token with the address in blacklist
        vm.startPrank(address(123456));
        (bool send, bytes memory revertedwith) = address(upp).call(
            abi.encodeWithSignature("transfer(address,uint256)", address(3))
        );
        console.logBytes(revertedwith);
        assertFalse(send, "transfer from blacklisted account returnd true");

        // try to approve the token with address in blacklist
        (bool approved, bytes memory revertwith) = address(upp).call(
            abi.encodeWithSignature("approve(address,uint256)", address(33))
        );
        console.logBytes(revertwith);

        assertFalse(approved, "transfer from blacklisted account returnd true");
    }

    //helper function to get the data to call initilize function
    function _getData(
        string memory name,
        string memory symbol,
        uint256 amountToMint,
        address addressToMint,
        uint256 _rewaredPerDay
    ) public pure returns (bytes memory Data) {
        return
            abi.encodeWithSignature(
                "initialize(string,string,uint256,address,uint256)",
                name,
                symbol,
                amountToMint,
                addressToMint,
                _rewaredPerDay
            );
    }
}
