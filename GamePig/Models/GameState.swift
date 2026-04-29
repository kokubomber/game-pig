import Foundation

enum TurnResult {
    case rolled(Int)
    case bust
    case held
    case won(String)
}

@Observable
class GameState {
    var players: [Player] = []
    var currentIndex: Int = 0
    var lastDiceValue: Int? = nil
    var isBust: Bool = false
    var winner: Player? = nil

    var currentPlayer: Player { players[currentIndex] }
    var isGameOver: Bool { winner != nil }

    func setup(playerCount: Int) {
        players = (0..<playerCount).map { i in
            Player(id: i, name: "Player \(i + 1)")
        }
        currentIndex = 0
        lastDiceValue = nil
        isBust = false
        winner = nil
    }

    @discardableResult
    func roll() -> TurnResult {
        guard !isGameOver else { return .held }

        let value = Int.random(in: 1...6)
        lastDiceValue = value
        isBust = false

        if value == 1 {
            isBust = true
            players[currentIndex].bust()
            // ターン移行はUIが confirmBust() を呼ぶまで待つ
            return .bust
        }

        players[currentIndex].addToTurn(value)

        if players[currentIndex].wouldWin {
            winner = players[currentIndex]
            return .won(currentPlayer.name)
        }

        return .rolled(value)
    }

    @discardableResult
    func hold() -> TurnResult {
        guard !isGameOver else { return .held }

        players[currentIndex].hold()

        if players[currentIndex].hasWon {
            winner = players[currentIndex]
            return .won(currentPlayer.name)
        }

        advanceTurn()
        return .held
    }

    func confirmBust() {
        advanceTurn()
    }

    private func advanceTurn() {
        currentIndex = (currentIndex + 1) % players.count
        lastDiceValue = nil
        isBust = false
    }

    func reset() {
        let count = players.count
        setup(playerCount: count)
    }
}
