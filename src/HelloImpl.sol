//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

interface Hello {
    function sayHello() external returns (bytes32);
}

contract HelloImpl is Hello {
    function sayHello() pure public virtual override returns (bytes32) { return "Hello"; }
}