//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract AbiTest {
    function encodeUint(uint256 _uint) public pure returns(bytes memory) {
        return abi.encode(_uint);
    }
    function encodeAddress(address addr) public pure returns(bytes memory) {
        return abi.encode(addr);
    }
    function encodeString(string memory s) public pure returns(bytes memory) {
        return abi.encode(s);
    }
    function encodePackedString(string memory s) public pure returns(bytes memory) {
        return abi.encodePacked(s);
    }
    function encodePackedStringConcat(string memory s1, string memory s2) public pure returns(bytes memory) {
        return abi.encodePacked(string.concat(s1,s2));
    }
    function encodeBytes(bytes memory b) public pure returns(bytes memory) {
        return abi.encode(b);
    }
    function encodePackedBytes(bytes memory b) public pure returns(bytes memory) {
        return abi.encodePacked(b);
    }
    function encodePackedBytes2String(bytes  memory b)  public  pure  returns(string  memory)  {
        return  string(abi.encodePacked(b));
    }
}
