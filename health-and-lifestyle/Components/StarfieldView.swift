import SwiftUI

struct Star: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let opacity: Double
    let twinkleDuration: Double
}

struct StarfieldView: View {
    let stars: [Star]
    @State private var twinkle = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(stars) { star in
                    Circle()
                        .fill(Color.white)
                        .frame(width: star.size, height: star.size)
                        .position(
                            x: star.x * geo.size.width,
                            y: star.y * geo.size.height
                        )
                        .opacity(twinkle ? star.opacity : star.opacity * 0.3)
                        .animation(
                            Animation
                                .easeInOut(duration: star.twinkleDuration)
                                .repeatForever(autoreverses: true)
                                .delay(star.twinkleDuration * Double.random(in: 0...1)),
                            value: twinkle
                        )
                }
            }
        }
        .onAppear { twinkle = true }
    }
}
