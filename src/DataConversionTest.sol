//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract DataConversionTest {
    function convertInt8ToInt() pure public returns(int) {
        int8 i8=20;
        return int(i8);  //20
    }
    function convertIntToBytes32() pure public returns(bytes32) {
        uint x=20;
        //0x0000000000000000000000000000000000000000000000000000000000000014
        return bytes32(x);
    }
    function convertInt64ToBytes8() pure public returns(bytes8) {
        uint64 x=10;
        return bytes8(x); //0x000000000000000a
    }
    function convertIntToBytes() pure public returns(bytes memory) {
        // can not convert uint -> bytes
        // convert uint -> bytes32 -> bytes
        uint x = 20;
        bytes32 y = bytes32(x); //uint=uint256
        // can not convert from bytes32 -> bytes;
        bytes memory z = new bytes(32);
        for (uint i=0; i < 32; i++) {
            z[i] = y[i];
        }
        //0x0000000000000000000000000000000000000000000000000000000000000014
        return z;
    }
    function convertStringToBytes() pure public returns(bytes memory) {
        string memory s="hello";
        return bytes(s);  //0x68656c6c6f
    }
    function convertBytes4ToBytes2() pure public returns(bytes2) {
        bytes4 b4=0x68656c6c;
        return bytes2(b4);  //0x6865
    }
    function convertBytes4ToInt32() pure public returns(uint32) {    
        bytes4 b4=0x68656c6c;
        //1751477356 = 68656C6C hex = (6 × 16^7) + (8 × 16^6) + ... + (6 × 16^1) + (12 × 16^0) 
        return uint32(b4); //1751477356
    }
}
