//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract GlobalVarsTest {
    function getEther() pure public returns(uint) {
        return 1 ether;  //1000000000000000000
    }
    function getDays() view public returns(uint,uint) {
        //require(block.timestamp==now);  //now deprecated
        return (block.timestamp, 1 days); // 1558816133 86400 ??web3? 1 days?
    }
    //public --> internal, to remove 'payable'
    function getMsgValue() view internal returns(uint) {
        return msg.value;
    }
    function getMsgSender() view public returns(address) {
        return msg.sender;
    }
    function getCoinbase() view public returns(address) {
        return block.coinbase;
    }
    function getBlockNumber() view public returns(uint) {
        return block.number;
    }
    function getBlockTimeStamp() view public returns(uint) {
        return block.timestamp;
    }
}
