import Foundation
import FirebaseFirestore
internal import Combine

final class SolarProgressViewModel: ObservableObject {
    @Published private(set) var highestUnlockedPlanetIndex: Int = 0

    private var userId: String?
    private var cancellables = Set<AnyCancellable>()
    private let db = Firestore.firestore()

    func reset() {
        cancellables.removeAll()
        userId = nil
        highestUnlockedPlanetIndex = 0
    }

    /// Loads Firestore value first, then subscribes to step updates so unlock never regresses before load completes.
    func configure(userId: String, healthViewModel: HealthViewModel) {
        cancellables.removeAll()
        self.userId = userId

        db.collection("users").document(userId).getDocument { [weak self] snapshot, _ in
            guard let self else { return }
            let fromFirestore = Self.indexFromSnapshot(snapshot)
            DispatchQueue.main.async {
                self.highestUnlockedPlanetIndex = fromFirestore
                self.applyStepsMerge(healthViewModel.stepCount)

                healthViewModel.$stepCount
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] steps in
                        self?.applyStepsMerge(steps)
                    }
                    .store(in: &self.cancellables)
            }
        }
    }

    private static func indexFromSnapshot(_ snapshot: DocumentSnapshot?) -> Int {
        guard let value = snapshot?.data()?["highestUnlockedPlanetIndex"] as? Int else { return 0 }
        return min(max(value, 0), PlanetProgression.lastPlanetIndex)
    }

    private func applyStepsMerge(_ steps: Double) {
        guard let userId else { return }
        let fromToday = PlanetProgression.highestPlanetIndexUnlocked(forTodaySteps: steps)
        let merged = max(highestUnlockedPlanetIndex, fromToday)
        guard merged > highestUnlockedPlanetIndex else { return }
        highestUnlockedPlanetIndex = merged
        db.collection("users").document(userId).setData(
            ["highestUnlockedPlanetIndex": merged],
            merge: true
        )
    }
}
