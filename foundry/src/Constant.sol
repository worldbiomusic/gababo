// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

library Constant {
    uint256 public constant MIN_PLAYTIME = 60 * 5; // 5 minutes
    uint256 public constant MAX_PLAYTIME = 60 * 60; // 60 minutes
    uint256 public constant REVEAL_DEADLINE = 60 * 10; // 10 minutes

    uint256 public constant PLATFORM_FEE = 1; // 1%
    address public constant PLATFORM_WALLET = 0x7e83f74915095a171f9706e1BfEd7dA6F8E821f4;
}
