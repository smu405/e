//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;
//pragma solidity ^0.6.0;
//pragma solidity 0.4.21;

import "./Square.sol";

contract Area {
    Square s;
    address owner;
    //event PrintLog(uint128);
    //function Area() public {  //0.4.21
    constructor() { //constructor() public {
        s = new Square();
        owner = msg.sender;
    }
    function changeSquare(address _addressOfSquare) public {
        s=Square(_addressOfSquare);
    }
    function calcArea() view public returns(uint128) {
        uint128 length = s.getLength();
        uint128 area = length*length;
        //emit PrintLog(area);
        return area;
    }
    function setLength(uint128 _length) public {
        s.setLength(_length);
    }
    function getLength() public view returns(uint128) {
        return s.getLength();
    }
    function getDegree() public view returns(uint128) {
        return s.getDegree();
    }
    function getAddressOfSquare() public view returns(address) {
        return address(s);
    }
}
