// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./DeckType.sol";
import "./DeckEvent.sol";
import "./DeckResponse.sol";

contract DeckGame is Ownable {
using DeckType for DeckType.Card;
using DeckType for DeckType.Card;
    using DeckType for DeckType.Monster;
    using DeckType for DeckType.PrebuiltDeck;

    mapping(uint256 => DeckType.Card) private cards;
    mapping(uint256 => DeckType.Monster) private monsters;
    mapping(uint256 => DeckType.PrebuiltDeck) public prebuiltDecks; 
    uint256 private nextCardId;
    uint256 private nextMonsterId;
    uint256 private nextPrebuiltDeckId; 

    constructor() Ownable(msg.sender) {
        nextCardId = 1;
        nextMonsterId = 1;
        nextPrebuiltDeckId = 1;  
        initializeCards();
        initializeMonsters();
        initializePrebuiltDecks();
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
    ) public onlyOwner {
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

    /**
    * @notice Lấy thông tin một lá bài theo ID.
    * @param _cardId ID của lá bài cần lấy.
    * @return DeckResponse.CardWithId Struct chứa ID và dữ liệu lá bài.
    */
    function getCardById(uint256 _cardId) external view returns (DeckResponse.CardWithId memory) {
        require(_cardId > 0 && _cardId < nextCardId, "Invalid card ID");
        return DeckResponse.CardWithId({
            id: _cardId,
            card: cards[_cardId]
        });
    }

    /**
    * @notice Lấy danh sách phân trang các lá bài kèm ID.
    * @param pageIndex Chỉ số trang (bắt đầu từ 0).
    * @param pageSize Số lượng phần tử mỗi trang.
    * @return DeckResponse.PaginatedCardsWithId Struct chứa danh sách card kèm ID, tổng số trang, và tổng số phần tử.
    */
    function getCardsPaginated(uint256 pageIndex, uint256 pageSize)
        external
        view
        returns (DeckResponse.PaginatedCardsWithId memory)
    {
        require(pageSize > 0, "Page size must be greater than 0");

        uint256 totalElements = nextCardId - 1;
        uint256 totalPages = (totalElements + pageSize - 1) / pageSize;

        require(totalElements > 0 && pageIndex < totalPages, "Invalid page index");

        uint256 startIndex = pageIndex * pageSize + 1; // +1 vì card ID bắt đầu từ 1
        uint256 endIndex = startIndex + pageSize > nextCardId ? nextCardId : startIndex + pageSize;

        uint256 resultSize = endIndex - startIndex;
        DeckResponse.CardWithId[] memory cardsPage = new DeckResponse.CardWithId[](resultSize);

        for (uint256 i = 0; i < resultSize; i++) {
            uint256 cardId = startIndex + i;
            cardsPage[i] = DeckResponse.CardWithId({
                id: cardId,
                card: cards[cardId]
            });
        }

        // Trả về struct phân trang
        return DeckResponse.PaginatedCardsWithId({
            cardsPage: cardsPage,
            totalPages: totalPages,
            totalElements: totalElements
        });
    }

    /** 
     * @notice Tạo một quái vật mới.
     */
    function addMonster(
        string memory _name,
        uint256 _health,
        uint256 _attack,
        string memory _image,
        DeckType.Class[] memory _classes
    ) public onlyOwner {
        DeckType.Monster storage newMonster = monsters[nextMonsterId];
        newMonster.name = _name;
        newMonster.id = nextMonsterId;
        newMonster.health = _health;
        newMonster.attack = _attack;
        newMonster.image = _image;
        newMonster.classes = _classes;

        emit DeckEvent.MonsterAdded(nextMonsterId, _health, _attack);
        nextMonsterId++;
    }

    function getMonsterById(uint256 _monsterId) external view returns (DeckResponse.MonsterWithId memory) {
        require(_monsterId > 0 && _monsterId < nextMonsterId, "Invalid monster ID");
        return DeckResponse.MonsterWithId({
            id: _monsterId,
            monster: monsters[_monsterId]
        });
    }

    /**
    * @notice Lấy danh sách tất cả các monster hiện có trong game.
    * @return DeckResponse.MonsterWithId[] Danh sách các monster kèm ID.
    */
    function getAllMonsters() public view returns (DeckResponse.MonsterWithId[] memory) {
        DeckResponse.MonsterWithId[] memory monsterList = new DeckResponse.MonsterWithId[](nextMonsterId - 1);
        
        for (uint256 i = 1; i < nextMonsterId; i++) {
            monsterList[i - 1] = DeckResponse.MonsterWithId({
                id: i,
                monster: monsters[i]
            });
        }
        
        return monsterList;
    }

    function _toClassArray(DeckType.Class _class) private pure returns (DeckType.Class[] memory) {
        DeckType.Class[] memory classes = new DeckType.Class[](1);
        classes[0] = _class;
        return classes;
    }

    function _toClassArray2(DeckType.Class _class1, DeckType.Class _class2) private pure returns (DeckType.Class[] memory) {
        DeckType.Class[] memory classes = new DeckType.Class[](2);
        classes[0] = _class1;
        classes[1] = _class2;
        return classes;
    }

    function initializeMonsters() internal {
        // Blazing Titan
        addMonster(
            "Blazing Titan",
            10, 
            10, 
            "https://res.cloudinary.com/dlotuochc/image/upload/v1740556979/TCG%20Battle%20Adventure/z6354126054525_2ad806dc0b05292389e3814fd4a52b4b_hdltr9.jpg", 
            _toClassArray2(DeckType.Class.FIRE, DeckType.Class.EARTH)
        );

        // Frost Leviathan
        addMonster(
            "Frost Leviathan",
            90, 
            12, 
            "https://res.cloudinary.com/dlotuochc/image/upload/v1740556978/TCG%20Battle%20Adventure/z6354127462033_6522a713b85733977e587a86db918449_ecvusk.jpg", 
            _toClassArray2(DeckType.Class.WATER, DeckType.Class.METAL)
        );

        // Verdant Inferno
        addMonster(
            "Verdant Inferno",
            100, 
            14, 
            "https://res.cloudinary.com/dlotuochc/image/upload/v1740556978/TCG%20Battle%20Adventure/z6354126054382_4bcfc92da6d1c2a8317d54a0c40d3815_mxqnxq.jpg", 
            _toClassArray2(DeckType.Class.WOOD, DeckType.Class.FIRE)
        );

        // Iron Storm Drake
        addMonster(
            "Iron Storm Drake",
            85, 
            11, 
            "https://res.cloudinary.com/dlotuochc/image/upload/v1740556977/TCG%20Battle%20Adventure/z6354126035445_4e24d6074dd8af1d7f2cfe8ba6ee3279_qp0iux.jpg", 
            _toClassArray2(DeckType.Class.METAL, DeckType.Class.WATER)
        );

        // Ember Root Behemoth
        addMonster(
            "Ember Root Behemoth",
            95, 
            13, 
            "https://res.cloudinary.com/dlotuochc/image/upload/v1740556977/TCG%20Battle%20Adventure/z6354126460479_d294b8588d9bf0ec4599a7ca75036b4f_lwotj7.jpg", 
            _toClassArray2(DeckType.Class.FIRE, DeckType.Class.WOOD)
        );

        // Abyssal Stone Lord
        addMonster(
            "Abyssal Stone Lord",
            110, 
            15, 
            "https://res.cloudinary.com/dlotuochc/image/upload/v1740556977/TCG%20Battle%20Adventure/z6354126007751_4e9ead0f3b3db2b7d40e494a59521368_aosny8.jpg", 
            _toClassArray2(DeckType.Class.EARTH, DeckType.Class.METAL)
        );
    }


    function initializeCards() internal {
        // 1. Blazing Sword
        addCard("Blazing Sword", 5, 4, 2, 2, "https://res.cloudinary.com/dlotuochc/image/upload/v1739797748/TCG%20Battle%20Adventure/jzm1wj6kzrekhu3zq8an.png",
            DeckType.OnAttackEffect.CRITICAL_STRIKE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.FIRE));

        // 2. Frost Shield
        addCard("Frost Shield", 2, 8, 2, 2, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049298/TCG%20Battle%20Adventure/r9ahkormzgxdmlfwuj9s.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.THORNS, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.WATER));

        // 3. Venom Dagger
        addCard("Venom Dagger", 3, 4, 3, 1, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049294/TCG%20Battle%20Adventure/vgsemseiixtxtyjjfo1v.png",
            DeckType.OnAttackEffect.LIFESTEAL, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.WOOD));

        // 4. Healing Light
        addCard("Healing Light", 2, 6, 2, 2, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049289/TCG%20Battle%20Adventure/hwa5oiqezmwdiid5gaci.jpg",
            DeckType.OnAttackEffect.LIFESTEAL, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.WATER));

        // 5. Berserker’s Rage
        addCard("Berserker's Rage", 7, 5, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049296/TCG%20Battle%20Adventure/bwmtrdybdv8wnz3zycg7.png",
            DeckType.OnAttackEffect.CRITICAL_STRIKE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.SACRIFICE, _toClassArray(DeckType.Class.FIRE));

        // 6. Shadow Step
        addCard("Shadow Step", 3, 5, 2, 2, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049293/TCG%20Battle%20Adventure/vnwlzhguts8rfc7jkhnp.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.SACRIFICE, _toClassArray(DeckType.Class.WOOD));

        // 7. Arcane Blast
        addCard("Arcane Blast", 6, 4, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049296/TCG%20Battle%20Adventure/lm03b601m6xeobc7wczu.png",
            DeckType.OnAttackEffect.CRITICAL_STRIKE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.METAL));

        // 8. Stone Wall
        addCard("Stone Wall", 2, 10, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049294/TCG%20Battle%20Adventure/pmvgcr6abzs1p2d8yarx.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.THORNS, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.EARTH));

        // 9. Fire Elemental
        addCard("Fire Elemental", 4, 6, 2, 2, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049296/TCG%20Battle%20Adventure/re7ggndj9lxailwqsf2y.png",
            DeckType.OnAttackEffect.CRITICAL_STRIKE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.FIRE));

        // 10. Ice Spear
        addCard("Ice Spear", 3, 5, 2, 2, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049290/TCG%20Battle%20Adventure/ufmrlee4xkdapmpsizuj.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.THORNS, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.WATER));

        // 11. Abyss Crawler
        addCard("Abyss Crawler", 6, 5, 2, 2, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049294/TCG%20Battle%20Adventure/aeklge0zyujx8ikxcryz.png",
            DeckType.OnAttackEffect.LIFESTEAL, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.WOOD));

        // 12. Soul Eater
        addCard("Soul Eater", 5, 6, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049292/TCG%20Battle%20Adventure/mlqpln4i9bznjomk7muz.png",
            DeckType.OnAttackEffect.LIFESTEAL, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.METAL));

        // 13. Thunder Drake
        addCard("Thunder Drake", 7, 6, 1, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049291/TCG%20Battle%20Adventure/sgpqtvvxsop5g9x04wa4.png",
            DeckType.OnAttackEffect.CRITICAL_STRIKE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray2(DeckType.Class.METAL, DeckType.Class.WATER));

        // 14. Necro Mage
        addCard("Necro Mage", 4, 7, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049291/TCG%20Battle%20Adventure/zfna0w9d2ndjyyyjbmph.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.SACRIFICE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.EARTH));

        // 15. Blood Reaper
        addCard("Blood Reaper", 8, 5, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049295/TCG%20Battle%20Adventure/qpfcfs8vffnipuicubrn.png",
            DeckType.OnAttackEffect.LIFESTEAL, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.METAL));

        // 16. Iron Golem
        addCard("Iron Golem", 4, 12, 1, 4, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049291/TCG%20Battle%20Adventure/wqujynso8o9akodknazz.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.THORNS, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.METAL));

        // 17. Phantom Blade
        addCard("Phantom Blade", 6, 4, 2, 2, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049291/TCG%20Battle%20Adventure/vhdctqr1lot3u202xthg.png",
            DeckType.OnAttackEffect.CRITICAL_STRIKE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.METAL));

        // 18. Void Warden
        addCard("Void Warden", 5, 8, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049294/TCG%20Battle%20Adventure/fyhboeidk6dgfaldgbce.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.THORNS, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.EARTH));

        // 19. Lava Behemoth
        addCard("Lava Behemoth", 9, 8, 1, 4, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049291/TCG%20Battle%20Adventure/nonfpunalm20kyfl6jxe.png",
            DeckType.OnAttackEffect.CRITICAL_STRIKE, DeckType.OnDeadEffect.EXPLODE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray2(DeckType.Class.FIRE, DeckType.Class.EARTH));

        // 20. Crystal Serpent
        addCard("Crystal Serpent", 4, 9, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049328/TCG%20Battle%20Adventure/vi2awomtpdu6bwzt9vgg.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.THORNS, DeckType.ActiveSkill.NONE, _toClassArray2(DeckType.Class.EARTH, DeckType.Class.METAL));

        // 21. Stormcaller
        addCard("Stormcaller", 6, 5, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049294/TCG%20Battle%20Adventure/ykavqv8jwrrw4s7gemh5.png",
            DeckType.OnAttackEffect.CRITICAL_STRIKE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.WATER));

        // 22. Shadow Beast
        addCard("Shadow Beast", 7, 4, 2, 2, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049292/TCG%20Battle%20Adventure/dqxfnzy7pxmy31divjpf.png",
            DeckType.OnAttackEffect.CRITICAL_STRIKE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.WOOD));

        // 23. Ancient Guardian
        addCard("Ancient Guardian", 3, 12, 1, 4, "https://res.cloudinary.com/dlotuochc/image/upload/v1740051204/TCG%20Battle%20Adventure/btxjd57q0zdo0pj8c5ue.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.THORNS, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.EARTH));

        // 24. Cursed Doll
        addCard("Cursed Doll", 3, 5, 2, 2, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049295/TCG%20Battle%20Adventure/byimjbt4jdxrlsluvpb7.png",
            DeckType.OnAttackEffect.LIFESTEAL, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.WOOD));

        // 25. Doom Bringer
        addCard("Doom Bringer", 8, 6, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049295/TCG%20Battle%20Adventure/rmdav3sz3idglw8n0elj.png",
            DeckType.OnAttackEffect.CRITICAL_STRIKE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.METAL));

        // 26. Forest Wraith
        addCard("Forest Wraith", 5, 6, 2, 2, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049298/TCG%20Battle%20Adventure/zuv1adu24pfvq6pk11tq.png",
            DeckType.OnAttackEffect.LIFESTEAL, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.WOOD));

        // 27. Molten Fiend
        addCard("Molten Fiend", 6, 5, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049290/TCG%20Battle%20Adventure/y4f0d2pntrgjhfbqpq8n.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.EXPLODE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.FIRE));

        // 28. Frost Revenant
        addCard("Frost Revenant", 4, 7, 2, 2, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049298/TCG%20Battle%20Adventure/gsywiudl3ul991qgjbjy.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.THORNS, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.WATER));

        // 29. Skybreaker
        addCard("Skybreaker", 10, 4, 1, 4, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049292/TCG%20Battle%20Adventure/u8t4oxqdpunhsbtpxyyu.png",
            DeckType.OnAttackEffect.CRITICAL_STRIKE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.METAL));

        // 30. Plague Harbinger
        addCard("Plague Harbinger", 5, 6, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1740049292/TCG%20Battle%20Adventure/o9vyx6irjqiyonfltr5m.png",
            DeckType.OnAttackEffect.LIFESTEAL, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.WOOD));

        // 31. Bone Dragon
        addCard("Bone Dragon", 7, 8, 1, 4, "https://res.cloudinary.com/dlotuochc/image/upload/v1739799615/TCG%20Battle%20Adventure/evulnnlv4zwrrvmftmig.png",
            DeckType.OnAttackEffect.CRITICAL_STRIKE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.THORNS, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.EARTH));

        // 32. Astral Phantom
        addCard("Astral Phantom", 4, 5, 2, 2, "https://res.cloudinary.com/dlotuochc/image/upload/v1739799446/TCG%20Battle%20Adventure/ism9nbuglmitrjsubmo1.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.SACRIFICE, _toClassArray(DeckType.Class.METAL));

        // 33. Blood Alchemist
        addCard("Blood Alchemist", 6, 6, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1739799266/TCG%20Battle%20Adventure/yqrbzo4klyklxhupqvur.png",
            DeckType.OnAttackEffect.LIFESTEAL, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.FIRE));

        // 34. Wicked Puppeteer
        addCard("Wicked Puppeteer", 3, 7, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1739799181/TCG%20Battle%20Adventure/lkmxy6cguhzjdwnzkkgh.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.SACRIFICE, _toClassArray(DeckType.Class.WOOD));

        // 35. Obsidian Titan
        addCard("Obsidian Titan", 5, 10, 1, 4, "https://res.cloudinary.com/dlotuochc/image/upload/v1739799056/TCG%20Battle%20Adventure/f96kp7c0xoneknpixjqj.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.THORNS, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.EARTH));

        // 36. Nightmare Stalker
        addCard("Nightmare Stalker", 7, 4, 2, 2, "https://res.cloudinary.com/dlotuochc/image/upload/v1739798953/TCG%20Battle%20Adventure/qkkspuiwige47obk7shd.png",
            DeckType.OnAttackEffect.CRITICAL_STRIKE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.WOOD));

        // 37. Phoenix Rebirth
        addCard("Phoenix Rebirth", 6, 5, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1739798578/TCG%20Battle%20Adventure/ft2siwxlhnjtuncbigdf.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.EXPLODE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.SACRIFICE, _toClassArray(DeckType.Class.FIRE));

        // 38. Void Specter
        addCard("Void Specter", 5, 6, 2, 3, "https://res.cloudinary.com/dlotuochc/image/upload/v1739798389/TCG%20Battle%20Adventure/b9aacgyeclbrwqk9zgjn.png",
            DeckType.OnAttackEffect.LIFESTEAL, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.NONE, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.METAL));

        // 39. Golem of Ruin
        addCard("Golem of Ruin", 6, 8, 1, 4, "https://res.cloudinary.com/dlotuochc/image/upload/v1739798680/TCG%20Battle%20Adventure/r3i1t2tgftgr3p6fo9i8.png",
            DeckType.OnAttackEffect.NONE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.THORNS, DeckType.ActiveSkill.NONE, _toClassArray(DeckType.Class.EARTH));

        // 40. King of Abyss
        addCard("King of Abyss", 8, 10, 1, 4, "https://res.cloudinary.com/dlotuochc/image/upload/v1739797997/TCG%20Battle%20Adventure/wsx7msv8qgeefylwbwv9.png",
            DeckType.OnAttackEffect.CRITICAL_STRIKE, DeckType.OnDeadEffect.NONE, DeckType.OnDefenseEffect.THORNS, DeckType.ActiveSkill.NONE, _toClassArray2(DeckType.Class.EARTH, DeckType.Class.METAL));
    }

    function addPrebuiltDeck(
        string memory _name,
        string memory _description,
        string memory _difficulty,
        string memory _playstyle,
        string[] memory _strengths,
        string[] memory _weaknesses,
        uint256[] memory _cardIds,
        string memory _coverImage,
        string memory _strategy
    ) public onlyOwner {
        DeckType.PrebuiltDeck storage deck = prebuiltDecks[nextPrebuiltDeckId];
        deck.name = _name;
        deck.description = _description;
        deck.difficulty = _difficulty;
        deck.playstyle = _playstyle;
        deck.strengths = _strengths;
        deck.weaknesses = _weaknesses;
        deck.coverImage = _coverImage;
        deck.strategy = _strategy;

        // Sao chép cards trực tiếp từ storage sang storage
        DeckType.Card[] storage deckCards = prebuiltDecks[nextPrebuiltDeckId].cards;
        for (uint256 i = 0; i < _cardIds.length; i++) {
            require(cards[_cardIds[i]].id != 0, "Card does not exist");
            deckCards.push(cards[_cardIds[i]]);  // Sao chép từ storage
        }

        nextPrebuiltDeckId++;
    }

    /**
    * @notice Lấy danh sách tất cả các prebuilt deck hiện có trong game.
    * @return DeckResponse.PrebuiltDeckWithId[] Danh sách các prebuilt deck kèm ID.
    */
    function getAllPrebuiltDecks() public view returns (DeckResponse.PrebuiltDeckWithId[] memory) {
        DeckResponse.PrebuiltDeckWithId[] memory deckList = new DeckResponse.PrebuiltDeckWithId[](nextPrebuiltDeckId - 1);
        
        for (uint256 i = 1; i < nextPrebuiltDeckId; i++) {
            deckList[i - 1] = DeckResponse.PrebuiltDeckWithId({
                id: i,
                deck: prebuiltDecks[i]
            });
        }
        
        return deckList;
    }

    function initializePrebuiltDecks() private {
        // Deck 1: Inferno Dominance
        string[] memory strengths1 = new string[](3);
        strengths1[0] = "High burst damage";
        strengths1[1] = "Critical strikes";
        strengths1[2] = "Explosive effects";
        string[] memory weaknesses1 = new string[](2);
        weaknesses1[0] = "Low survivability";
        weaknesses1[1] = "Vulnerable to control";
        uint256[] memory cardIds1 = new uint256[](13);
        cardIds1[0] = 1;   // Fire Dragon x2
        cardIds1[1] = 1;
        cardIds1[2] = 6;   // Flame Assassin x2
        cardIds1[3] = 6;
        cardIds1[4] = 16;  // Phoenix Warrior x2
        cardIds1[5] = 16;
        cardIds1[6] = 11;  // Volcanic Giant
        cardIds1[7] = 3;   // Water Elemental x2
        cardIds1[8] = 3;
        cardIds1[9] = 8;   // Water Healer x2
        cardIds1[10] = 8;
        cardIds1[11] = 12; // Storm Mage x2
        cardIds1[12] = 12;
        addPrebuiltDeck(
            "Inferno Dominance",
            "Overwhelm your enemies with aggressive fire attacks and explosive combinations",
            "Medium",
            "Aggressive",
            strengths1,
            weaknesses1,
            cardIds1,
            "https://images.unsplash.com/photo-1544553866-7f0d760b6f46?q=80&w=2070",
            "Focus on dealing maximum damage early. Use Water Elementals for sustain and Storm Mages for consistent damage."
        );

        // Deck 2: Mountain's Bulwark
        string[] memory strengths2 = new string[](3);
        strengths2[0] = "High health pool";
        strengths2[1] = "Thorns damage";
        strengths2[2] = "Good sustain";
        string[] memory weaknesses2 = new string[](2);
        weaknesses2[0] = "Low mobility";
        weaknesses2[1] = "Weak to burst damage";
        uint256[] memory cardIds2 = new uint256[](13);
        cardIds2[0] = 2;   // Earth Golem x3
        cardIds2[1] = 2;
        cardIds2[2] = 2;
        cardIds2[3] = 7;   // Stone Guardian x2
        cardIds2[4] = 7;
        cardIds2[5] = 17;  // Crystal Golem x2
        cardIds2[6] = 17;
        cardIds2[7] = 13;  // Nature's Warden x2
        cardIds2[8] = 13;
        cardIds2[9] = 15;  // Ancient Treant
        cardIds2[10] = 10; // Forest Druid x2
        cardIds2[11] = 10;
        cardIds2[12] = 20; // Forest Scout
        addPrebuiltDeck(
            "Mountain's Bulwark",
            "An impenetrable fortress of earth and stone",
            "Easy",
            "Defensive",
            strengths2,
            weaknesses2,
            cardIds2,
            "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?q=80&w=2070",
            "Build a wall of high-health units. Use thorns effects to punish attackers while slowly grinding them down."
        );

        // Deck 3: Steel Legion
        string[] memory strengths3 = new string[](3);
        strengths3[0] = "Balanced stats";
        strengths3[1] = "Critical strikes";
        strengths3[2] = "Armor effects";
        string[] memory weaknesses3 = new string[](2);
        weaknesses3[0] = "Resource intensive";
        weaknesses3[1] = "Complex combinations";
        uint256[] memory cardIds3 = new uint256[](13);
        cardIds3[0] = 4;   // Metal Knight x2
        cardIds3[1] = 4;
        cardIds3[2] = 9;   // Metal Berserker x2
        cardIds3[3] = 9;
        cardIds3[4] = 14;  // Blade Master x2
        cardIds3[5] = 14;
        cardIds3[6] = 19;  // Steel Sentinel x2
        cardIds3[7] = 19;
        cardIds3[8] = 12;  // Storm Mage x2
        cardIds3[9] = 12;
        cardIds3[10] = 17; // Crystal Golem x2
        cardIds3[11] = 17;
        cardIds3[12] = 11; // Volcanic Giant
        addPrebuiltDeck(
            "Steel Legion",
            "Precise strikes and calculated moves",
            "Hard",
            "Control",
            strengths3,
            weaknesses3,
            cardIds3,
            "https://images.unsplash.com/photo-1563089145-599997674d42?q=80&w=2070",
            "Control the battlefield with armored units while setting up powerful critical strike combinations."
        );

        // Deck 4: Wild Synthesis
        string[] memory strengths4 = new string[](3);
        strengths4[0] = "Synergy bonuses";
        strengths4[1] = "Resource efficient";
        strengths4[2] = "Flexible gameplay";
        string[] memory weaknesses4 = new string[](2);
        weaknesses4[0] = "Requires setup";
        weaknesses4[1] = "Weak individually";
        uint256[] memory cardIds4 = new uint256[](13);
        cardIds4[0] = 5;   // Wood Elf x3
        cardIds4[1] = 5;
        cardIds4[2] = 5;
        cardIds4[3] = 10;  // Forest Druid x2
        cardIds4[4] = 10;
        cardIds4[5] = 15;  // Ancient Treant
        cardIds4[6] = 13;  // Nature's Warden x2
        cardIds4[7] = 13;
        cardIds4[8] = 3;   // Water Elemental x2
        cardIds4[9] = 3;
        cardIds4[10] = 8;  // Water Healer x2
        cardIds4[11] = 8;
        cardIds4[12] = 7;  // Stone Guardian (dựa trên index trong cardPool)
        addPrebuiltDeck(
            "Wild Synthesis",
            "Harness the power of nature's harmony",
            "Medium",
            "Combo",
            strengths4,
            weaknesses4,
            cardIds4,
            "https://images.unsplash.com/photo-1511497584788-876760111969?q=80&w=2070",
            "Build powerful combinations between Wood and Water units. Focus on healing and sustain while growing stronger."
        );

        // Deck 5: Elemental Chaos
        string[] memory strengths5 = new string[](3);
        strengths5[0] = "Unpredictable";
        strengths5[1] = "Powerful effects";
        strengths5[2] = "Multiple strategies";
        string[] memory weaknesses5 = new string[](2);
        weaknesses5[0] = "Inconsistent";
        weaknesses5[1] = "Hard to master";
        uint256[] memory cardIds5 = new uint256[](13);
        cardIds5[0] = 1;   // Fire Dragon
        cardIds5[1] = 2;   // Earth Golem
        cardIds5[2] = 3;   // Water Elemental
        cardIds5[3] = 4;   // Metal Knight
        cardIds5[4] = 5;   // Wood Elf
        cardIds5[5] = 11;  // Volcanic Giant
        cardIds5[6] = 12;  // Storm Mage
        cardIds5[7] = 13;  // Nature's Warden
        cardIds5[8] = 14;  // Blade Master
        cardIds5[9] = 15;  // Ancient Treant
        cardIds5[10] = 16; // Phoenix Warrior
        cardIds5[11] = 17; // Crystal Golem
        cardIds5[12] = 18; // Tide Caller
        addPrebuiltDeck(
            "Elemental Chaos",
            "Master all elements in perfect discord",
            "Expert",
            "Versatile",
            strengths5,
            weaknesses5,
            cardIds5,
            "https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=2070",
            "Adapt to each situation by combining different elemental effects. Requires deep knowledge of all mechanics."
        );
    }

}
