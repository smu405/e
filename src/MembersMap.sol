//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract MembersMap {
    struct Member {
        uint id;
        string name;
    }
    //bidrectional map
    mapping(address=>Member) memberMap;
    mapping(uint=>address) addressById;
    mapping(string=>address) addressByName;
    function addMember (uint _id, string memory _name) public {
       Member memory m=Member(_id, _name);
       memberMap[msg.sender]=m;
       //saving into a bidiretional map to get address by id
       addressById[_id]=msg.sender;
       //saving into a bidiretional map to get address by name
       addressByName[_name]=msg.sender;
    }
    //get Member by id
    function getMemberById(uint _id) view public returns(uint, string memory) {
        Member memory my = memberMap[addressById[_id]];
        return (my.id, my.name);
    }
    // get address (not Member) by name
    function getMemberAddressByName(string memory _name) public view returns(address) {
        return addressByName[_name];
    }
    function getMember(address addr) view public returns (uint, string memory) {
        Member memory m=memberMap[addr];
        return (m.id, m.name);
    }
}
