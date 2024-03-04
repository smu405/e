//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract CopyOfStorage {
      uint stateInt = 111; //storage
      string stateStr = "hello";

    function copyLocalToStateVar() public {  
        uint localInt = 123;
        string memory localStr = "hello world";
        stateInt = localInt; // stateInt = 123
        stateStr = localStr; 
        localInt = 456;      // still stateInt = 123
        localStr = "hello outer world";
    }
    function getStateInt() public view returns(uint) { return stateInt; } // 123
    function getStateStr() public view returns(string memory ) { return stateStr; } // hello world
}