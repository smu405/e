//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract ConditionalTest {
    function toLowerCase(string memory str) pure public returns (string memory) {
        bytes memory bIn = bytes(str);
        bytes memory bOut = new bytes(bIn.length);
        uint8 _iIn = 0;
        for (uint i = 0; i < bIn.length; i++) {
            _iIn = uint8(bIn[i]);
            if (_iIn >= 65 && _iIn <= 90)    // ascii A:65 ~ Z:90                
                bOut[i] = bytes1(_iIn + 32); // ascii a:97 ~ z:122
            else 
                bOut[i] = bIn[i];
        }
        return string(bOut);
    }
    function abs(int i) pure public returns (int) {
        return (i > 0) ? i : -i;
    }
}
