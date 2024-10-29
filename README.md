# Solidity Smart Wallet

A basic Solidity Smart Wallet contract with owner and guardian management, allowance control, and secure transaction features. This smart contract was created as part of my journey to learn Solidity and explore decentralized applications.

## Features

- **Owner & Guardian Setup**: 
  - The contract is deployed with an owner (the `msg.sender` who deployed it).
  - 5 guardians are required at initialization to manage ownership transfer approvals.

- **Allowance Control**:
  - The owner can set spending allowances for specific addresses, defining a maximum limit for each address's transactions.
  - Non-owner users can only send funds up to their specified allowance.

- **Ownership Transfer**:
  - Ownership can be transferred by the current owner, but only with the approval of 3 out of the 5 guardians.

- **Low-Level Transactions**:
  - The contract includes a low-level fallback function, allowing funds to be sent directly to the contract.
  - Non-owner users can send funds to other contracts within their set allowance limits.

## Usage

- **Setting Allowance**: The owner can set spending allowances for addresses, limiting their transaction capabilities.
- **Sending Funds**: Non-owner users can send funds to other contracts up to their allowance.
- **Ownership Transfer**: The owner can propose a new owner, requiring approval from 3 guardians.

## License

This project is licensed under the MIT License.

## Acknowledgments

- Solidity documentation and tutorials
- Inspiration from decentralized finance (DeFi) solutions in the Ethereum ecosystem