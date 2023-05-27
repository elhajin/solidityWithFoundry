//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/**
 * @dev this will be the first implementation of our proxy contract
 * @dev this contract should inherit from the initializeable contract so we get access to the "Initializer"
 *      modifier and also inherit from proxiabel contract so we'll be able to upgarade the contract
 * @dev the contract will be a simple erc20 token that have a feature to stake the token and get rewarded with the
 *      same token accourding to a percentage perday depends on the time you stake
 * @notice you have override the function upgrade by adding the modifier onlyOwner()
 * @notice we are not inheriting from initializable contract that's cause we've inherited from it in the contract
 *          {ERC20}
 */

// import {initializable} from "../initializable.sol";

import {proxiable} from "../proxyable.sol";
//i've made some changes to the erc20 contract lilbit , remove the constuctor and added a
// function that do the same an we gonna override it
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MainV1 is proxiable, ERC20 {
    constructor() {
        _NoN_initializable();
    }

    // errors
    error NotValidAmount(uint256 stakedAmount);
    error NotEnoughBalance(uint256 currentBalance);

    event staked(address indexed staker, uint256 amountStaked);
    event unstaked(address indexed staker, uint256 amountUnstaked);

    address public owner;
    mapping(address => uint256) private locked; // this is a feature to lock a token and get rewared
    mapping(address => uint256) private lockedAt;
    uint256 public rewardPerDay; // this will be the persentage (for example 0.04 per day will be 4*10**16)

    modifier OnlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    /**
     * @dev since the proxy is a UPPS pattern we have the upgrade function in our logic implementation
     * @param _newImplementation the new contract logic to upgrade to
     */
    function upgrade(address _newImplementation) external OnlyOwner {
        require(
            _newImplementation != address(0),
            "you can't upgrade to address zero "
        );
        bool ok = _upgrade(_newImplementation);
        require(ok, "failed to upgrade");
    }

    function initialize(
        string memory TokenName,
        string memory TokenSymbol,
        uint256 AmountToMint,
        address AddressToMint,
        uint256 _rewaredPerDay
    ) public Initializer {
        owner = msg.sender;
        erc_init_(TokenName, TokenSymbol);
        _mint(AddressToMint, AmountToMint);
        rewardPerDay = _rewaredPerDay;
    }

    //write functions:

    /**
     * @dev this function will allow any holder to lock an amount of his token (that get burned ) and he get a rewared perday that is constant
     * @dev in the holder already staking and want to stake again the he will get rewareded for the first staked amount , and then started a new
     *      staking of the whole amount from the current time;
     * @param amount the amount of tokens the holder wanna stake
     * @notice the holder do not need to set a spesific time for his staking , he's always allow to unstake ;
     */
    function stake(uint256 amount) public {
        // here the user will stake an amout of token that he have
        if (amount > balanceOf(msg.sender) || msg.sender == address(0)) {
            revert NotEnoughBalance(balanceOf(msg.sender));
        } else if (lockedAt[msg.sender] > 0 && locked[msg.sender] > 0) {
            uint256 lock = locked[msg.sender];
            unstake(lock);
            _burn(msg.sender, lock + amount);
            locked[msg.sender] == amount + lock;
        } else {
            _burn(msg.sender, amount);
            locked[msg.sender] == amount;
        }

        lockedAt[msg.sender] == block.timestamp;
        emit staked(msg.sender, amount);
    }

    /**
     * @dev function to unstake that will mint the user the amount he staked plus his rewared token he got depends on the period he staked
     * @param amount  the amount that the holder wanna unstake;
     */
    function unstake(uint256 amount) public {
        // check if the staker have the amount wanna unstake :
        if (locked[msg.sender] < amount || lockedAt[msg.sender] == 0) {
            revert NotValidAmount(locked[msg.sender]);
        }
        // calculate the rewared for amount want to unstake
        uint256 rewardPerAmount = _countReward(msg.sender, amount);

        // update the locked amount and the lockedAt
        lockedAt[msg.sender] = block.timestamp;
        locked[msg.sender] -= amount;
        // rewared the user buy mint him how mush he deserve (the calculated amount) + his amount that unstaked
        _mint(msg.sender, amount + rewardPerAmount);
        emit unstaked(msg.sender, amount);
    }

    //read functions :

    // get the owner of this contract
    function getOwner() public view returns (address _owner) {
        _owner = owner;
    }

    // function to get the amount you are staking
    function getStakedBalance(
        address account
    ) public view returns (uint256 balanceStaked) {
        balanceStaked = locked[account];
    }

    //function to get your current rewared for token you staking;
    function getCountReward()
        public
        view
        returns (address staker, uint256 count)
    {
        staker = msg.sender;
        count = _countReward(msg.sender, locked[msg.sender]);
    }

    //internal functions :
    function _countReward(
        address addressToCount,
        uint256 amount
    ) public view returns (uint256) {
        // what we should do is :
        // get the amount to pay for each day staked
        uint256 perc = (amount * rewardPerDay) / 100e18;
        // get how many day the staker was staking ;
        uint256 stakingPeriod = block.timestamp - lockedAt[addressToCount];
        return (stakingPeriod / 1 days) * perc;
    }
}
