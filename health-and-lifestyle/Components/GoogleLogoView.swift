import SwiftUI

struct GoogleLogoView: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: size, height: size)

            Text("G")
                .font(.system(size: size * 0.6, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 0.26, green: 0.52, blue: 0.96),
                            Color(red: 0.92, green: 0.26, blue: 0.21),
                            Color(red: 0.98, green: 0.74, blue: 0.02),
                            Color(red: 0.21, green: 0.65, blue: 0.33),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }
}
