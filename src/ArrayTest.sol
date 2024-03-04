//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract ArrayTest {
    uint[3] ages = [15, 25, 35];
    int[] marks; //dynamic ArrayTest
    
    /* @param index  array index
       @param val    value at the index*/
    function updateAges(uint index, uint val) public {
        if(index>=0 && index <=2)
            ages[index] = val;
    }
    function initMarks() public {
        marks = new int[](5);   // default 0
    }
    function appendMark(int mark) public {
        marks.push(mark);
    }
    function popMark() public {
        marks.pop();
    }
    /* @return dynamic array, so memory is used*/
    function getMarks() public view returns(int[] memory) {
        return marks;
    }
    /* @return fixed array, so memory is used*/
    function getAges() public view returns(uint[3] memory) {
        return ages;
    }
    function getLenOfArr() pure public returns(uint) {
        //memory is used because locally created array is assigned
        uint8[3] memory intArr = [0, 1, 2];
        return intArr.length;
    }
}
