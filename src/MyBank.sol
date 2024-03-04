//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract MyBank {
    address owner; //address payable owner;
    uint balance;
    constructor() { //constructor() public {
        owner = msg.sender;
        balance = address(this).balance;
    }
    function deposit(uint amount) public payable {
        require(msg.value == amount);
        balance += amount;
    }
    function withdraw(uint amount) public payable {
        balance -= amount;   // deduct before transfer
        payable(owner).transfer(amount); //owner.transfer(amount);
    }
    function transferTo(address payable receiver, uint amount) public payable {
        balance -= amount;   // deduct before transfer
        receiver.transfer(amount);
    }
    function getBalance() public view returns (uint) {
        return balance;
    }
    function getBalanceOfThis() public view returns (uint) {
        return address(this).balance;
    }
    function getBalanceOfOwner() public view returns (uint) {
        return owner.balance;
    }
}
