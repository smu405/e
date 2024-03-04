//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;
//pragma solidity ^0.6;
//pragma solidity 0.4.21;

contract C1 {
    uint128 v1;
    function set(uint128 _v1) public {
        v1=_v1;
    }
    function get() public view returns(uint128) {
        return v1;
    }
    function get7() public pure returns(uint128) {
        return 7;
    }
}
