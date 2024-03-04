//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;
//pragma solidity ^0.6.0;

import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
//import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol";

contract TestSafeMath {   
    using SafeMath for uint256;
    function add(uint256 x, uint256 y) public pure returns (uint256) {
        uint256 z = x.add(y);
        return z;
    }
}
