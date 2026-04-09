import SwiftUI

struct SolarSystemProgressView: View {
    @EnvironmentObject private var solarViewModel: SolarProgressViewModel
    @EnvironmentObject private var healthViewModel: HealthViewModel

    private let planetColors: [Color] = [
        Color(red: 0.75, green: 0.75, blue: 0.72),
        Color(red: 0.95, green: 0.82, blue: 0.45),
        Color(red: 0.25, green: 0.55, blue: 0.85),
        Color(red: 0.85, green: 0.35, blue: 0.2),
        Color(red: 0.9, green: 0.75, blue: 0.55),
        Color(red: 0.95, green: 0.88, blue: 0.65),
        Color(red: 0.55, green: 0.8, blue: 0.95),
        Color(red: 0.3, green: 0.45, blue: 0.95),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Solar system")
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)

            Text(subtitleText)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.55))

            TabView {
                ForEach(0 ..< PlanetProgression.planetCount, id: \.self) { index in
                    planetPage(index: index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 240)
        }
    }

    private var subtitleText: String {
        let unlocked = solarViewModel.highestUnlockedPlanetIndex + 1
        if let need = PlanetProgression.stepsRequiredForNextPlanet(afterHighest: solarViewModel.highestUnlockedPlanetIndex) {
            let steps = Int(healthViewModel.stepCount)
            let remaining = max(0, Int(need) - steps)
            return "Planet \(unlocked) of \(PlanetProgression.planetCount) unlocked - \(remaining) steps today to reach the next world"
        }
        return "You’ve unlocked every planet. Keep moving!"
    }

    private func planetPage(index: Int) -> some View {
        let unlocked = index <= solarViewModel.highestUnlockedPlanetIndex
        let name = PlanetProgression.planetNames[index]
        let threshold = Int(PlanetProgression.stepThresholds[index])

        return VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                planetColors[index].opacity(unlocked ? 1 : 0.35),
                                planetColors[index].opacity(unlocked ? 0.4 : 0.15),
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 70
                        )
                    )
                    .frame(width: 120, height: 120)
                    .overlay {
                        Circle()
                            .stroke(.white.opacity(unlocked ? 0.35 : 0.12), lineWidth: 2)
                    }

                if !unlocked {
                    Image(systemName: "lock.fill")
                        .font(.title)
                        .foregroundStyle(.white.opacity(0.5))
                }
            }

            Text(name)
                .font(.title2.weight(.bold))
                .foregroundStyle(.white.opacity(unlocked ? 1 : 0.45))

            Text(unlocked ? "Unlocked" : "\(threshold.formatted()) steps today to unlock")
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

#Preview {
    ZStack {
        Color(red: 0.05, green: 0.06, blue: 0.14).ignoresSafeArea()
        SolarSystemProgressView()
            .environmentObject(SolarProgressViewModel())
            .environmentObject(HealthViewModel())
            .padding()
    }
}
