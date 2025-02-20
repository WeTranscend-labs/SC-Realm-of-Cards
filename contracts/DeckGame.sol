// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./DeckType.sol";

contract DeckGame {
    using DeckType for DeckType.Card;
    
    mapping(uint256 => DeckType.Card) private cards;
    uint256 private nextCardId;
    address public owner;
    
    event CardAdded(uint256 indexed cardId, string name, uint256 attack, uint256 health);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        nextCardId = 1;
    }
    
    function addCard(
        string memory _name,
        uint256 _attack,
        uint256 _health,
        uint256 _maxPerSession,
        uint256 _staminaCost,
        string memory _image,
        DeckType.OnAttackEffect _onAttackEffect,
        DeckType.OnDeadEffect _onDeadEffect,
        DeckType.OnDefenseEffect _onDefenseEffect,
        DeckType.ActiveSkill _activeSkill,
        DeckType.Class[] memory _classes
    ) external onlyOwner {
        DeckType.Card storage newCard = cards[nextCardId];
        newCard.id = nextCardId;
        newCard.name = _name;
        newCard.attack = _attack;
        newCard.health = _health;
        newCard.maxPerSession = _maxPerSession;
        newCard.staminaCost = _staminaCost;
        newCard.image = _image;
        newCard.onAttackEffect = _onAttackEffect;
        newCard.onDeadEffect = _onDeadEffect;
        newCard.onDefenseEffect = _onDefenseEffect;
        newCard.activeSkill = _activeSkill;
        newCard.classes = _classes;
        
        emit CardAdded(nextCardId, _name, _attack, _health);
        nextCardId++;
    }
    
    function getCard(uint256 _cardId) external view returns (DeckType.Card memory) {
        return cards[_cardId];
    }
}
