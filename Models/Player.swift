import Foundation

struct Player: Identifiable {
    let id: Int
    let name: String
    var score: Int = 0
    var turnTotal: Int = 0

    var remaining: Int { max(0, 50 - score) }

    mutating func hold() {
        score += turnTotal
        turnTotal = 0
    }

    mutating func bust() {
        turnTotal = 0
    }

    mutating func addToTurn(_ value: Int) {
        turnTotal += value
    }

    var hasWon: Bool { score >= 50 }
    var wouldWin: Bool { score + turnTotal >= 50 }
}
