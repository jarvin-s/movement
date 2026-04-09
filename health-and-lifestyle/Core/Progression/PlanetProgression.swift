import Foundation

enum PlanetProgression {
    static let planetCount = 8
    static let lastPlanetIndex = planetCount - 1

    static let stepThresholds: [Double] = [0, 1_500, 3_000, 5_000, 7_500, 10_000, 12_500, 15_000]

    static let planetNames: [String] = [
        "Mercury", "Venus", "Earth", "Mars",
        "Jupiter", "Saturn", "Uranus", "Neptune",
    ]

    static func highestPlanetIndexUnlocked(forTodaySteps steps: Double) -> Int {
        var result = 0
        for i in 0 ... lastPlanetIndex where steps >= stepThresholds[i] {
            result = i
        }
        return result
    }

    static func stepsRequiredForNextPlanet(afterHighest currentHighest: Int) -> Double? {
        let next = currentHighest + 1
        guard next < stepThresholds.count else { return nil }
        return stepThresholds[next]
    }
}
