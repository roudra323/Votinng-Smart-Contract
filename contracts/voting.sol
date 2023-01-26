// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract voting {
    address public owner;
    address public canValidator;
    address public voterValidator;

    //the deployer of the contract is the owner of the contract
    constructor(address velidatorAdd,address _votervalidator) {
        owner = msg.sender;
        canValidator = velidatorAdd;
        voterValidator = _votervalidator;
    }


    // Candidate information
    struct canInfo {
        address addr;
        string canName;
        uint256 totalVote;
        bool isVerifiedCan;
    }

    mapping(address => canInfo) public candidateInfo;

    //array to store candidate address
    address[] public canAddress;

    function addrCandidate(address _addr,string memory _Canname) external {
        require(owner == msg.sender,"Only owner can add candidates");
        candidateInfo[_addr].addr = _addr;
        candidateInfo[_addr].canName = _Canname;
        canAddress.push(_addr);
    }



    //candidate verification//

    //this function only can be accessed by candidate validator
    //so should add a modifier or do the work inside function
    function verifyCandidate(address canADD) external {
        require(msg.sender == canValidator,"Only the candidate validator can access this function");
        require(!candidateInfo[canADD].isVerifiedCan,"The candidate is not listed.");
        candidateInfo[canADD].isVerifiedCan = true;
    }



    //voter information
    struct voteInfo {
        address voteraddress;
        string voterName;
        string NID;
        bool isVerifiedvoter;
        bool isVoted;
    }

    address[] allvoterAddr;
    mapping(address => voteInfo) public voterInfo;

    function addrVoter(address _voterAddress,string memory _name,string memory _NID) external{
        require(owner == msg.sender,"Only owner can add candidates");
        voterInfo[_voterAddress].voteraddress = _voterAddress; 
        voterInfo[_voterAddress].voterName = _name; 
        voterInfo[_voterAddress].NID = _NID; 
        allvoterAddr.push(_voterAddress);
    }

    //function to verify voter

    function verifyVoter(address voterADD) external {
        require(msg.sender == voterValidator,"Only the voter validator can access this function");
        require(!voterInfo[voterADD].isVerifiedvoter,"The voter is not listed.");
        voterInfo[voterADD].isVerifiedvoter = true;
    }

    /* Only the verified voters can vote the verified candidates */

    function vote(address _candidate) external {
        require(voterInfo[msg.sender].isVerifiedvoter,"Voter is not verified");
        require(candidateInfo[_candidate].isVerifiedCan,"Candidate is not verified");
        require(!voterInfo[msg.sender].isVoted,"Voter has already voted");
        voterInfo[msg.sender].isVoted = true;
        candidateInfo[_candidate].totalVote += 1;
    }


    function winnerCandidate() external view returns(address,uint256) {
        require(msg.sender == owner,"Function caller is not owner of the contract.");
        uint256 tempcount = 0;
        address tempaddress;
        for(uint i = 0; i < canAddress.length;i++){
            if (candidateInfo[canAddress[i]].totalVote > tempcount){
                tempcount = candidateInfo[canAddress[i]].totalVote;
                tempaddress = canAddress[i];
            }
        }
        return (tempaddress,tempcount);
    }



}
