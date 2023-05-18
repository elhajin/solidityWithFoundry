// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

// take the ownership by calling the funciton : puzzleProxy.proposeNewAdmin(yourAddress);
// add the address of the owner to the whitelist: puzzleProxy.addToWhitelist(youraddress);
// to call the setMaxBalance function || we have to be in the whitelist, and the balance of contract have to be 0
// the balance of the contract is already 0.001;
// call deposit will add an value for us in balances;
// call excute will send us the value : should be equal or less than our balance;

interface Ipuzzle {
    // PuzzleProxy interface
    function pendingAdmin() external view returns (address);

    function admin() external view returns (address);

    function proposeNewAdmin(address _newAdmin) external;

    function approveNewAdmin(address _expectedAdmin) external;

    function upgradeTo(address _newImplementation) external;

    // PuzzleWallet interface
    function owner() external view returns (address);

    function maxBalance() external view returns (uint256);

    function whitelisted(address _addr) external view returns (bool);

    function balances(address _addr) external view returns (uint256);

    function init(uint256 _maxBalance) external;

    function setMaxBalance(uint256 _maxBalance) external;

    function addToWhitelist(address _addr) external;

    function deposit() external payable;

    function execute(
        address _to,
        uint256 _value,
        bytes calldata _data
    ) external payable;

    function multicall(bytes[] calldata _data) external payable;
}

contract PuzzleProxy is ERC1967Proxy {
    address public pendingAdmin; //any one can call :: become owner;
    address public admin;

    constructor(
        address _admin,
        address _implementation,
        bytes memory _initData
    ) ERC1967Proxy(_implementation, _initData) {
        admin = _admin;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Caller is not the admin");
        _;
    }

    function proposeNewAdmin(address _newAdmin) external {
        pendingAdmin = _newAdmin;
    }

    function approveNewAdmin(address _expectedAdmin) external onlyAdmin {
        require(
            pendingAdmin == _expectedAdmin,
            "Expected new admin by the current admin is not the pending admin"
        );
        admin = pendingAdmin;
    }

    function upgradeTo(address _newImplementation) external onlyAdmin {
        _upgradeTo(_newImplementation);
    }
}

contract PuzzleWallet {
    address public owner;
    uint256 public maxBalance; // you have to set it to your address ;
    mapping(address => bool) public whitelisted;
    mapping(address => uint256) public balances;

    function init(uint256 _maxBalance) public {
        require(maxBalance == 0, "Already initialized");
        maxBalance = _maxBalance;
        owner = msg.sender;
    }

    modifier onlyWhitelisted() {
        require(whitelisted[msg.sender], "Not whitelisted");
        _;
    }

    function setMaxBalance(uint256 _maxBalance) external onlyWhitelisted {
        require(address(this).balance == 0, "Contract balance is not 0");
        maxBalance = _maxBalance;
    }

    function addToWhitelist(address addr) external {
        require(msg.sender == owner, "Not the owner");
        whitelisted[addr] = true;
    }

    function deposit() external payable onlyWhitelisted {
        require(address(this).balance <= maxBalance, "Max balance reached");
        balances[msg.sender] += msg.value;
    }

    function execute(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable onlyWhitelisted {
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        (bool success, ) = to.call{value: value}(data);
        require(success, "Execution failed");
    }

    function multicall(bytes[] calldata data) external payable onlyWhitelisted {
        bool depositCalled = false;
        for (uint256 i = 0; i < data.length; i++) {
            bytes memory _data = data[i];
            bytes4 selector;
            assembly {
                selector := mload(add(_data, 32))
            }
            if (selector == this.deposit.selector) {
                require(!depositCalled, "Deposit can only be called once");
                // Protect against reusing msg.value
                depositCalled = true;
            }
            (bool success, ) = address(this).delegatecall(data[i]); // pass the selectore of deposit and the amount as params encoded ;
            require(success, "Error while delegating call");
        }
    }
}
