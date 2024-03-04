//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract Members{
    address owner;
    event printAddr(address arg);
    struct Member{
        uint id;
        string name;
    }
    Member[] public memberArr;
    constructor() { //constructor() public {
        owner=msg.sender;
    }
    function del() public {
        delete memberArr;
    }
    function delOne(uint i) public{
        delete memberArr[i];  //try pop()
    }
    function add(uint id,string memory name) public {
        memberArr.push(Member(id,name));
    }
    //return Member
    function getMember(string memory who) view public returns(uint, string memory) {
        uint _id;
        string memory _name;
        for(uint i=0;i<memberArr.length;i++) {
            _name=memberArr[i].name;
            if(keccak256(abi.encodePacked(_name))==keccak256(abi.encodePacked(who))) {
                _id=memberArr[i].id;
                _name=memberArr[i].name;
            }
        }
        return (_id,_name);
    }
    function compareStr(string memory s1, string memory s2) pure public returns(bool) {
        return keccak256(abi.encodePacked(s1))==keccak256(abi.encodePacked(s2));
    }
    function compareBytes(bytes memory b1, bytes memory b2) pure public returns(bool) {
        return keccak256(b1) == keccak256(b2);
    }
    function getLength() view public returns(uint) {
        return memberArr.length;
    }
}
