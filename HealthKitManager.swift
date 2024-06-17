//
//  HealthKitManager.swift
//  Pedometer
//
//  Created by Rhys de Haan on 6/14/24.
//

import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()
    let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!

    private let userDefaults = UserDefaults.standard
    private let healthKitAuthKey = "RDHPedometerHKAuthStatus"

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        healthStore.requestAuthorization(toShare: nil, read: [stepType, distanceType]) { success, error in
            if success {
                self.userDefaults.set(true, forKey: self.healthKitAuthKey)
            }
            completion(success)
        }
    }
    
    func isAuthorized() -> Bool {
        return userDefaults.bool(forKey: healthKitAuthKey)
    }

    func fetchHealthData(for date: Date, completion: @escaping (HealthData) -> Void) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        
        let stepsQuery = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            let steps = Int(result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0)
            
            let distanceQuery = HKStatisticsQuery(quantityType: self.distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                let distance = result?.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
                completion(HealthData(date: startOfDay, steps: steps, distance: distance))
            }
            
            self.healthStore.execute(distanceQuery)
        }

        healthStore.execute(stepsQuery)
    }

    func fetchHealthDataRange(startDate: Date, endDate: Date, completion: @escaping ([HealthData]) -> Void) {
        var currentDate = startDate
        var healthDataArray: [HealthData] = []

        let dispatchGroup = DispatchGroup()

        while currentDate <= endDate {
            dispatchGroup.enter()
            fetchHealthData(for: currentDate) { healthData in
                healthDataArray.append(healthData)
                dispatchGroup.leave()
            }
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }

        dispatchGroup.notify(queue: .main) {
            completion(healthDataArray)
        }
    }
}

struct HealthData {
    let date: Date
    var steps: Int
    var distance: Double // in meters
}
