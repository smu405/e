//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract Division {
    function divide(int _n1, int _n2) pure public returns (int) {
        return _n1/_n2;
    }
}

contract TryCatchTest {
    Division d = new Division();

    event LogError(string);
    event Log(int);

    function divideCatch(int _n1, int _n2) public {
        try d.divide(_n1, _n2) returns(int v) {
            emit Log(v);
        } catch {
            emit LogError("Error");
        }
    }
}