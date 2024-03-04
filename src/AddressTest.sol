//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract AddressTest {
    address owner;
    address payable receiver; //address receiver;
    uint balanceOfOwner;
    constructor() { // NO! constructor() public {
        owner=msg.sender;
        //myBalance = msg.sender.balance;
        balanceOfOwner = owner.balance;
    }
    function deposit() payable public {
    }
    /* @param addr  set as payable because it will get some gwei*/
    function setReceiver(address payable addr) public {
        receiver=addr;
    }
    function getReceiver() view public returns(address) {
        return receiver;
    }
    function getBalanceOfThis() public view returns(uint) {
        return address(this).balance;  //balance of contract
    }
    function getBalanceOfOwner() public view returns(uint) {
        return owner.balance;
    }
    function getBalanceOfReceiver() public view returns(uint) {
        return receiver.balance;
    }
    function send() public payable {
        require(receiver.send(111)); //send 111 gwei to xAddress
    }
    function transfer() public payable {
        //if !(receiver.transfer(address(this).balance))
        receiver.transfer(11111);
    }
    function callValue() public payable {
        //receiver.call.value(11111)(""); //deprecated
        //receiver.call{value: 11111}("");  //Warning: Return value of low-level calls not used.
        //(bool success, bytes memory data) = receiver.call{value: 11111}(""); //waring persists
        (bool success, ) = receiver.call{value: 11111}("");
        require(success, "transfer call failed.");
        //receiver.call.gas(10).value(11111)("");  //warning
        //receiver.call{gas: 10, value: 11111}(""); //warning
        (success, ) = receiver.call{gas: 10, value: 11111}("");
        require(success, "transfer call failed.");
    }
}
