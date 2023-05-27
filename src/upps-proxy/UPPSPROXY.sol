//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * 1-> create a unique slot position where to store the implementation address of contract
 * 2-> in the constructor: get the address of the logic contract , calldata that will initialize the state of the
 * contract
 * @notice the proxy contract have to be initializable;
 */
import {initializable} from "./initializable.sol";

contract proxy is initializable {
    /**
     * @dev this contract will only store the storage and it'll never excute any call in it's logic , all
     *  functions calls get delegated to the implementation contract
     */
    // the slot where to store the address of implemention( from openzeppelin);
    bytes32 logicPointer = 0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7;

    constructor(address logic, bytes memory data) {
        require(logic != address(0));
        // store the address of the implementation contract to a known slot in the storage
        assembly {
            sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, logic)
        }
        // excute the call data , this will be any data
        (bool seccess,) = logic.delegatecall(data);
        require(seccess, "failed to call data ");
    }

    /**
     * @dev fallback function is called when ever the calldata function sig does't match any of the functions
     * @dev in the smart contract , and it have a limit of 23000 gas
     */
    // write the fallback function :
    fallback() external payable {
        assembly {
            // get the logic address to delegate call to it :
            let logicC := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
            // get the calldata (the func sig + params encoded) and copy it to memory
            calldatacopy(0x0, 0x0, calldatasize())
            //delegate call to the logic address with the calldata that we stored in memory at(0x0)
            // callig the size of it ,and since we do not know the returned datasize returned it to 0;
            let success := delegatecall(sub(gas(), 10000), logicC, 0x0, calldatasize(), 0, 0)
            // get the size of the returned data
            let retSz := returndatasize()
            // copy the returned data to memory at slot 0;
            returndatacopy(0, 0, retSz)

            switch success
            // here check if the delegatecall was failed (0) we just revert with the returned data
            case 0 { revert(0, retSz) }
            // otherwise the call was seccessfull(1) we returned the data returned from the delegatecall
            default { return(0, retSz) }
        }
    }

    receive() external payable {}
}
