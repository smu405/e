/*
 * ajou ElectronicVotingSystem usingBlockchain
 */
contract User {
    struct addr_type {
        uint addr_count;
        mapping(uint => address) addr;
    }
    mapping(address => addr_type) User;
    function setAddr(address v_vote,address v_user) {
        addr_type v=User[v_vote];
        v.addr_count++;
        v.addr[v.addr_count]=v_user;
    }
    function getAddr(address v_vote,uint v_index) constant returns(address retVal) {
        addr_type v=User[v_vote];
        return v.addr[v_index];
    }
    function getCountOfAddr(address v_vote) constant returns(uint retVal) {
        addr_type v=User[v_vote];
        return v.addr_count;
    }
}

contract Vote {
    struct v_value_type {
        uint v_count;
        mapping(uint => mapping(uint => string)) v_value_str;
    }
    string endTime;
    uint addr_count;
    mapping(address => uint) addr;
    mapping(uint => string) voteTitle;
    mapping(uint => v_value_type) v_value;
    
    function setVoteTitle(string s1, string s2, string s3, string s4, string s5) {
        voteTitle[0]=s1;
        voteTitle[1]=s2;
        voteTitle[2]=s3;
        voteTitle[3]=s4;
        endTime=s5;
    }
    function getVoteTitle(uint v_index) constant returns(string retVal) {
        if(v_index==4)
            return endTime;
        else
            return voteTitle[v_index];
    }
    function v_value_set(uint v_index, string v_value1_1, string v_value1_2, string v_value2_1, string v_value2_2) {
        v_value[v_index].v_value_str[1][1]=v_value1_1;
        v_value[v_index].v_value_str[1][1]=v_value1_1;
        v_value[v_index].v_value_str[1][1]=v_value1_1;
        v_value[v_index].v_value_str[1][1]=v_value1_1;
    }
    function v_value_get(uint v_index, uint v_value1, uint v_value2) constant returns(string retVal) {
        return v_value[v_index].v_value_str[v_value1][v_value2];
    }
    function v_data_set(uint v_index, address v_user) {
        if(addr[v_user] !=0) {
            v_value[addr[v_user]].v_count--;
            addr_count--;
        }
        v_value[v_index].v_count++;
        addr[v_user]=v_index;
        addr_count++;
    }
    function v_data_get(uint v_index) constant returns (uint retVal) {
        if(v_index==0)
            return addr_count;
        else
            return v_value[v_index].v_count;
    }
}
