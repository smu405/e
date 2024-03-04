//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

library MyLib {
    function multiply7(uint n) pure internal returns (uint) {
        return n*7;
    }
}

contract LibTest2 {
    using MyLib for uint;
    
    function mul(uint num) pure public returns (uint) {
        return num.multiply7();
   }
}
