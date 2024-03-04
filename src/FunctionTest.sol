//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract FunctionTest {
    int x;
    constructor() {
        x = 0;
    }
    function incrementX() public {
        x += 1;
    }
    function doubleX() public {
        X2();
    }
    function divideBy(int by) view public returns(int) {
        return x/by;
    }
    // actually NONE returned
    function getX_() view public returns(int) {
        return x;        
    }
    // test 'pure' instead of 'view'
    function getX() view public returns(int) {
        return x;
    }
    function getBalance() view public returns(uint) {
        return(address(this).balance);
    }
    // none in the function with 'payable' (msg.value is saved)
    function deposit() public payable {
    }
    // can not be accssed from 'external'
    function X2() internal {
        x *= 2;
    }
    function getBlockNumber() view public returns(uint) {
        return block.number;
    }
}