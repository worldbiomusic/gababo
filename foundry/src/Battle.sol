// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// **functions**
// #### init() private
// - playerRed, playerBlue, bet, playtime, winnerPrize, starttime 초기화
// - setPhase(Phase.WAITING)
// - emit GameInited()

// #### join() payable public
// msg.sender, fee, hand, message 처리

// - 중복참가/2명 초과 이상(error PlayerFulled()) 불가
// - 비어있는 player 가져오기
// - red면 gamePlaytime 경계선검사 후 playtime(경계선 잘못되면 WrongPlaytime(uint256 duration))과 bet 설정/blue이면 bet 동일한지 확인 (크거나 적으면 wrongBet(address player, int256 fee))
// - player객체 만들고(address, hand, message), red or blue 비어있는곳에 address 할당 (꽉 찼으면 PlayerFulled error 반환)
// - 모든 작업이 끝나고, player가 모두 참가하면 -> setPhase(Phase.WAITING)
// - emit PlayerJoined(address player, uint256 fee)

// #### finish() public
// > 게임 종료
// - playtime 지났는지 검사
// - phase =? playing
// - setPhaes(Finished)

// #### modifier onlyPlayers(address player)
// - player가 참가한 players 중 하나인지 검사

// #### payPlatformFee()
// - winnerPrize * 0.01만큼 PLATFORM_WALLET 에게 전송

// #### getPlayer(address player) private returns (Player)
// - player param과 같은 player 변수 반환
// - 없으면 0x0000...

import "./Hand.sol";
import "./Player.sol";
import "./Phase.sol";
import "./Event.sol";
import "./Error.sol";
import "./Constant.sol";

contract Battle {
    Player public playerRed;
    Player public playerBlue;
    uint256 public bet;
    uint256 public winnerPrize;
    uint256 public starttime;
    uint256 public playtime;
    Phase public phase;

    constructor() {
        init();
    }

    // #### init() private
    // - playerRed, playerBlue, bet, playtime, winnerPrize, starttime 초기화
    // - setPhase(Phase.WAITING)
    // - emit GameInited()
    function init() private {
        // init variables
        playerRed = Player(address(0), "", keccak256("gababo"), "", Hand.None);
        playerBlue = Player(address(0), "", keccak256("gababo"), "", Hand.None);
        bet = 0;
        playtime = 0;
        starttime = 0;
        winnerPrize = 0;
        phase = Phase.Waiting;

        // emit event
        emit Event.GameInited();
    }

    // #### join() payable public
    // msg.sender, fee, hand, message 처리

    // - 중복참가/2명 초과 이상(error PlayerFulled()) 불가
    // - 비어있는 player 가져오기
    // - red면 gamePlaytime 경계선검사 후 playtime(경계선 잘못되면 WrongPlaytime(uint256 duration))과 bet 설정/blue이면 bet 동일한지 확인 (크거나 적으면 wrongBet(address player, int256 fee))
    // - player객체 만들고(address, hand, message), red or blue 비어있는곳에 address 할당 (꽉 찼으면 PlayerFulled error 반환)
    // - 모든 작업이 끝나고, player가 모두 참가하면 -> setPhase(Phase.PLAYING)
    // - emit PlayerJoined(address player, uint256 fee)
    function join(bytes32 hand, string message) public payable {
        // check if game already started
        if (phase != Phase.Waiting) {
            revert Error.JoinError("Game already started");
        }

        // check if player already joined
        if (playerRed.addr == msg.sender || playerBlue.addr == msg.sender) {
            revert Error.JoinError("Player already joined");
        }

        // if 2 players are already joined
        if (playerRed.addr != address(0) && playerBlue.addr != address(0)) {
            revert Error.JoinError("Player fulled");
        }

        // check if player is red or blue
        if (playerRed.addr == address(0)) {
            // check if playtime is valid
            require(
                playtime < Constant.MIN_PLAYTIME ||
                    playtime > Constant.MAX_PLAYTIME,
                "Wrong playtime"
            );

            // set playtime and bet
            playtime = playtime;
            bet = msg.value;

            // set playerRed
            playerRed = Player(msg.sender, message, hand, "", Hand.None);
        } else {
            // check if bet is same
            if (bet != msg.value) {
                revert Error.wrongBet(msg.sender, msg.value);
            }

            // set playerBlue
            playerBlue = Player(msg.sender, message, hand, "", Hand.None);
        }

        // emit event
        emit Event.PlayerJoined(msg.sender, msg.value);

        // if both players are joined, set phase to playing
        if (playerRed.addr != address(0) && playerBlue.addr != address(0)) {
            phase = Phase.Playing;
        }
    }

    // #### finish() public
    // > 게임 종료
    // - playtime 지났는지 검사
    // - phase =? playing
    // - setPhaes(Finished)
    function finish() public {
        // check if game is playing
        require(phase == Phase.Playing, "Game is not playing");

        // check if playtime is over
        require(block.timestamp > starttime + playtime, "Playtime is not over");

        // set phase to finished
        phase = Phase.Finished;
    }

    // #### modifier onlyPlayers(address player)
    // - player가 참가한 players 중 하나인지 검사
    modifier onlyPlayers(address player) {
        require(
            player == playerRed.addr || player == playerBlue.addr,
            "Player is not joined"
        );
        _;
    }

    // #### revealHand(Hand hand, bytes key) public onlyPlayers
    // > 비밀키 제출해서 승자 선택 후 상금 배분
    // - phase =? finished
    // - revealed hand가 Hand중에 없다면 에러 WrongRevealKey() 후 종료
    // - 밝혀진 hand를 revealedHand로 설정하기
    // - payPlatformFee() 호출
    // - 2명이 다 하면 init() 먼저 하고(emit GameFinished(address winner): 2명 다 revealHand() 했을 때), winner()에게 상금/2 전송
    // - emit HandRevealed(address player, Hand hand)
    function revealHand(bytes32 hand, bytes key) public onlyPlayers {
        // check if game is finished
        require(phase == Phase.Finished, "Game is not finished");

        Player player = getPlayer(msg.sender);

        // check if hand is revealed
        require(player.key == "", "Hand is already revealed");

        // set key
        player.key = key;

        // reveal hand
        Hand revealedHand = HandUtils.revealHand(hand, key);
        player.revealedHand = revealedHand;

        // emit event
        emit Event.HandRevealed(msg.sender, revealedHand);

        // settle if both players revealed hand
        if (playerRed.key != "" && playerBlue.key != "") {
            settle();
        }
    }

    // 만약 플레이어중 한명이라도 키를 제출하지 않았을 때, settle()을 호출해서 게임을 종료하고 상금을 배분하기
    function settle() public {
        // check if both players revealed hand or REVEAL_DEADLINE is passed
        bool isAllRevealed = playerRed.key != "" && playerBlue.key != "";
        bool isDeadlinePassed = block.timestamp >
            starttime + Constant.REVEAL_DEADLINE;
        if (isAllRevealed || isDeadlinePassed) {
            // pay platform fee
            payPlatformFee();

            // if both players revealed hand

            // get winner
            Player memory winner = HandUtils.winner(playerRed, playerBlue);

            // pay winner
            payable(winner.addr).transfer(winnerPrize / 2);

            // init game
            init();

            // emit event
            emit Event.GameFinished(winner.addr);
        }
    }

    function payPlatformFee() private {}

    function getPlayer(address player) private returns (Player memory) {
        if (player == playerRed.addr) {
            return playerRed;
        } else if (player == playerBlue.addr) {
            return playerBlue;
        } else {
            return Player(address(0), "", bytes32(0), "", Hand.None);
        }
    }
}
