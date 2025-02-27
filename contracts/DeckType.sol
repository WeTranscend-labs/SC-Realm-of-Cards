// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./DeckType.sol";

library DeckResponse {
    struct CardWithId {
        uint256 id;        
        DeckType.Card card;      
    }

    struct MonsterWithId {
        uint256 id;           
        DeckType.Monster monster; 
    }

    struct PrebuiltDeckWithId {
        uint256 id;                  
        DeckType.PrebuiltDeck deck; 
    }

    struct PaginatedCardsWithId {
        CardWithId[] cardsPage;    
        uint256 totalPages;        
        uint256 totalElements;     
    }

    struct PaginatedMonstersWithId {
        MonsterWithId[] monstersPage; 
        uint256 totalPages;        
        uint256 totalElements;      
    }
}
