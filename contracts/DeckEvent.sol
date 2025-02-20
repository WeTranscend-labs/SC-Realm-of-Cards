// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library DeckEvent {
    event CardAdded(uint256 indexed cardId, string name, uint256 attack, uint256 health);
}
