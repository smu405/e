//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;
library MyLib3 {
    function multiply7(uint n) pure internal returns (uint) {
        return n*7;
    }
    
    function add5(int n) pure internal returns (int) {
        return n+5;
    }    
}

contract LibTest3 {
    using MyLib3 for *;
    
    function mul(uint num) pure public returns (uint) {
        return num.multiply7(); 
    }
    
    function add(int num) pure public returns (int) {
        return num.add5();
    }
}