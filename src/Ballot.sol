// SPDX-License-Identifier: GPL-3.0
// modified version of Ethereum Ballot.sol
pragma solidity >=0.7.0 <0.9.0;

contract Ballot {
    struct Voter {
        bool voted;  // if true, that person already voted
        uint vote;   // index of the voted proposal
    }
    struct Proposal {
        bytes3 name;   // short name (up to 3 bytes)
        uint voteCount; // number of accumulated votes
    }

    address public chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;
    uint nVoted; //counted in function vote
    event Voted(address _address, uint _proposal);
    
    constructor(bytes3[] memory proposalNames) {
        nVoted=0;
        chairperson = msg.sender;
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    function vote(address _address, uint proposal) public {
        //Voter sender = voters[msg.sender];
        Voter storage sender=voters[_address];
        require(!sender.voted, "Already voted");
        sender.voted = true;
        sender.vote = proposal;
        proposals[proposal].voteCount += 1;  //throw if out-of-index
        nVoted += 1; //add 1
        emit Voted(_address, proposal);
    }

    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerName() public view returns (bytes3 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }

    function getNVoted() public view returns (uint) {
        return nVoted;
    }
}
