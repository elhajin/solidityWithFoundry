//SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract proxiable {
    /**
     * @dev this will be required to be inherited in each imlementation contract so we always can have
     * @dev the ability to upgrade our contract to a new version
     */
    event newUpgrade(address indexed newLogic);

    function _upgrade(address _newImplementation) internal returns (bool) {
        assembly {
            sstore(
                0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7,
                _newImplementation
            )
        }

        if (_newImplementation != currentLogic()) {
            return false;
        }
        emit newUpgrade(_newImplementation);
        return true;
    }

    //this function will return the current address for logic contract
    function currentLogic() public view returns (address currentAddr) {
        bytes32 addr;
        assembly {
            addr := sload(
                0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7
            )
        }
        currentAddr = address(uint160(uint256(addr)));
    }
}
