//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

contract EnumTest {
    enum Day {MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY}
    Day myDay = Day.FRIDAY; //index int4
    
    /* @return Day  returning index*/
    function getMyDay() public view returns(Day) {
        return myDay;   //index
    }
    /* @param d  ok to pass an integer (uint8)*/
    function setMyDay(Day d) public {
        myDay = d;
    }
    //uint is converted to uint8, which is default
    function setMyDayInt(uint d) public {
        myDay = Day(d);
    }
}
