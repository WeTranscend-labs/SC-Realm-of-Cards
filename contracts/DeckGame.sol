// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./DeckType.sol";
import "./DeckEvent.sol";
import "./DeckResponse.sol";

contract DeckGame is Ownable {
    using DeckType for DeckType.Card;
    using DeckType for DeckType.Monster;

    mapping(uint256 => DeckType.Card) private cards;
    mapping(uint256 => DeckType.Monster) private monsters;

    uint256 private nextCardId;
    uint256 private nextMonsterId;

    constructor() Ownable(msg.sender) {
        nextCardId = 1;
        nextMonsterId = 1;
    }

    /** 
     * @notice Thêm một lá bài mới vào game.
     */
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

        emit DeckEvent.CardAdded(nextCardId, _name, _attack, _health);
        nextCardId++;
    }

    function getCard(uint256 _cardId) external view returns (DeckType.Card memory) {
        return cards[_cardId];
    }

    function getCardsPaginated(uint256 pageIndex, uint256 pageSize)
        external
        view
        returns (DeckResponse.PaginatedCards memory)
    {
        require(pageSize > 0, "Page size must be greater than 0");

        uint256 totalElements = nextCardId - 1;
        uint256 totalPages = (totalElements + pageSize - 1) / pageSize;

        require(pageIndex < totalPages, "Invalid page index");

        uint256 startIndex = pageIndex * pageSize + 1;
        uint256 endIndex = startIndex + pageSize;
        if (endIndex > nextCardId) {
            endIndex = nextCardId;
        }

        uint256 resultSize = endIndex - startIndex;
        DeckType.Card[] memory cardsPage = new DeckType.Card[](resultSize);

        for (uint256 i = 0; i < resultSize; i++) {
            cardsPage[i] = cards[startIndex + i];
        }

        return DeckResponse.PaginatedCards(cardsPage, totalPages, totalElements);
    }

    /** 
     * @notice Tạo một quái vật mới.
     */
    function createMonster(
        uint256 _health,
        uint256 _attack,
        string memory _image,
        DeckType.Class[] memory _classes
    ) external onlyOwner {
        DeckType.Monster storage newMonster = monsters[nextMonsterId];
        newMonster.id = nextMonsterId;
        newMonster.health = _health;
        newMonster.attack = _attack;
        newMonster.image = _image;
        newMonster.classes = _classes;

        emit DeckEvent.MonsterAdded(nextMonsterId, _health, _attack);
        nextMonsterId++;
    }

    /**
     * @notice Lấy thông tin quái vật theo ID.
     */
    function getMonsterById(uint256 _monsterId) external view returns (DeckType.Monster memory) {
        return monsters[_monsterId];
    }
}
