pragma solidity ^0.8.0;
contract Timer {
    uint256 startTime;
    function start() public {
        //startTime=now; now is deprecated as of v0.7
        startTime=block.timestamp;
    }
    function timePassed() public view returns(uint256) {
        //return now-startTime;
        return block.timestamp-startTime;
    }
    function getNow() view public returns(uint) {
        //return now;
        return block.timestamp;
    }
}
