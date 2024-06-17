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
        StaticConfiguration(kind: kind, provider: StepCountProvider()) { entry in
            DataDisplayView(data: "\(entry.data)\nSteps")
        }
        .configurationDisplayName("Step Count Widget")
        .description("Shows your current step count.")
    }
}

struct DistanceWidget: Widget {
    let kind: String = "DistanceWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DistanceProvider()) { entry in
            DataDisplayView(data: String(format: "%.2f km", entry.data as! Double / 1000.0))
        }
        .configurationDisplayName("Distance Widget")
        .description("Shows your current distance moved.")
    }
}
