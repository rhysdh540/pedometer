//
//  PedometerWidgets.swift
//  Pedometer Watch ComplicationsExtension
//
//  Created by Rhys de Haan on 6/17/24.
//

import WidgetKit
import SwiftUI

@main
struct StepAndDistanceWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        StepCountWidget()
        DistanceWidget()
    }
}

struct StepCountWidget: Widget {
    let kind: String = "StepCountWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HealthDataProvider(dataType: \.steps, placeholderValue: 0)) { entry in
            DataDisplayView(data: "\(entry.data)\nSteps")
        }
        .configurationDisplayName("Step Count")
        .description("Shows the number of steps you've taken today.")
    }
}

struct DistanceWidget: Widget {
    let kind: String = "DistanceWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HealthDataProvider(dataType: \.distance, placeholderValue: 0.0)) { entry in
            DataDisplayView(data: String(format: "%.2f km", entry.data / 1000.0))
        }
        .configurationDisplayName("Distance Traveled")
        .description("Shows how far you've moved today.")
    }
}
