//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract Customer {
    function getTxOriginMsgSender() view public returns(address, address) {
        return(tx.origin, msg.sender);
    }
}

contract Order {
    Customer c;
    constructor() { //constructor() public {
        c = new Customer();
    }
    function getTxOriginMsgSender() view public returns(address, address) {
        return c.getTxOriginMsgSender();
    }
}
