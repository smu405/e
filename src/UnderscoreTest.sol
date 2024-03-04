//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract UnderscoreTest {
    string season = "";
    function getSeason() view public returns(string memory) {
        return season;
    }
    function setWinter() public setSummerAfter {
        season = "winter";
    }
    function setSpring() public setSummerBefore {
        season = "spring";
    }
    modifier setSummerAfter() {
        season = "summer";
        _;
    }
    modifier setSummerBefore() {
        _;
        season = "summer";
    }
}
