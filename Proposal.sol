// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ProposalContract {
    // ****************** Data ***********************

    address public owner;
    uint256 private counter;

    struct Proposal {
        string description;
        uint256 approve;
        uint256 reject;
        uint256 pass;
        uint256 total_vote_to_end;
        bool current_state;
        bool is_active;
        string title;
    }

    mapping(uint256 => Proposal) public proposal_history;
    address[] private voted_addresses;

    // ****************** Constructor ***********************

    constructor() {
        owner = msg.sender;
        voted_addresses.push(msg.sender); // Exclude owner from voting again
    }

    // ****************** Modifiers ***********************

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier active() {
        require(proposal_history[counter].is_active == true, "No active proposal");
        _;
    }

    modifier newVoter(address _address) {
        require(!isVoted(_address), "Address has already voted");
        _;
    }

    // ****************** Core Functions ***********************

    function setOwner(address new_owner) external onlyOwner {
        owner = new_owner;
    }

    function createProposal(string calldata _description, uint256 _total_vote_to_end, string calldata _title) external onlyOwner {
        counter += 1;
        proposal_history[counter] = Proposal(_description, 0, 0, 0, _total_vote_to_end, false, true, _title);
        voted_addresses = [owner]; // Reset for new proposal
    }

    function vote(uint8 choice) external active newVoter(msg.sender) {
        Proposal storage proposal = proposal_history[counter];

        voted_addresses.push(msg.sender);

        if (choice == 1) {
            proposal.approve += 1;
        } else if (choice == 2) {
            proposal.reject += 1;
        } else if (choice == 0) {
            proposal.pass += 1;
        } else {
            revert("Invalid vote option");
        }

        proposal.current_state = calculateCurrentState();

        uint256 total_votes = proposal.approve + proposal.reject + proposal.pass;
        if (total_votes >= proposal.total_vote_to_end) {
            proposal.is_active = false;
        }
    }

    // ****************** New Logic: 60% Approval Needed ***********************

    function calculateCurrentState() private view returns (bool) {
        Proposal storage proposal = proposal_history[counter];

        uint256 total_votes = proposal.approve + proposal.reject + proposal.pass;
        if (total_votes == 0) return false;

        // Calculate approval percentage (multiplied by 100 to avoid decimals)
        uint256 approvePercentage = (proposal.approve * 100) / total_votes;

        // Proposal succeeds only if approval is 60% or more
        return approvePercentage >= 60;
    }

    // ****************** Helpers ***********************

    function isVoted(address _address) private view returns (bool) {
        for (uint256 i = 0; i < voted_addresses.length; i++) {
            if (voted_addresses[i] == _address) {
                return true;
            }
        }
        return false;
    }

    function getCurrentProposalId() external view returns (uint256) {
        return counter;
    }

    function getProposal(uint256 id) external view returns (Proposal memory) {
        return proposal_history[id];
    }
}
