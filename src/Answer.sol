/* 
 * @author http://ethereum.stackexchange.com/questions/3285/how-to-get-return-values-when-function-with-argument-is-called
 */
contract Answer {
    mapping(address => mapping(string => bool)) voters;

    struct qList {
	uint count; /* The number of respondents */
	mapping(address => mapping(uint => uint)) answer;
    }

    mapping(string => qList) questionnaires;
    event VoteEvent(string ID, bool returnValue);

    function vote(string ID, uint qNum, uint ans) returns (bool) {
	if (voters[msg.sender][ID]) throw;
	voters[msg.sender][ID] = true;
	questionnaires[ID].count += 1;
	questionnaires[ID].answer[msg.sender][qNum] = ans;
	VoteEvent(ID, true);
	return true;
    }

    function getNumResult(string ID) constant returns (uint res) {
	return questionnaires[ID].count;
    }
}
