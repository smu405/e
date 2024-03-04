//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import {Library1, Library3} from "./MyLibTemp.sol";
contract LibTest1 {
    function mul(uint num) pure public returns (uint) {
        return Library1.multiply7(num);
    }
}
