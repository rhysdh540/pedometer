//
//  PedometerWidgetProviders.swift
//  Pedometer Watch ComplicationsExtension
//
//  Created by Rhys de Haan on 6/17/24.
//

import WidgetKit


class HealthDataProvider<T>: TimelineProvider {
    private let dataType: KeyPath<HealthData, T>
    private let placeholderValue: T

    init(dataType: KeyPath<HealthData, T>, placeholderValue: T) {
        self.dataType = dataType
        self.placeholderValue = placeholderValue
    }

    func placeholder(in context: Context) -> DatedEntry<T> {
        DatedEntry(date: Date(), data: placeholderValue)
    }

    func getSnapshot(in context: Context, completion: @escaping (DatedEntry<T>) -> Void) {
        let entry = DatedEntry(date: Date(), data: placeholderValue)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DatedEntry<T>>) -> Void) {
        HealthKitManager.shared.fetchHealthData(for: Date()) { healthData in
            let entry = DatedEntry(date: Date(), data: healthData[keyPath: self.dataType])
            let nextUpdate = Calendar.current.date(byAdding: .second, value: 30, to: Date())!
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
}

struct DatedEntry<T>: TimelineEntry {
    let date: Date
    var data: T
}
