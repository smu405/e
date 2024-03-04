//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0; //^0.5.0;

contract BankV3 {
    address owner;
    uint balance;
    uint256 timeToDeposit;
    
    event PrintLog(string);
    event Sent(address from, address to, uint amount );
    constructor() { //constructor() public {
        owner = msg.sender;
        balance = 0;
    }
    fallback() external { // v0.5.0 function() external {
        emit PrintLog("Fallback called");
    }
    function forwardTo(address payable _receiver) public payable onlyOwner {
        //require(msg.sender == owner);
        _receiver.transfer(msg.value);
        emit Sent(msg.sender, _receiver, msg.value);
    }
    function getBalance() public view returns(uint, uint) {
        return (balance, address(this).balance);
    }
    function deposit(uint amount) public payable onlyAfter {
        timeToDeposit = block.timestamp + 10 seconds; //timeToDeposit = now + 10 seconds;
        require(msg.value == amount);
        balance += amount;
    }
    function withdrawAll() public onlyOwner minBalance {
        balance -= address(this).balance;
        //require(msg.sender == owner);
        //v0.5.0 msg.sender.transfer(address(this).balance);
        payable(msg.sender).transfer(address(this).balance); 
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    modifier onlyAfter {
        require(block.timestamp >= timeToDeposit); //require(now >= timeToDeposit);
        _;
    }
    modifier minBalance {
        require(address(this).balance>101 wei);
        _;
    }
}
