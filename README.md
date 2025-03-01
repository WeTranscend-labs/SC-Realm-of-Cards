# Realm of Cards - Smart Contracts
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT) [![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg)](https://github.com/WeTranscend-labs/FE-Realm-of-Cards/actions) [![Version](https://img.shields.io/badge/Version-1.0.0-orange.svg)](https://github.com/WeTranscend-labs/FE-Realm-of-Cards/releases) [![HappyChain](https://img.shields.io/badge/Blockchain-HappyChain-yellow.svg)](https://happy-testnet-sepolia.hub.caldera.xyz/)

  

Welcome to the heart of **Realm of Cards - TCG Battle Adventure**! This repository houses the smart contracts that power the game’s blockchain integration, ensuring secure card ownership, tamper-proof game progress, and optimized gas efficiency on the **HappyChain Testnet**. Whether you're summoning legendary decks or battling ancient monsters, these contracts are the magical glue tying the realm together. Let’s explore the blockchain sorcery within! ⚔️

----------

## Table of Contents

- [What is Realm of Cards - Smart Contracts?](#what-is-realm-of-cards---smart-contracts)
- [How to Get Started](#how-to-get-started)
  - [Installation](#installation)
- [Technologies Powering the Contracts](#technologies-powering-the-contracts)
- [Project Structure](#project-structure)
- [How to Contribute](#how-to-contribute)
- [License](#license)

  

----------

## What is Realm of Cards - Smart Contracts?

**Realm of Cards - Smart Contracts** forms the blockchain backbone of this trading card game adventure. These contracts:
-   Manage **NFT-based card ownership** for players to collect, trade, and battle with their unique decks.

-   Store **card data** on-chain, ensuring every spell, weapon, and creature in your deck is securely tracked.
 
-   Track **monster data**, defining the fearsome foes players must defeat in their epic quests.

Built for seamless integration with the game’s backend and frontend, these contracts bring the realm to life with decentralized magic. Ready to dive into the code that powers the adventure? 🧙‍♂️

----------

## How to Get Started

Ready to deploy these contracts and unleash the blockchain magic? Follow these steps to set up and interact with the smart contracts locally or on **HappyChain Testnet**!

### Installation

To get started with the **Realm of Cards - Smart Contracts**, follow these steps to clone the repository and deploy the smart contracts using **Remix IDE**. This guide assumes you are working with the SC-Realm-of-Cards repository on GitHub and deploying to the **HappyChain Testnet**.

#### 1. **Prepare Your Environment**

  

-   **Access Remix IDE**: Open your browser and navigate to [Remix IDE](https://remix.ethereum.org/).
  
-   **Set Up MetaMask**:  
    -   Install the MetaMask extension if you don’t already have it.
      
    -   Add the **HappyChain Testnet** network to MetaMask via [HappChain testnet page](https://happy-testnet-sepolia.hub.caldera.xyz)
        
      
    -   Get some testnet HAPPY from the [HappyChain faucet](https://happy-testnet-sepolia.hub.caldera.xyz/) to cover gas fees.
      
#### 2. **Clone the Repository into Remix IDE**

Remix IDE supports cloning GitHub repositories directly into its workspace. Here’s how:

-   **Open File Explorer**:  
    -   On the left sidebar, click the **File Explorer** icon (looks like a folder).
      
    -   If it’s not visible, activate it via **Plugin Manager** (plug icon) > Search for "File Explorer" > Activate.

-   **Clone the Repository**:  
    -   In **File Explorer**, click the **Clone Git Repository** icon (a down arrow or Git symbol).
      
    -   Paste the following URL:  
	     ```
	    https://github.com/WeTranscend-labs/SC-Realm-of-Cards.git 
	    ```
    -   Click **OK** to import the repository into your workspace.

-   **Verify the Files**:  
    -   Ensure key folders like contracts/, scripts/, and test/ are loaded.
      
    -   Open the main contract file contracts/DeckGame.sol, to inspect the code.
      

#### 3. **Compile the Smart Contract**

Before deployment, compile the contract to check for errors.

-   **Select the Contract**:  
    -   Double-click DeckGame.sol  in **File Explorer**.
      
    
  
-   **Open the Compiler**:  
    -   Click the **Solidity Compiler** icon (an "S") on the left sidebar.
      
-   **Configure and Compile**:  
    -   Set the Solidity version to match the pragma solidity line in your contract (e.g., 0.8.20).
      
    -   Click **Compile TCGAdventure.sol** or enable **Auto compile**.

-   **Check the Output**:  
    -   A green checkmark means it compiled successfully. 

#### 4. **Deploy the Smart Contract on HappyChain Testnet**

Now, deploy your contract using Remix and MetaMask.


-   **Open the Deploy Tab**:  
    -   Click the **Deploy & Run Transactions** icon (down arrow) on the left sidebar.
      

-   **Connect MetaMask**:  
    -   In the **Environment** dropdown, select **Injected Provider - MetaMask**.
      
    -   Approve the connection in MetaMask and ensure you’re on **HappyChain Testnet**.
      

-   **Deploy the Contract**:  
    -   From the **Contract** dropdown, select DeckGame.
      
    -   Click **Deploy** and confirm the transaction in MetaMask.
      
-   **Get the Contract Address**:  
    -   Once deployed, the contract address will appear under **Deployed Contracts**.
      
#### 5. **Interact with the Deployed Contract**

Test and interact with your contract directly in Remix. 

-   **Access Functions**:  
    -   Expand the contract under **Deployed Contracts** to see its functions.

-   **Call Functions**:  
    -   For **view** functions (e.g., getCardById), input parameters and click to see the output.
      
    -   For **write** functions (e.g., addCard), input parameters, click, and confirm the transaction in MetaMask.

-   **Example**:  
    -   To add a card, call addCard with your address and input parameters.
      
#### 6. **Important Notes**:

-   **Gas Fees**: Make sure you have enough testnet HAPPY in your MetaMask wallet.
  
-   **Network Check**: Double-check that Remix and MetaMask are both on **HappyChain Testnet**.
  
-   **Troubleshooting**:  
    -   _“Nonce too high”_: Reset your MetaMask account (Settings > Advanced > Reset Account).
      
    -   _“Compilation failed”_: Verify the Solidity version or fix syntax errors in the code.

----------

## Technologies Powering the Contracts

These smart contracts are forged with a powerful stack of tools to ensure security, efficiency, and scalability:

-   **Solidity**: The language of the realm, used to craft the smart contracts (v0.8.x).
  
-   **OpenZeppelin**: Secure, audited contracts for ERC-721 (NFT) functionality.
  
-   **HappyChain**: The blockchain network providing low-cost, high-speed transactions.

Together, these tools anchor the game’s decentralized features, from NFT card minting to progress tracking, all while keeping gas costs in check!

----------

## Project Structure

```
.
└── contracts/                # Contains the Solidity smart contracts that form the core of the project
    ├── DeckEvent.sol         # Manages events related to deck activities, such as creation, modification, or usage in games
    ├── DeckGame.sol          # Handles the game logic involving decks, including rules, interactions, and game state management
    ├── DeckResponse.sol      # Deals with responses or outcomes from deck-related actions, such as success or failure states
    └── DeckType.sol          # Defines different types or categories of decks, along with their associated properties or behaviors
```
----------

## How to Contribute

Ready to forge new spells in the realm? We welcome contributions! Fork the repository, enhance the contracts, and submit a pull request. Whether it’s adding new features (e.g., PvP battles), optimizing gas usage, or fixing bugs, your efforts will make **Realm of Cards** even more legendary! 🧙‍♂️⚡

----------

## License 

**Realm of Cards - Smart Contracts** is released under the **MIT License**. Feel free to explore, modify, and share—just check the [LICENSE](./LICENSE) file for details.
