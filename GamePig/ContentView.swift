import SwiftUI

struct ContentView: View {
    @State private var game = GameState()
    @State private var isPlaying = false

    var body: some View {
        if isPlaying {
            GameView(game: game) {
                isPlaying = false
            }
        } else {
            PlayerSetupView { count in
                game.setup(playerCount: count)
                isPlaying = true
            }
        }
    }
}

#Preview {
    ContentView()
}
