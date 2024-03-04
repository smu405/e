//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract OrderEvent {
    uint unitPrice = 10;
    event OrderLog(string);
    event OrderLog(bytes2 _itemId, uint _value);
    event OrderLog(uint256 timestamp);
    event OrderLog(address indexed _from, bytes2 _itemId, uint indexed _value);

    function order(bytes2 _itemId, uint quantity) public payable {
        //uint256 orderTime = now;
        uint256 orderTime = block.timestamp;
        uint256 orderAmount = quantity * unitPrice;
        require(msg.value == orderAmount);
        emit OrderLog("Ordered");
        emit OrderLog(orderTime);
        emit OrderLog(msg.sender, _itemId, msg.value);
    }
}
