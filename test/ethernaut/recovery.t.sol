// the actual address on ether scan : 0xcF2E225EA9D87132D760Ea0F9f393E1d446C71Cd
// the level can be done by calling the function destroy passing our address after fetching the address from ether scan
// using cast : cast send <address> "destroy(address)""address to send funds" --private-key  --rpc-url
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Test.sol";
import "forge-std/console.sol";

// here we gonna calculate the address of the contract ;
contract testme is Test {
    function testfunc() public {
        address computedAddress = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xd6),
                            bytes1(0x94),
                            address(0x816cdbbBbc1FF4fC602a1d2014999B01593e44e4),
                            bytes1(0x01)
                        )
                    )
                )
            )
        );
        assertEq(computedAddress, 0xcF2E225EA9D87132D760Ea0F9f393E1d446C71Cd);
    }
}
