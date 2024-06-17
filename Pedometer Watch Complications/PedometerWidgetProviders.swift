//
//  PedometerWidgetProviders.swift
//  Pedometer Watch ComplicationsExtension
//
//  Created by Rhys de Haan on 6/17/24.
//

import WidgetKit

struct StepCountProvider: TimelineProvider {
    func placeholder(in context: Context) -> DatedEntry {
        DatedEntry(date: Date(), data: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (DatedEntry) -> Void) {
        let entry = DatedEntry(date: Date(), data: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        HealthKitManager.shared.fetchHealthData(for: Date()) { healthData in
            let entry = DatedEntry(date: Date(), data: healthData.steps)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct DistanceProvider: TimelineProvider {
    func placeholder(in context: Context) -> DatedEntry {
        DatedEntry(date: Date(), data: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (DatedEntry) -> Void) {
        let entry = DatedEntry(date: Date(), data: 0)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        HealthKitManager.shared.fetchHealthData(for: Date()) { healthData in
            let entry = DatedEntry(date: Date(), data: healthData.distance)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct DatedEntry: TimelineEntry {
    let date: Date
    var data: Any
}
