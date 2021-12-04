//
//  ComplicationController.swift
//  Roadout for Watch WatchKit Extension
//
//  Created by David Retegan on 06.11.2021.
//

/*import ClockKit

@available(watchOSApplicationExtension 7.0, *)
class ComplicationController: NSObject, CLKComplicationDataSource {
        
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "reservation.complication", displayName: "Time Left", supportedFamilies: [.graphicCircular, .graphicCorner, .graphicExtraLarge, .graphicBezel, .graphicRectangular, .utilitarianSmall, .modularSmall, .extraLarge, .circularSmall]),
            CLKComplicationDescriptor(identifier: "watched.complication", displayName: "Watch Park", supportedFamilies: [.circularSmall, .extraLarge, .modularSmall, .modularLarge, .utilitarianSmall, .utilitarianSmallFlat, .utilitarianLarge, .graphicBezel, .graphicCorner, .graphicCircular, .graphicRectangular, .graphicExtraLarge])
        ]
        
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date())
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(Date(timeIntervalSinceNow: 24*3600))
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        if let template = getComplicationTemplate(for: complication, using: Date()) {
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
         } else {
            handler(nil)
         }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        handler(nil)
    }
    
    func getComplicationTemplate(for complication: CLKComplication, using date: Date) -> CLKComplicationTemplate? {
            switch complication.family {
                case .graphicCorner:
                    return createGraphicCornerTemplate(with: complication.identifier)
                case .graphicRectangular:
                    return createGraphicRectangularTemplate(with: complication.identifier)
                case .modularLarge:
                    return createModularLargeTemplate(with: complication.identifier)
                case .graphicCircular:
                    return createGraphicCircular(with: complication.identifier)
                case .circularSmall:
                    return createCircularSmall(with: complication.identifier)
                case .graphicBezel:
                    return createGraphicBezel(with: complication.identifier)
                case .graphicExtraLarge:
                    return createGraphicExtraLarge(with: complication.identifier)
                case .modularSmall:
                    return createModularCircle(with: complication.identifier)
                case .utilitarianSmall:
                    return createUtilitarianSmall(with: complication.identifier)
                case .extraLarge:
                    return createExtraLarge(with: complication.identifier)
                case .utilitarianSmallFlat:
                    return createUtilitarianSmallFlat(with: complication.identifier)
                case .utilitarianLarge:
                    return createUtilitarianLarge(with: complication.identifier)
                default:
                    return nil
            }
        }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let template = getComplicationTemplate(for: complication, using: Date())
            if let t = template {
                handler(t)
            } else {
                handler(nil)
            }
    }
    
    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let template = getComplicationTemplate(for: complication, using: Date())
            if let t = template {
                handler(t)
            } else {
                handler(nil)
        }
    }
    
    func createGraphicCornerTemplate(with id: String) -> CLKComplicationTemplate? {
        print(id)
        if id == "reservation.complication" {
            let percentage = [56.6, 34.3, 87.2, 25.1].randomElement()
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor(named: "AccentColor")!, fillFraction: Float(percentage!))
            let imgProv = CLKFullColorImageProvider(fullColorImage: UIImage(named: "Complication/Graphic Corner")!)
            let txt = CLKSimpleTextProvider(text: "6:23")
            let template = CLKComplicationTemplateGraphicCornerGaugeImage(gaugeProvider: gaugeProvider, leadingTextProvider: nil, trailingTextProvider: txt, imageProvider: imgProv)
            return template
        } else {
            let txt = CLKSimpleTextProvider(text: "27")
            let txt2 = CLKSimpleTextProvider(text: "Free Spots")
            let template = CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: txt2, outerTextProvider: txt)
            return template
        }
    }
    
    func createGraphicRectangularTemplate(with id: String) -> CLKComplicationTemplate? {
       
    }
    
    func createModularLargeTemplate(with id: String) -> CLKComplicationTemplate? {
        
    }
    
    func createModularCircle(with id: String) -> CLKComplicationTemplate? {
        
    }
    
    func createGraphicCircular(with id: String) -> CLKComplicationTemplate? {
        
    }
    
    func createCircularSmall(with id: String) -> CLKComplicationTemplate? {
        
    }
    
    func createGraphicBezel(with id: String) -> CLKComplicationTemplate? {
        
    }
    
    func createGraphicExtraLarge(with id: String) -> CLKComplicationTemplate? {
        
    }
    func createUtilitarianSmall(with id: String) -> CLKComplicationTemplate? {
        
    }
    
    func createExtraLarge(with id: String) -> CLKComplicationTemplate? {
        
    }
    
    func createUtilitarianSmallFlat(with id: String) -> CLKComplicationTemplate? {
        
    }
    
    func createUtilitarianLarge(with id: String) -> CLKComplicationTemplate? {
        
    }
}
*/
