//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract Random {
    function rand() public view returns(bytes32) {
        return keccak256(abi.encodePacked(block.timestamp, block.difficulty));
    }
    function rand0and250() public view returns(uint8) {
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%251);
    }
    function rand0and9() public view returns(uint8) {
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%10);
    }
    function rand0and2() public view returns(uint8) {
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%3);
    }
    function genRandomInteger() view public returns(uint8[] memory) {
        uint8[] memory r = new uint8[](10);
        for(uint i = 0; i<r.length; i++)
            //r[i] = uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%10);
            //change timestamp by adding i, otherwise all the same numbers generated
            r[i] = uint8(uint256(keccak256(abi.encodePacked(block.timestamp + i, block.difficulty)))%10);
        return r;
    }
}
