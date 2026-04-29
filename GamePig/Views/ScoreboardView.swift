import SwiftUI

struct PlayerRowView: View {
    let player: Player
    let isCurrent: Bool

    var body: some View {
        HStack {
            Text(isCurrent ? "▶" : "　")
                .foregroundStyle(Color.accentColor)
                .frame(width: 20)

            Text(player.name)
                .fontWeight(isCurrent ? .bold : .regular)

            Spacer()

            Text("\(player.score) pt")
                .fontWeight(isCurrent ? .bold : .regular)
                .monospacedDigit()

            Text("(残 \(player.remaining))")
                .font(.caption)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(
            isCurrent
                ? Color.accentColor.opacity(0.1)
                : Color.clear
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ScoreboardView: View {
    let players: [Player]
    let currentIndex: Int

    var body: some View {
        VStack(spacing: 8) {
            ForEach(players) { player in
                PlayerRowView(player: player, isCurrent: player.id == players[currentIndex].id)
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
