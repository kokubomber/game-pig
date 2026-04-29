import SwiftUI

struct PlayerSetupView: View {
    @State private var playerCount: Int = 2
    var onStart: (Int) -> Void

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            Text("🐷 PIG")
                .font(.system(size: 72, weight: .black))

            Text("サイコロゲーム")
                .font(.title2)
                .foregroundStyle(.secondary)

            VStack(spacing: 16) {
                Text("プレイヤー人数")
                    .font(.headline)

                HStack(spacing: 12) {
                    ForEach(2...6, id: \.self) { count in
                        Button {
                            playerCount = count
                        } label: {
                            Text("\(count)")
                                .font(.title2.bold())
                                .frame(width: 52, height: 52)
                                .background(
                                    playerCount == count
                                        ? Color.accentColor
                                        : Color.secondary.opacity(0.2)
                                )
                                .foregroundStyle(playerCount == count ? .white : .primary)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))

            Button {
                onStart(playerCount)
            } label: {
                Text("ゲーム開始")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 32)

            Spacer()
        }
    }
}

#Preview {
    PlayerSetupView(onStart: { _ in })
}
