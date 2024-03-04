//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract Hello2 {
    string hello;
    address owner; //address payable owner;

    event PrintLog(string _s);
    constructor() { //constructor() public {
        owner = msg.sender;
    }
    function sayHello() view public returns(string memory) {
        return hello;
    }
    function setHello(string memory _hello) public payable {
        hello = _hello;
        emit PrintLog(_hello);
    }
    function getBalance() view public returns(uint) {
        return address(this).balance;
    }
    function kill() public {
        if (msg.sender == owner) selfdestruct(payable(owner));
    }
}
