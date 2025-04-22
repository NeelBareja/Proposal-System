# 🗳️ Proposal System Smart Contract

A decentralized voting contract built on Solidity that allows users to create, vote, and manage proposals transparently. The proposal succeeds if **60% or more of the total votes are in favor** (approve).

## 📌 Features

- ✅ Create new proposals with a title and description
- ✅ Voting options: Approve (1), Reject (2), Pass (0)
- ✅ Proposal success logic based on 60% approval rule
- ✅ Prevents double voting
- ✅ Automatically deactivates the proposal once total votes reach the threshold

## ⚙️ Smart Contract Details

- **Language:** Solidity `^0.8.18`
- **Contract Name:** `ProposalSystem`
- **License:** MIT
- **Deployed on Testnet:** Goerli / Sepolia / BNB Chain Testnet *(choose one based on your deployment)*

## 🔐 Proposal Structure

Each proposal includes:
- `title`: Title of the proposal
- `description`: Detailed explanation
- `approve`: Count of approval votes
- `reject`: Count of rejection votes
- `pass`: Count of abstentions
- `total_vote_to_end`: Maximum number of votes before proposal closes
- `current_state`: `true` if passed, `false` otherwise
- `is_active`: Whether the proposal is still accepting votes

## 🛠️ Functions

| Function | Access | Description |
|---------|--------|-------------|
| `createProposal(string description, uint total_vote_to_end, string title)` | Only Owner | Creates a new proposal |
| `vote(uint8 choice)` | Public | Vote on the active proposal (1 = Approve, 2 = Reject, 0 = Pass) |
| `getCurrentProposal()` | Public | View current active proposal |
| `getProposal(uint number)` | Public | View a specific proposal by ID |
| `setOwner(address new_owner)` | Only Owner | Transfer ownership |

## 🧮 Custom Voting Logic

```solidity
function calculateCurrentState() private view returns (bool) {
    uint256 total_votes = proposal.approve + proposal.reject + proposal.pass;
    if (total_votes == 0) return false;

    uint256 approvePercentage = (proposal.approve * 100) / total_votes;
    return approvePercentage >= 60;
}
```

- ✅ A proposal is successful only if approval votes are ≥ 60% of the total votes (including pass votes).

- ❌ Otherwise, it is rejected once the total vote count reaches the limit.

## 🚀 Deployment Instructions

1. Open Remix IDE

2. Compile the contract using Solidity version 0.8.18

3. Use Injected Web3 environment with MetaMask connected to a testnet

4. Deploy and confirm transaction

5. Save the Contract Address

## 🌐 Testnet Deployment

- Network: Goerli Testnet (or Sepolia / BNB Testnet)

- Contract Address: 0xYourDeployedContractAddressHere

## 📁 Repository Structure

```
proposal-system/
├── contracts/
│   └── ProposalSystem.sol
├── README.md
```
