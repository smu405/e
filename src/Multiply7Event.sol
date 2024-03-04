//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract Multiply7Event {
    event Print(address _addr, uint256 timestamp, uint res);
    //function multiply(uint input) public returns(uint) {
    function multiply(uint input) public {
        uint res = input * 7;
        emit Print(msg.sender, block.timestamp, res); //emit Print(msg.sender, now, res);
        //return res;
    }
}
