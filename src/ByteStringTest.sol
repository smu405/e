//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract ByteStringTest {
    //byte b = 0xFF; //use bytes1 as of 0.8.0
    bytes1 b1 = 0xFF;
    bytes2 b2 = 0xFFAA;
    bytes8 place8 = "7 hongji";
    bytes23 place23 = "7 hongji-dong jongro-gu";
    bytes place = "7 hongji-dong jongro-gu Seoul"; //variable length
    bytes myBytes = new bytes(3);  //0x000000
    string constant name = "jsl"; //utf-8 string "jsl"
    function getB1() public view returns(bytes1) {
        return b1;  //byte, so no casting required
    }
    function getB2() public view returns(bytes2) {
        return b2;
    }
    function getB23() public view returns(bytes23) {
        return place23;  //fixed size, value type (no memory)
    }
    /**@return hex bytes. reference type should be set as memory*/
    function getBytes() public view returns(bytes memory) {
        return myBytes;  //smu in hex 0x736d75
    }
    function getLengOfBytes23 () view public returns(uint) {
        return place23.length;  // returns 23
    }
    function getLenOfBytes() pure public returns(uint) {
        bytes memory bm = "7 hongji-dong jongro-gu";
        return bm.length;        // returns 23
    }
    //need the arg in hex e.g. bytes1 0x61 bytes2 0x6161
    //a 61, b 62, ... , y 79
    //try invalid type, e.g. bytes2 0x61 or 0x616161
    function setB2(bytes2 _b2) public {
        b2=_b2;
    }
    function setBytes() public {
        myBytes="smu";
    }
    function getLenOfString() pure public returns(uint) {
        string memory nameLocal="jslLocal";
        //return nameLocal.length;  //error, casting required
        return bytes(nameLocal).length;
    }
    function getString() pure public returns(string memory) {
    //function getString() pure public returns(bytes memory) {
        string memory s = "\xec\x95\x88\xeb\x85\x95"; //"한글";
        //bytes memory s = "\xec\x95\x88\xeb\x85\x95"; //"한글";
        return s;
    }
}
