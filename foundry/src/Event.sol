// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Hand.sol";

contract Event {
    event GameInited();
    event PlayerJoined(address player, uint256 fee);
    event betChanged(uint256 fee);
    event HandChanged(address player);
    event MessageChanged(string message);
    event HandRevealed(address player, Hand hand);
    event GameFinished(address winner);
}
