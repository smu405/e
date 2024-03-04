//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;
//pragma solidity ^0.6.0;
//pragma solidity ^0.5.0;

library myLib {
    //function multiply7(uint num) public pure returns (uint) {
    function multiply7(uint num) internal pure returns (uint) {
      return num * 7;
   }
}
    
contract LibrayTest {
    //event PrintLog(uint);
    function multiply7By(uint num) pure public returns(uint) {
        uint n=myLib.multiply7(num);
        //emit PrintLog(n);
        return n;
    }
}
