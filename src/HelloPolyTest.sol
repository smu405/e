//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

abstract contract Hello {
    function sayHello() public virtual returns (bytes32);
}

contract HelloMorning is Hello {
    function sayHello() public pure override returns (bytes32) { return "Hello good morning!"; }
}

contract HelloAfternoon is Hello {
    function sayHello() public pure override returns (bytes32) { return "Hello good afternoon!"; }  
}

contract Client {
    function getAllHellos() public returns(string memory) {
        Hello[2] memory hellos; //no dynamic Hello[] 
        string memory _allStr;
 
        hellos[0] = new HelloMorning();
        hellos[1] = new HelloAfternoon();
        
        for(uint i = 0; i < hellos.length; i++) {
            //bytes32 -> string -> concat
            _allStr=string.concat(_allStr, string(abi.encodePacked(hellos[i].sayHello())));
        }
        //return _allStr;
        return string(abi.encodePacked(_allStr));
    }
}
