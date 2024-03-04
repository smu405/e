//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract LoopTest {
    uint sum;
    constructor() { //constructor() public {
        init();
    }
    function forLoop() public {
        //init();
        uint sumLocal = 0;
        for(uint i = 0; i < 101; i++) {
            sumLocal += i;
        }
        sum = sumLocal;
    }
    function forLoopCostly() public {
        init();
        //uint sumLocal = 0;
        for(uint i = 0; i < 101; i++) {
            //sumLocal += i;
            sum += i;
        }
        //sum = sumLocal;
    }
    function whileLoop() public {
        uint i = 0;
        uint sumLocal = 0;
        while(i <= 100) {
            sumLocal += i;
            i++;
        }
        sum = sumLocal;
    }
    function whileLoopBreak() public {
        uint sumLocal = 0;
        uint i = 0;
        while(true) {
            sumLocal += i;
            if(i==100) break;
            i++;
        }
        sum = sumLocal;
    }   
    function doWhileLoop() public {
        uint i = 0;
        uint sumLocal = 0;
        do {
            sumLocal += i;
            i++;
        } while(i <= 100);
        sum = sumLocal;
    }
    function init() public { sum = 0; }
    function getSum() view public returns(uint) { return sum; }
}
