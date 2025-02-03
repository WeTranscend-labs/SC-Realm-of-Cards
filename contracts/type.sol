// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library MonsterLibrary {

    enum Class { METAL, WOOD, WATER, FIRE, EARTH }

    enum OnAttackEffect { NONE, LIFESTEAL, CRITICAL_STRIKE }

    enum OnDeadEffect { NONE, EXPLODE, THORNS, SACRIFICE }

    enum OnDefenseEffect { NONE, THORNS }

    enum ActiveSkill { NONE, SACRIFICE }

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
        Class[] classes; 
    }

    struct Monster {
        uint256 id;
        uint256 health;
        uint256 attack;
        Class[] classes; 
    }
}
