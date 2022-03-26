//
//  ComplicationManager.swift
//  Roadout Watch WatchKit Extension
//
//  Created by David Retegan on 31.12.2021.
//

import Foundation
import ClockKit

class ComplicationManager {
    
    static let sharedInstance = ComplicationManager()
   
    //MARK: -Graphic
    
    func makeGraphicCornerComplication(_ date: Date) -> CLKComplicationTemplateGraphicCornerStackText {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let bigTextProvider = CLKSimpleTextProvider(text: dateFormatter.string(from: date))
        let smallTextProvider = CLKSimpleTextProvider(text: "Reservation".watchLocalize())
        smallTextProvider.tintColor = UIColor(named: "Main Yellow")!
        
        return CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: smallTextProvider, outerTextProvider: bigTextProvider)
    }
    
    func makeGraphicCircularComplication(_ date: Date) -> CLKComplicationTemplateGraphicCircularStackText {
        let line1TextProvider = CLKSimpleTextProvider(text: "RES.".watchLocalize())
        line1TextProvider.tintColor = UIColor(named: "Main Yellow")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let line2TextProvider = CLKSimpleTextProvider(text: dateFormatter.string(from: date))
        
        return CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: line1TextProvider, line2TextProvider: line2TextProvider)
    }
    
    func makeGraphicBezelComplication(_ date: Date) -> CLKComplicationTemplateGraphicBezelCircularText {
        let textProvider = CLKSimpleTextProvider(text: "Roadout")
        
        return CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: makeGraphicCircularComplication(date), textProvider: textProvider)
    }
    
    func makeGraphicRectangularComplication(_ date: Date) -> CLKComplicationTemplateGraphicRectangularStandardBody {
        let headerTextProvider = CLKSimpleTextProvider(text: "Reservation".watchLocalize())
        headerTextProvider.tintColor = UIColor(named: "Main Yellow")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let body1TextProvider = CLKSimpleTextProvider(text: dateFormatter.string(from: date))
        let body2TextProvider = CLKSimpleTextProvider(text: "Roadout")
        
        return CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: headerTextProvider, body1TextProvider: body1TextProvider, body2TextProvider: body2TextProvider)
    }
    
    //MARK: -Utilitarian
    
    func makeUtilitarianLargeComplication(_ date: Date) -> CLKComplicationTemplateUtilitarianLargeFlat {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let textProvider = CLKSimpleTextProvider(text: dateFormatter.string(from: date) + " RESERVATION".watchLocalize())
        
        return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: textProvider)
    }
    
    func makeUtilitarianSmallFlatComplication(_ date: Date) -> CLKComplicationTemplateUtilitarianSmallFlat {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let textProvider = CLKSimpleTextProvider(text: "RES. ".watchLocalize() + dateFormatter.string(from: date))
        
        return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider)
    }
    
    //MARK: -Modular
    
    func makeModularSmallComplication(_ date: Date) -> CLKComplicationTemplateModularSmallStackText {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let textProvider1 = CLKSimpleTextProvider(text: dateFormatter.string(from: date))
        let textProvider2 = CLKSimpleTextProvider(text: "RES.".watchLocalize())
        textProvider2.tintColor = UIColor(named: "Main Yellow")!
        
        return CLKComplicationTemplateModularSmallStackText(line1TextProvider: textProvider1, line2TextProvider: textProvider2)
    }
    
    func makeModularLargeComplication(_ date: Date) -> CLKComplicationTemplateModularLargeStandardBody {
        let headerTextProvider = CLKSimpleTextProvider(text: "Reservation".watchLocalize())
        headerTextProvider.tintColor = UIColor(named: "Main Yellow")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let body1TextProvider = CLKSimpleTextProvider(text: dateFormatter.string(from: date))
        let body2TextProvider = CLKSimpleTextProvider(text: "Roadout")
        
        return CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: headerTextProvider, body1TextProvider: body1TextProvider, body2TextProvider: body2TextProvider)
    }
    
    //MARK: -Circular
    
    func makeCircularSmallComplication(_ date: Date) -> CLKComplicationTemplateCircularSmallStackText {
        let line1TextProvider = CLKSimpleTextProvider(text: "RES.".watchLocalize())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let line2TextProvider = CLKSimpleTextProvider(text: dateFormatter.string(from: date))
        
        let template = CLKComplicationTemplateCircularSmallStackText(line1TextProvider: line1TextProvider, line2TextProvider: line2TextProvider)
        template.tintColor = UIColor(named: "Main Yellow")!
        
        return template
    }
    
    //MARK: -XL
    
    func makeExtraLargeComplication(_ date: Date) -> CLKComplicationTemplateExtraLargeStackText {
        let line1TextProvider = CLKSimpleTextProvider(text: "RES.".watchLocalize())
        line1TextProvider.tintColor = UIColor(named: "Main Yellow")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let line2TextProvider = CLKSimpleTextProvider(text: dateFormatter.string(from: date))
        
        return CLKComplicationTemplateExtraLargeStackText(line1TextProvider: line1TextProvider, line2TextProvider: line2TextProvider)
    }
    
    func makeGraphicExtraLargeComplication(_ date: Date) -> CLKComplicationTemplateGraphicExtraLargeCircularStackText {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let textProvider1 = CLKSimpleTextProvider(text: dateFormatter.string(from: date))
        let textProvider2 = CLKSimpleTextProvider(text: "RES.".watchLocalize())
        textProvider2.tintColor = UIColor(named: "Main Yellow")!
        
        return CLKComplicationTemplateGraphicExtraLargeCircularStackText(line1TextProvider: textProvider2, line2TextProvider: textProvider1)
    }
    
}
