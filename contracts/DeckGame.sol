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
        initializeCards();
        initializeMonsters();
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

    /**
     * @notice Lấy thông tin quái vật theo ID.
     */
    function getMonsterById(uint256 _monsterId) external view returns (DeckType.Monster memory) {
        return monsters[_monsterId];
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
}
