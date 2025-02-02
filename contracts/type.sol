// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library MonsterLibrary {
    // Ngũ hành với tiếng Anh
    enum Element { NONE, METAL, WOOD, WATER, FIRE, EARTH }

    // Hệ thống khắc chế ngũ hành (Mapping)
    function isWeakAgainst(Element attacker, Element defender) internal pure returns (bool) {
        if (attacker == Element.METAL && defender == Element.FIRE) return true;
        if (attacker == Element.WOOD && defender == Element.METAL) return true;
        if (attacker == Element.WATER && defender == Element.WOOD) return true;
        if (attacker == Element.FIRE && defender == Element.WATER) return true;
        if (attacker == Element.EARTH && defender == Element.METAL) return true;
        return false;
    }

    function isStrongAgainst(Element attacker, Element defender) internal pure returns (bool) {
        if (attacker == Element.FIRE && defender == Element.METAL) return true;
        if (attacker == Element.METAL && defender == Element.WOOD) return true;
        if (attacker == Element.WOOD && defender == Element.WATER) return true;
        if (attacker == Element.WATER && defender == Element.FIRE) return true;
        if (attacker == Element.METAL && defender == Element.EARTH) return true;
        return false;
    }

    // Lớp của quái vật (Monster Class = Ngũ hành luôn)
    enum MonsterClass { NONE, METAL, WOOD, WATER, FIRE, EARTH }

    // Hiệu ứng khi tấn công
    enum OnAttackEffect { NONE, LIFESTEAL, CRITICAL_STRIKE }

    // Hiệu ứng khi chết
    enum OnDeadEffect { NONE, EXPLODE, THORNS, SACRIFICE }

    // Hiệu ứng khi phòng thủ
    enum OnDefenseEffect { NONE, THORNS }

    // Kỹ năng chủ động
    enum ActiveSkill { NONE, SACRIFICE }

    // Cấu trúc thẻ bài (Card)
    struct Card {
        uint256 id;
        string name;
        uint256 attack;
        uint256 health;
        uint256 maxPerSession;
        uint256 staminaCost;
        OnAttackEffect onAttackEffect;
        OnDeadEffect onDeadEffect;
        OnDefenseEffect onDefenseEffect;
        ActiveSkill activeSkill;
        Element[] elements; // Một card có thể có nhiều nguyên tố
        MonsterClass[] classes; // Một card có thể có nhiều class
    }

    // Cấu trúc quái vật (Monster)
    struct Monster {
        uint256 id;
        uint256 health;
        uint256 attack;
        Element[] elements; // Quái có nhiều nguyên tố
        MonsterClass[] classes; // Quái có nhiều class
    }
}
