//
//  ComplicationController.swift
//  Roadout for Watch WatchKit Extension
//
//  Created by David Retegan on 06.11.2021.
//

import ClockKit

@available(watchOSApplicationExtension 7.0, *)
class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "reservation.complication", displayName: "Time Left", supportedFamilies: [.graphicCircular, .graphicCorner, .graphicExtraLarge, .graphicBezel, .graphicRectangular, .utilitarianSmall, .modularSmall, .extraLarge, .circularSmall]),
            CLKComplicationDescriptor(identifier: "watched.complication", displayName: "Watch Park", supportedFamilies: [.circularSmall, .extraLarge, .modularSmall, .modularLarge, .utilitarianSmall, .utilitarianSmallFlat, .utilitarianLarge, .graphicBezel, .graphicCorner, .graphicCircular, .graphicRectangular, .graphicExtraLarge]),
            CLKComplicationDescriptor(identifier: "express.complication", displayName: "Express Reserve", supportedFamilies: [.circularSmall, .extraLarge, .modularSmall, .utilitarianSmall, .graphicCorner, .graphicBezel, .graphicCircular])
        ]
        
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
