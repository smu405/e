//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

abstract contract Hello {
    bool helloed=false;
    function sayHello() public virtual returns (string memory);
}

contract HelloMorning is Hello {
    function sayHello() public override returns (string memory) {
        string memory message;
        if(helloed)
            message = "Hello good morning again!";
        else {
            message = "Hello good morning";
            helloed=true;
        }
        return message;
    }
}