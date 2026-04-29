import SwiftUI

struct DiceView: View {
    let value: Int?
    let isBust: Bool

    private let dotPositions: [Int: [(x: CGFloat, y: CGFloat)]] = [
        1: [(0.5, 0.5)],
        2: [(0.25, 0.25), (0.75, 0.75)],
        3: [(0.25, 0.25), (0.5, 0.5), (0.75, 0.75)],
        4: [(0.25, 0.25), (0.75, 0.25), (0.25, 0.75), (0.75, 0.75)],
        5: [(0.25, 0.25), (0.75, 0.25), (0.5, 0.5), (0.25, 0.75), (0.75, 0.75)],
        6: [(0.25, 0.2), (0.75, 0.2), (0.25, 0.5), (0.75, 0.5), (0.25, 0.8), (0.75, 0.8)]
    ]

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let dotSize = size * 0.14

            ZStack {
                RoundedRectangle(cornerRadius: size * 0.16)
                    .fill(isBust ? Color.red.opacity(0.15) : Color.white)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

                RoundedRectangle(cornerRadius: size * 0.16)
                    .strokeBorder(isBust ? Color.red : Color.gray.opacity(0.3), lineWidth: 2)

                if let v = value, let positions = dotPositions[v] {
                    ForEach(positions.indices, id: \.self) { i in
                        let pos = positions[i]
                        Circle()
                            .fill(isBust ? Color.red : Color.black.opacity(0.85))
                            .frame(width: dotSize, height: dotSize)
                            .offset(
                                x: (pos.x - 0.5) * size * 0.7,
                                y: (pos.y - 0.5) * size * 0.7
                            )
                    }
                } else {
                    Text("?")
                        .font(.system(size: size * 0.35, weight: .bold))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    HStack(spacing: 16) {
        ForEach(1...6, id: \.self) { v in
            DiceView(value: v, isBust: v == 1)
                .frame(width: 80)
        }
    }
    .padding()
}
