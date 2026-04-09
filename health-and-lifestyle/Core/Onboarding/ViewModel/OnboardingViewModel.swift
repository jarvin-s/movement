import Foundation
internal import Combine

final class OnboardingViewModel: ObservableObject {
    private static let completedKey = "hasCompletedOnboarding"

    @Published private(set) var hasCompletedOnboarding: Bool

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.hasCompletedOnboarding = defaults.bool(forKey: Self.completedKey)
    }

    func completeOnboarding() {
        defaults.set(true, forKey: Self.completedKey)
        hasCompletedOnboarding = true
    }
}
