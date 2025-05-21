// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./MembershipNFT.sol";

contract DAOSystem {
    MembershipNFT public membership;

    struct Proposal {
        uint256 id;
        address author;
        string content;
        uint256 expires;
        uint256 support;
        uint256 against;
        bool finalized;
    }

    uint256 public totalProposals;
    mapping(uint256 => Proposal) public allProposals;
    mapping(uint256 => mapping(address => bool)) private voteTracker;

    event NewProposal(uint256 indexed id, address indexed author, string content);
    event VoteCast(uint256 indexed id, address indexed voter, bool support);
    event ProposalFinalized(uint256 indexed id, bool passed);

    error NotMember();
    error ProposalClosed();
    error AlreadyVoted();
    error InvalidProposal();

    constructor() {
        // Deploy MembershipNFT and store its address
        membership = new MembershipNFT(address(this), msg.sender);
    }

    modifier onlyMember() {
        if (!membership.hasMinted(msg.sender)) revert NotMember();
        _;
    }

    function submitProposal(string calldata content) external onlyMember {
        uint256 propId = totalProposals++;
        allProposals[propId] = Proposal({
            id: propId,
            author: msg.sender,
            content: content,
            expires: block.timestamp + 3 days,
            support: 0,
            against: 0,
            finalized: false
        });

        emit NewProposal(propId, msg.sender, content);
    }

    function castVote(uint256 propId, bool support) external onlyMember {
        Proposal storage proposal = allProposals[propId];
        if (proposal.finalized) revert ProposalClosed();
        if (block.timestamp > proposal.expires) revert ProposalClosed();
        if (voteTracker[propId][msg.sender]) revert AlreadyVoted();

        voteTracker[propId][msg.sender] = true;

        if (support) {
            proposal.support++;
        } else {
            proposal.against++;
        }

        emit VoteCast(propId, msg.sender, support);
    }

    function finalizeProposal(uint256 propId) external onlyMember {
        Proposal storage proposal = allProposals[propId];
        if (propId >= totalProposals) revert InvalidProposal();
        if (proposal.finalized) revert ProposalClosed();
        if (block.timestamp < proposal.expires) revert ProposalClosed();

        proposal.finalized = true;

        emit ProposalFinalized(propId, proposal.support > proposal.against);
    }

    function hasVoted(uint256 propId, address user) external view returns (bool) {
        return voteTracker[propId][user];
    }

    function getProposal(uint256 propId) external view returns (
        address author,
        string memory content,
        uint256 support,
        uint256 against,
        bool isFinalized,
        uint256 expiration
    ) {
        Proposal memory p = allProposals[propId];
        return (
            p.author,
            p.content,
            p.support,
            p.against,
            p.finalized,
            p.expires
        );
    }
}
