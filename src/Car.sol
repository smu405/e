//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;
//pragma solidity ^0.6.0;
//pragma solidity 0.4.21;

contract Car {
    Engine engineObj;
    string private color;
    event PrintLog(address sender, string msg);

    constructor() { //constructor() public {
        engineObj = new Engine();
    }
    function setColor(string memory _color) public {
        color=_color;
    }
    function getColor() public view returns(string memory) {
        return color;
    }
    function getSpeed() public view returns(uint) {
        return engineObj.getSpeed();
    }
    function speedUpBy10() public {
        engineObj.setSpeedUpBy(10);
    }
    function speedDownBy10() public {
        engineObj.setSpeedDownBy(10);   
    }
    function start() public {
        engineObj.on();
        //convert bool to string
        string memory engineStateStr=engineObj.getEngineState()? "on" : "off";
        emit PrintLog(msg.sender, engineStateStr);
    }
}

contract Engine {
    uint constant private MAXSPEED = 200;
    uint private speed;
    bool private engineState;

    constructor() {//constructor() public {
        speed = 0;
        off();
    }
    function on() public {
        engineState = true;
    }
    function off() public {
        engineState = false;
    }
    function getEngineState() public view returns(bool){
        return engineState;
    }
    function setSpeedUpBy(uint _speed) public {
        if(speed < (MAXSPEED - 10) && engineState == true)
            speed += _speed;
    }
    // int _speed -> needs casting to uint (speed)
    function setSpeedDownBy(uint _speed) public {
        if((speed - 10) > 0  && engineState == true)
            speed -= _speed;
    }
    function getSpeed() public view returns(uint) {
        return speed;
    }
}
