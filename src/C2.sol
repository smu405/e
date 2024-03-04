//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;
//pragma solidity 0.6;
//pragma solidity 0.4.21;
import "./C1.sol";

contract C2 {
    C1 c1;
    //function C2() public {  //0.4.21 constructor
    constructor() {    //constructor() public {    //0.6 constructor
        c1=new C1();
    }
    function setC1(address _addressOfC1) public {
        c1 = C1(_addressOfC1);
    }
    function set(uint128 _v1) public {
        c1.set(_v1);
    }
    function get() public view returns(uint128) {
        return c1.get();
    }
    function get7() public view returns(uint128) {
        return c1.get7();
    }
    function getC1Address() public view returns(address) {
        return address(c1);
    }
}
