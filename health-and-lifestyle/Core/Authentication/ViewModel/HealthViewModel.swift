internal import Combine
import Foundation

class HealthViewModel: ObservableObject {
    @Published var stepCount: Double = 0
    @Published var latestHeartRateBPM: Double?
    @Published var activeEnergyKilocalories: Double = 0

    private let healthStore = HealthStore()

    func requestAccessAndStartObserving() {
        healthStore.requestAuthorization { [weak self] _, error in
            if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
                return
            }

            self?.refreshHealthKitMetrics()
            self?.healthStore.startObservingSteps { [weak self] in
                self?.refreshHealthKitMetrics()
            }
        }
    }

    func stopObserving() {
        healthStore.stopObservingSteps()
    }

    private func refreshHealthKitMetrics() {
        healthStore.fetchStepCount { [weak self] steps in
            self?.stepCount = steps
        }
        healthStore.fetchLatestHeartRateToday { [weak self] bpm in
            self?.latestHeartRateBPM = bpm
        }
        healthStore.fetchActiveEnergyBurnedToday { [weak self] kcal in
            self?.activeEnergyKilocalories = kcal
        }
    }
}
