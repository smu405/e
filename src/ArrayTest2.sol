//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract ArrayTest2 {
    string[3] cities1=["Seoul", "Sydney", "Tokyo"];
    string[] cities2 = new string[](2);
    string[] cities3;
    uint24[5] balance = [255, 65536, 95, 50, 1];
    int[5] mathMarks;
    uint[3][] marks=[[100, 80, 95],[20,30,40]];

    function setLocalDynamicArr() pure public returns(uint) {
        //uint[] myArr; //error
        //uint[] storage myArr; //error uninitialized storage
        //uint[] memory myArr; //ok. but cannot push
        //uint[] myArr = new uint[](3); //error
        //uint[] storage myArr = new uint[](3); //error conversion from memory to stoarge
        uint[] memory myArr = new uint[](3);
        //myArr.push(11); //error
        myArr[0]=11;
        myArr[1]=12;
        //myArr.push(13); //error
        //myArr[5]=15;
        return myArr.length;
    }
    function getDynamicArrMemory() pure public returns(uint[] memory) {
        uint[] memory num=new uint[](3);  //dynamic
        for (uint i=0; i<num.length; i++)
            num[i]=i;       //push() not allowed for array memeory
        return num;
    }
    //string is a dynamic array itself, which can not be returned.
    //function setArrMemory() view public returns(string[] memory) {
    function getStringDynamicArrMemory() pure public {
        //array storage not allowed
        //error: string[2] storage places = ["9000", "Sydney"];
        string[2] memory places = ["9000", "Sydney"];
        //array memory push not allowed
        //places.push("Seoul");
        places[0]="Seoul";
        //return places;
    }
    /*returning 'string[] storage' is not allowed
    function getCities1_() view public returns(string[] memory) {
        return cities1;  //can not return stoarge var. 
    }*/
    function getCities1() view public returns(string memory) {
        return cities1[0];
    }
    function getCities1Length() view public returns(uint) { return cities1.length; }
    function setCities23() public {
        //string my = "Seoul"; //error
        string memory my = "seoul";
        cities2[0]="New York";
        cities2.push(my);
        cities2.push("Busan");
        cities3.push("New York");
        cities3.push("Beijing");
    }
    //dynamic array return needs "pragma experimental ABIEncoderV2;"
    function getCities2() view public returns(string[] memory){
        return cities2;
    }
    function setMathMarks() public {
        //mathMarks.push(100); //push for fixed array not allowed
        //mathMarks=uint8([100,60,95,50,80]); //error: uint8 memory -> uint8
        uint8[5] memory temp = [100, 60, 95, 50, 80];
        //mathMarks = int(temp); //error: uint8[5] memory -> int256
        for (uint i = 0; i < temp.length; i++) {
            //mathMarks[i] = int(temp[i]); //error: uint8 -> int256
            mathMarks[i] = int(int8(temp[i])); //ok: uint8 -> int8 -> int256
        }
    }
    function getMathMarks() view public returns (int[] memory) {
        //return mathMarks;  //can not return storage array: error: int[] storage -> int[] memory
        int[] memory _arr256 = new int[](mathMarks.length);
        for (uint i = 0; i < mathMarks.length; i++) {
            _arr256[i] = int256(mathMarks[i]);
        }
        return _arr256;
    }
    //run setMathMarks() beforehand
    function getMathAbove70_() view public returns(int[] memory) {
        // size is not allocated yet -> invalid opcode error
        int[] memory mathAbove70;
        uint counter = 0;
        for(uint8 i=0;i<mathMarks.length;i++)
            if(mathMarks[i]>70) {
                mathAbove70[counter] = mathMarks[i];
                //mathAbove70.push(mathMarks[i]);
                counter++;
            }
        return mathAbove70;
    }
    //run setMathMarks() beforehand
    function getMathAbove70() view public returns(int[] memory) {
        //compute lengthOfMathAbove70
        uint8 counter=0;
        uint8 lengthOfMathAbove70=0;
        for(uint8 i=0;i<mathMarks.length;i++)
            if(mathMarks[i]>70) counter++;
        lengthOfMathAbove70=counter;
        //move math marks above 70
        int[] memory mathAbove70=new int[](lengthOfMathAbove70);
        counter=0;
        for(uint i=0;i<mathMarks.length;i++) {
            if(mathMarks[i]>70) {
                mathAbove70[counter]=mathMarks[i];
                counter++;
            }
        }
        return mathAbove70;
    }
    function updateMarks() public returns(uint[3][] memory){
        marks[0][0]=90;
        return marks;
    }
    function getMarksArr() view public returns(uint[3][] memory) {
        return marks;
    }
    function getMarksLength() view public returns(uint) {
        return marks.length;
    }
}
