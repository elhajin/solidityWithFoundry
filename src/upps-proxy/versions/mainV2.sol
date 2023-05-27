//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {MainV1} from "./mainV1.sol";

contract MainV2 is MainV1 {
    /**
     * @dev in this version we will add a black list funciton that block any user to send or recive any token
     * @dev add a function to change the owner
     */
    mapping(address => bool) public isBlackList;
    modifier notBlackList() {
        require(!isBlackList[msg.sender], "blacklist");
        _;
    }

    function addToBlackList(address account) public OnlyOwner {
        isBlackList[account] = true;
    }

    function removeBlackList(address account) external OnlyOwner {
        require(isBlackList[account], "the address is not a blacklisted");
        isBlackList[account] = false;
    }

    // not allow a blacklist to send token
    function transfer(
        address to,
        uint256 amount
    ) public virtual override notBlackList returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    //not allow blacklist to approve token
    function approve(
        address spender,
        uint256 amount
    ) public virtual override notBlackList returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function changeOwner(address newOwner) external OnlyOwner {
        owner = newOwner;
    }
}
