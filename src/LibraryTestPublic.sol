//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;
//pragma solidity ^0.6.0;

import "./myLib.sol";

contract LibrayTestPublic {
    using myLib for uint256;
    function multiply7By(uint num) public pure returns(uint) {
        return num.multiply7();
    }
}
