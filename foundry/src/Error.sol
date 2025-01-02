// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Error {
    error wrongBet(address player, int256 fee);
    error WrongPlaytime(uint256 playtime);
    error WrongRevealKey();
    error JoinError(string message);
}