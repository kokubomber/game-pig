import SwiftUI

struct WinnerView: View {
    let name: String
    let score: Int
    var onPlayAgain: () -> Void
    var onQuit: () -> Void

    @State private var confettiScale: CGFloat = 0.5
    @State private var confettiOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Text("🎉")
                    .font(.system(size: 80))
                    .scaleEffect(confettiScale)

                VStack(spacing: 8) {
                    Text(name)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)

                    Text("の勝利！")
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.8))

                    Text("\(score) ポイント")
                        .font(.title3)
                        .foregroundStyle(.yellow)
                }

                VStack(spacing: 12) {
                    Button {
                        onPlayAgain()
                    } label: {
                        Text("もう一度プレイ")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Button {
                        onQuit()
                    } label: {
                        Text("タイトルへ")
                            .font(.body)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                .padding(.horizontal, 32)
            }
            .padding(32)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
            .padding(.horizontal, 24)
            .opacity(confettiOpacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                confettiScale = 1
                confettiOpacity = 1
            }
        }
    }
}
