import SwiftUI

struct GameView: View {
    @Bindable var game: GameState
    var onQuit: () -> Void

    @State private var diceRotation: Double = 0
    @State private var diceScale: Double = 1
    @State private var showBustOverlay: Bool = false
    @State private var isBusting: Bool = false  // ターン移行待ち中フラグ
    @State private var showWinner: Bool = false

    var body: some View {
        ZStack {
            mainContent

            // バースト強調オーバーレイ
            if showBustOverlay {
                bustOverlay
            }

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

    // MARK: バーストオーバーレイ
    private var bustOverlay: some View {
        ZStack {
            Color.red.opacity(0.15)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                DiceView(value: 1, isBust: true)
                    .frame(width: 140, height: 140)
                    .shadow(color: .red.opacity(0.6), radius: 20)

                VStack(spacing: 8) {
                    Text("バースト！")
                        .font(.system(size: 48, weight: .black))
                        .foregroundStyle(.red)

                    Text("ターン得点 +0")
                        .font(.title3)
                        .foregroundStyle(.red.opacity(0.8))
                }
            }
            .transition(.scale(scale: 0.7).combined(with: .opacity))
        }
    }

    // MARK: メイン画面
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
                .opacity(showBustOverlay ? 0 : 1)

            VStack(spacing: 4) {
                Text("ターン得点")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(game.currentPlayer.turnTotal)")
                    .font(.system(size: 48, weight: .black).monospacedDigit())
                    .foregroundStyle(game.currentPlayer.turnTotal > 0 ? Color.accentColor : Color.secondary)
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
                .disabled(game.isGameOver || isBusting)

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
                .disabled(game.currentPlayer.turnTotal == 0 || game.isGameOver || isBusting)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .padding(.top)
    }

    // MARK: アクション
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
            isBusting = true
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                showBustOverlay = true
            }
            // 2秒表示してからターン移行
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.3)) {
                    showBustOverlay = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    game.confirmBust()
                    isBusting = false
                }
            }
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
