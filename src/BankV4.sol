//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

//check for Coin.sol (ch12) and BankV3.sol 201906
contract BankV4 {
    address owner;
    mapping (address => uint) balanceOf;
    constructor() {//constructor() public {
        owner = msg.sender;
    }
    // save to individual addresses
    function deposit(uint amount) payable public onlyOwner {
        require(msg.value == amount);
        balanceOf[msg.sender] += amount;
    }
    // forward from owner to another
    function forwardTo(address receiver, uint amount) payable public onlyOwner {
        require(balanceOf[msg.sender] >= amount);
        balanceOf[msg.sender] -= amount; // Subtract from the sender
        balanceOf[receiver] += amount;   // Add the same to the recipient
    }
    function withdraw(address payable receiver, uint amount) public onlyOwner {
        require(balanceOf[receiver] >= amount && address(this).balance >= amount);
        balanceOf[receiver] -= amount;
        receiver.transfer(amount);
    }
    function getBalance() public view returns(uint, uint) {
        return (address(this).balance, balanceOf[owner]);
    }
    function getBalanceOf(address addr) public view returns (uint) {
        return balanceOf[addr];
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}
