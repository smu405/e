//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract FallbackTest1 {    
    receive() external payable {} //ok
    //receive() {} //error --> external
    //receive() external {} //error --> payable
    //function receive() external payable {} //warning (omit function)
    fallback() external {} //ok
    //fallback() {} //error --> external
    //fallback() external payable {} //ok
    //function fallback() external payable {} //warning (omit function)
    //function() external payable {} //error
    //fallback(bytes calldata _input) external {} //error
    //fallback(bytes calldata _input) external returns(bytes memory _output) {} //ok
}