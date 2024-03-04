//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;
import "./Point.sol";

contract Rectangle is Point {
    int w;
    int h;
    constructor(int _w, int _h, int _x, int _y) Point(_x, _y) {
        //super(_x, _y); //nok
        w = _w;  //this.w --> nok
        h = _h;
    }
    function getPerimeter() view public returns(int) {
        return 2*(w+h);
    }
    function getXOpposite() view public returns(int) { return getX() + w; }
    function getYOpposite() view public returns(int) { return getY() + h; }
}
