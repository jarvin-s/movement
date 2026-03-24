import HealthKit

class HealthStore {
    let healthStore = HKHealthStore()
    private var observerQuery: HKObserverQuery?
    
    func requestAuthorization(completion: @escaping(Bool, Error?)-> Void) {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        
        let typesToRead: Set = [stepCountType, heartRateType, calorieType]
        
        healthStore.requestAuthorization(toShare: [], read: typesToRead) {
            succes, error in
            completion(succes, error)
        }
    }
    
    func fetchStepCount(completion: @escaping(Double)-> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) {
            _, result, _ in
            let stepCount = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            DispatchQueue.main.async {
                completion(stepCount)
            }
        }
        
        healthStore.execute(query)
    }

    func fetchLatestHeartRateToday(completion: @escaping (Double?) -> Void) {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: [sort]) { _, samples, _ in
            guard let sample = samples?.first as? HKQuantitySample else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            let bpm = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
            DispatchQueue.main.async { completion(bpm) }
        }
        healthStore.execute(query)
    }

    func fetchActiveEnergyBurnedToday(completion: @escaping (Double) -> Void) {
        let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let kcal = result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
            DispatchQueue.main.async { completion(kcal) }
        }
        healthStore.execute(query)
    }

    func startObservingSteps(onChange: @escaping () -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        observerQuery = HKObserverQuery(sampleType: stepType, predicate: nil) { _, completionHandler, error in
            if error == nil {
                onChange()
            }
            completionHandler()
        }
        
        healthStore.execute(observerQuery!)
    }
    
    func stopObservingSteps() {
        if let query = observerQuery {
            healthStore.stop(query)
            observerQuery = nil
        }
    }
}
