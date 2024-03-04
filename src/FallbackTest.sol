//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract FallbackTest {
    event PrintLog(string);
    function callA () pure public returns(string memory){
        return "doing callA";
    }
    fallback () external {
        emit PrintLog("fallback called");
    }
}
