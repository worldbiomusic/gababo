// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Player.sol";

enum Hand {
    None, // 0
    Rock, // 1
    Paper, // 2
    Scissors // 3
}

library HandUtils {
    

    function revealHand(bytes32 hand, string memory key) public pure returns (Hand) {
        // "ROCK", "PAPER", "SCISSORS"을 각각 key와 합쳐서 hash한 값이 hand와 같은지 확인
        // 같으면 해당 hand를 반환, 아니면 None 반환
        string[3] memory hands = ["ROCK", "PAPER", "SCISSORS"];
        for (uint i = 0; i < hands.length; i++) {
            bytes32 hashedHand = keccak256(abi.encodePacked(hands[i], key));
            if (hand == hashedHand) {
                return Hand(i + 1);
            }
        }
        return Hand.None;
    }

    // #### winner() public pure returns (Player)
    // - 2명의 revealedHand 계산해서 winner 가져오기
    // - Hand 비교 winner return (Hand null이면 반대 승자, 둘다 null이면 둘에게 다시 되돌려주기)
    function winner(
        Player memory playerRed,
        Player memory playerBlue
    ) public pure returns (Player memory) {
        Hand redHand = playerRed.revealedHand;
        Hand blueHand = playerBlue.revealedHand;

        // if hands are the same, return null (draw)
        if (redHand == blueHand) {
            return Player(address(0), "", bytes32(0), "", Hand.None);
        }

        // if one of the hands is not revealed, return the other player
        if (redHand == Hand.None) {
            return playerBlue;
        }
        if (blueHand == Hand.None) {
            return playerRed;
        }

        // compare hands
        if (redHand == Hand.Rock) {
            return blueHand == Hand.Scissors ? playerRed : playerBlue;
        }
        if (redHand == Hand.Paper) {
            return blueHand == Hand.Rock ? playerRed : playerBlue;
        }
        if (redHand == Hand.Scissors) {
            return blueHand == Hand.Paper ? playerRed : playerBlue;
        }
    }
}
