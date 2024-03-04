//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract BankV2 {
    address owner;
    uint balance;
    event Sent(address from, address to, uint amount );
    constructor() payable { 
        owner = msg.sender;
        balance = 0;
    }
    function forwardTo(address payable _receiver) public payable {
        //balance -= msg.value;
        require(msg.sender == owner);
        _receiver.transfer(msg.value);
        emit Sent(msg.sender, _receiver, msg.value);
    }
    function getBalance() public view returns(uint, uint) {
        return (balance, address(this).balance);
    }
    function deposit(uint amount) public payable {
        require(msg.value == amount);
        balance += amount;
    }
    function widthdrawAll() public {
        balance -= address(this).balance;
        require(msg.sender == owner);
        //owner.transfer(address(this).balance);
        payable(owner).transfer(address(this).balance);
    }
}
