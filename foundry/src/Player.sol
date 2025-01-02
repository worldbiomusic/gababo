// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Hand.sol";

struct Player {
    address addr;
    string message;
    bytes32 hand; // hashed hand
    string key;
    Hand revealedHand;
}
