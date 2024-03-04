//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract Point {
    int x;
    int y;
    constructor(int _x, int _y) { //constructor(int _x, int _y) public {
        x = _x;
        y = _y;
    }
    function getX() view public returns(int) { return x; }
    function getY() view  public returns(int) { return y; }
}
