//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract ExceptionTest {
    address owner;
    constructor() {//constructor() public {
        owner=msg.sender;
    }
    function requireException() view public returns(string memory) {
        //if (msg.sender != owner) { throw; } // not this way to throw an exception
        require(msg.sender != owner, "Sorry! You are owner. Require failed...");
        return "require condition met";
    }
    function assertException() view public returns(string memory) {
        assert(msg.sender == owner);
        return "asserted";  //do this line only 'assert' is succeeded
    }
    function revertException() view public returns(string memory) {
        if(msg.sender != owner) {
            revert("Sorry! You are NOT owner. Reverted...");
            //return "reverted";  // this line can't be reached if revert is executed 
        } else {
            return "not reverted";
        }
    }
    function raiseException() pure public {
        int x=0;
        int y=0;
        x/y;    //divide by zero
    }
}
