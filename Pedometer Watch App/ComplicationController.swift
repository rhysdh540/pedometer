//
//  ComplicationController.swift
//  Pedometer Watch App
//
//  Created by Rhys de Haan on 6/14/24.
//

import ClockKit
import HealthKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "Health Data", supportedFamilies: [.modularSmall, .circularSmall, .utilitarianSmall, .extraLarge])
        ]
        handler(descriptors)
    }

    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        switch complication.family {
        case .modularSmall, .circularSmall, .utilitarianSmall, .extraLarge:
            HealthKitManager.shared.fetchTodayData { steps, distance in
                let template = self.createTemplate(for: complication.family, steps: steps, distance: distance)
                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(entry)
            }
        default:
            handler(nil)
        }
    }

    func createTemplate(for family: CLKComplicationFamily, steps: Int, distance: Double) -> CLKComplicationTemplate {
        switch family {
        case .modularSmall:
            return CLKComplicationTemplateModularSmallSimpleText(textProvider: CLKSimpleTextProvider(text: "\(steps) steps"))
        case .circularSmall:
            return CLKComplicationTemplateCircularSmallSimpleText(textProvider: CLKSimpleTextProvider(text: "\(steps)"))
        case .utilitarianSmall:
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: CLKSimpleTextProvider(text: "\(steps) steps"))
        case .extraLarge:
            return CLKComplicationTemplateExtraLargeSimpleText(textProvider: CLKSimpleTextProvider(text: "\(steps) steps"))
        default:
            fatalError("Unsupported complication family.")
        }
    }

    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        handler(nil)
    }

    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }

    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }

    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let template = createTemplate(for: complication.family, steps: 0, distance: 0)
        handler(template)
    }
}
