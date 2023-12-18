// SPDX-License-Identifier: GPL-2.0-or-later

pragma solidity >=0.7.4;

contract Voting {
    address public manager;
    string public agenda;
    
    enum Option { Yes, No, Null, Abstain }
    
    mapping (Option => address[]) private votes;
    mapping (address => bool) private residents;
    
    event VoteRecorded(address indexed voter, Option option);
    
    modifier onlyManager() {
        require(msg.sender == manager, "Only the manager can perform this action!");
        _;
    }
    
    constructor (string memory _agenda){
        manager = msg.sender;
        agenda = _agenda;
    }
    
    /// @dev Allows a resident to cast their vote for a specific option.
    /// @param _option The chosen voting option.
    function vote(Option _option) public {
        require(!residents[msg.sender], "Resident has already voted!");
        votes[_option].push(msg.sender);
        residents[msg.sender] = true;
        emit VoteRecorded(msg.sender, _option);
    }

    
    /// @dev Gets the list of voters for a specific voting option.
    /// @param _option The chosen voting option.
    /// @return List of addresses that voted for the specified option.
    function getResult(Option _option) public view returns (address[] memory) {
        return votes[_option];
    }
    
    /// @dev Allows the manager to add a new resident to the voting system.
    /// @param _newResident The address of the new resident.
    function addResident(address _newResident) public onlyManager {
        require(!residents[_newResident], "Resident already exists!");
        residents[_newResident] = true;
    }
    
    /// @dev Allows the manager to remove a resident from the voting system.
    /// @param _removedResident The address of the resident to be removed.
    function removeResident(address _removedResident) public onlyManager {
        require(residents[_removedResident], "Resident not found!");
        residents[_removedResident] = false;
    }
}
