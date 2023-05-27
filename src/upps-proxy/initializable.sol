//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";

// import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
abstract contract initializable {
    error IsAlreadyInitializing();
    // this event emmited when ever the contract get initialized;

    event initialized(address contractAddress);
    // variable to track initializing the contract

    bool private initializing;
    //uint8 that will change to 1 when ever the contract get initialized;
    bool public INITIALIZED;
    /**
     * @dev here we gonna create a modifier that prevent our implementation contract from
     * get initialized more the once.
     */

    modifier Initializer() {
        // check if the contract not already initializing, and set it to mode initializing
        require(!initializing == true, "contract initializing");
        initializing = true;

        // check that the contract did not initialized
        require(!INITIALIZED && initializing, "already initialized");

        _;
        //set initialized to true so no more initialize
        INITIALIZED = true;
        initializing = false;
        emit initialized(address(this));
    }

    modifier Initializing() {
        require(initializing, "the contract not in mood initializing");
        _;
    }

    /**
     * @dev this function is a function called for the contract that do need to be initializable, so the function
     * with the Initializer modifier will never be called in the contract (only in case the call delegated to it)
     */
    function _NoN_initializable() internal {
        INITIALIZED = true;
    }
}
