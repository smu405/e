//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract IntBoolTest {
    bool married = true;
    uint256 xAge = 22;
    uint256 yAge = 25;
    //fixed phi; // = 3.14;
    function update() public {
        xAge = yAge;
        yAge = 33;
    }
    function setXAge(int age) public {
        xAge = uint(age);  //converstion
    }
    function getXAge() public view returns(uint) {
        return xAge;
    }
    function getYAge() public view returns(uint) {
        return yAge;
    }
    function testInt() public view returns(bool) {
        assert(xAge>=20 && yAge>=20);
        return true;
    }
    function isMarried() public view returns(bool) {
        return married;
    }
}
