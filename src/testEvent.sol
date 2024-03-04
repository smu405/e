pragma solidity ^0.5.0;
contract testEvent {
    event MyLog(string);
    function MyFunction() public {
        emit MyLog("Hello World!");
    }
}