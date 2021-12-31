//
//  ComplicationController.swift
//  Roadout Watch WatchKit Extension
//
//  Created by David Retegan on 11.12.2021.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "Roadout Reservation", supportedFamilies: CLKComplicationFamily.allCases)
        ]
        
        handler(descriptors)
    }
    
    // MARK: - Timeline Configuration
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(.distantFuture)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        let template = returnTemplate(complication)
        let entry = CLKComplicationTimelineEntry(date: Date().addingTimeInterval(600), complicationTemplate: template)
        handler(entry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        let template = returnTemplate(complication)
        let entry = CLKComplicationTimelineEntry(date: Date().addingTimeInterval(600), complicationTemplate: template)
        handler([entry])
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        handler(returnTemplate(complication))
    }
}

    func returnTemplate(_ complication: CLKComplication) -> CLKComplicationTemplate {
        switch complication.family {
            case .graphicCorner:
                return ComplicationManager.sharedInstance.makeGraphicCornerComplication(Date().addingTimeInterval(600))
            case .graphicCircular:
                return ComplicationManager.sharedInstance.makeGraphicCircularComplication(Date().addingTimeInterval(600))
            case .graphicBezel:
                return ComplicationManager.sharedInstance.makeGraphicBezelComplication(Date().addingTimeInterval(600))
            case .graphicRectangular:
                return ComplicationManager.sharedInstance.makeGraphicRectangularComplication(Date().addingTimeInterval(600))
            case .graphicExtraLarge:
                return ComplicationManager.sharedInstance.makeGraphicExtraLargeComplication(Date().addingTimeInterval(600))
            case .utilitarianSmall:
                return ComplicationManager.sharedInstance.makeUtilitarianSmallFlatComplication(Date().addingTimeInterval(600))
            case .utilitarianLarge:
                return ComplicationManager.sharedInstance.makeUtilitarianLargeComplication(Date().addingTimeInterval(600))
            case .utilitarianSmallFlat:
                return ComplicationManager.sharedInstance.makeUtilitarianSmallFlatComplication(Date().addingTimeInterval(600))
            case .modularSmall:
                return ComplicationManager.sharedInstance.makeModularSmallComplication(Date().addingTimeInterval(600))
            case .modularLarge:
                return ComplicationManager.sharedInstance.makeModularLargeComplication(Date().addingTimeInterval(600))
            case .extraLarge:
                return ComplicationManager.sharedInstance.makeExtraLargeComplication(Date().addingTimeInterval(600))
            case .circularSmall:
                return ComplicationManager.sharedInstance.makeCircularSmallComplication(Date().addingTimeInterval(600))
            @unknown default:
                fatalError()
        }
    }
