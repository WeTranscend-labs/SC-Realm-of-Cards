// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./DeckType.sol";

library DeckResponse {
    struct PaginatedCards {
        DeckType.Card[] cardsPage;
        uint256 totalPages;
        uint256 totalElements;
    }
}
