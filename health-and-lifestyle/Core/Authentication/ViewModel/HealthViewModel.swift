internal import Combine
import Foundation

class HealthViewModel: ObservableObject {
    @Published var stepCount: Double = 0
    
    private let healthStore = HealthStore()
    
    func requestAccessAndStartObserving() {
        healthStore.requestAuthorization { [weak self] success, error in
            if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
                return
            }
            
            self?.fetchLatestSteps()
            self?.healthStore.startObservingSteps { [weak self] in
                self?.fetchLatestSteps()
            }
        }
    }
    
    func stopObserving() {
        healthStore.stopObservingSteps()
    }
    
    private func fetchLatestSteps() {
        healthStore.fetchStepCount { [weak self] steps in
            self?.stepCount = steps
        }
    }
}
