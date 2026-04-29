import SwiftUI

struct GameView: View {
    @Bindable var game: GameState
    var onQuit: () -> Void

    @State private var diceRotation: Double = 0
    @State private var diceScale: Double = 1
    @State private var bustOpacity: Double = 0
    @State private var showWinner: Bool = false

    var body: some View {
        ZStack {
            mainContent

            if showWinner, let winner = game.winner {
                WinnerView(name: winner.name, score: winner.score) {
                    showWinner = false
                    game.reset()
                } onQuit: {
                    onQuit()
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showWinner)
    }

    private var mainContent: some View {
        VStack(spacing: 20) {
            HStack {
                Text("🐷 PIG")
                    .font(.title2.bold())
                Spacer()
                Button("終了") { onQuit() }
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)

            ScoreboardView(players: game.players, currentIndex: game.currentIndex)
                .padding(.horizontal)

            Spacer()

            VStack(spacing: 8) {
                Text(game.currentPlayer.name)
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Text("のターン")
                    .font(.callout)
                    .foregroundStyle(.tertiary)
            }

            DiceView(value: game.lastDiceValue, isBust: game.isBust)
                .frame(width: 120, height: 120)
                .rotationEffect(.degrees(diceRotation))
                .scaleEffect(diceScale)

            if game.isBust {
                Text("バースト！")
                    .font(.title2.bold())
                    .foregroundStyle(.red)
                    .opacity(bustOpacity)
            }

            VStack(spacing: 4) {
                Text("ターン得点")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(game.currentPlayer.turnTotal)")
                    .font(.system(size: 48, weight: .black).monospacedDigit())
                    .foregroundStyle(game.currentPlayer.turnTotal > 0 ? .accentColor : .secondary)
            }

            Spacer()

            HStack(spacing: 20) {
                Button {
                    rollDice()
                } label: {
                    Label("ROLL", systemImage: "dice.fill")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(game.isGameOver)

                Button {
                    holdDice()
                } label: {
                    Label("HOLD", systemImage: "hand.raised.fill")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(game.currentPlayer.turnTotal == 0 || game.isGameOver)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .padding(.top)
    }

    private func rollDice() {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
            diceRotation += Double.random(in: 180...360)
            diceScale = 1.15
        }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6).delay(0.15)) {
            diceScale = 1
        }

        let result = game.roll()

        if case .bust = result {
            withAnimation(.easeIn(duration: 0.1)) { bustOpacity = 1 }
            withAnimation(.easeOut(duration: 0.6).delay(1.0)) { bustOpacity = 0 }
        } else if case .won = result {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showWinner = true
            }
        }
    }

    private func holdDice() {
        let result = game.hold()
        if case .won = result {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showWinner = true
            }
        }
    }
}
