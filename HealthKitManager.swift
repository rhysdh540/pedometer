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

    func fetchHealthData(completion: @escaping ([HealthData]) -> Void) {
        var healthDataArray: [HealthData] = []
        
        let now = Date()
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now))!
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year, .weekday], from: now)
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)!

        let interval = DateComponents(day: 1)
        
        let stepsQuery = HKStatisticsCollectionQuery(quantityType: stepType,
                                                     quantitySamplePredicate: nil,
                                                     options: .cumulativeSum,
                                                     anchorDate: anchorDate,
                                                     intervalComponents: interval)
        
        let distanceQuery = HKStatisticsCollectionQuery(quantityType: distanceType,
                                                        quantitySamplePredicate: nil,
                                                        options: .cumulativeSum,
                                                        anchorDate: anchorDate,
                                                        intervalComponents: interval)
        
        stepsQuery.initialResultsHandler = { query, results, error in
            results?.enumerateStatistics(from: startDate, to: now) { statistics, stop in
                let stepCount = statistics.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
                let date = statistics.startDate
                healthDataArray.append(HealthData(date: date, steps: Int(stepCount), distance: 0))
            }
            completion(healthDataArray)
        }

        distanceQuery.initialResultsHandler = { query, results, error in
            results?.enumerateStatistics(from: startDate, to: now) { statistics, stop in
                let distance = statistics.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
                if let index = healthDataArray.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: statistics.startDate) }) {
                    healthDataArray[index].distance = distance
                }
            }
            completion(healthDataArray)
        }
        
        healthStore.execute(stepsQuery)
        healthStore.execute(distanceQuery)
    }

    func fetchTodayData(completion: @escaping (Int, Double) -> Void) {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let stepsQuery = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            let steps = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
            completion(Int(steps), 0)
        }

        let distanceQuery = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            let distance = result?.sumQuantity()?.doubleValue(for: HKUnit.meter()) ?? 0
            completion(0, distance)
        }

        healthStore.execute(stepsQuery)
        healthStore.execute(distanceQuery)
    }
}

struct HealthData {
    let date: Date
    var steps: Int
    var distance: Double
}
