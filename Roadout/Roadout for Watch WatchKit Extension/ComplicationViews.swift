//
//  ComplicationViews.swift
//  Roadout for Watch WatchKit Extension
//
//  Created by David Retegan on 14.06.2022.
//

import SwiftUI
import UIKit
import ClockKit

struct ComplicationViewCircular: View {
    
  var body: some View {
    ZStack {
      Image(uiImage: UIImage(named: "complicationCars3")!)
            .resizable()
            .complicationForeground()
        
    }
    .background(Color(uiColor: UIColor(named: "Main Yellow")!.withAlphaComponent(0.5))) .complicationForeground()
  }
    
}

struct ComplicationViewCornerCircular: View {
    
  var body: some View {
    ZStack {
        Circle()
            .foregroundColor(Color(uiColor: UIColor(named: "Main Yellow")!.withAlphaComponent(0.5)))
            .complicationForeground()
        Image(uiImage: UIImage(named: "complicationCar1")!)
              .resizable()
              .complicationForeground()
    }
    
  }
    
}



struct ComplicationViews_Previews: PreviewProvider {
    static var previews: some View {
        Group {
         
            CLKComplicationTemplateGraphicCircularView(
                ComplicationViewCircular()
            ).previewContext()
            
            CLKComplicationTemplateGraphicCornerTextView(textProvider: CLKSimpleTextProvider(text: "Roadout"), label: ComplicationViewCornerCircular()
            ).previewContext()
            
        }
    }
}
extension ComplicationController {
  func makeTemplate(complication: CLKComplication) -> CLKComplicationTemplate? {
    switch complication.family {
        case .graphicCircular:
          return CLKComplicationTemplateGraphicCircularView(
            ComplicationViewCircular())
        case .graphicCorner:
            return CLKComplicationTemplateGraphicCornerTextView(textProvider: CLKSimpleTextProvider(text: "Roadout"), label: ComplicationViewCornerCircular())
        case .graphicExtraLarge:
            return CLKComplicationTemplateGraphicExtraLargeCircularView(ComplicationViewCircular())
        case .graphicBezel:
            return CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: CLKComplicationTemplateGraphicCircularView(
                ComplicationViewCircular()), textProvider: CLKSimpleTextProvider(text: "Roadout"))
        case .utilitarianLarge:
            return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: CLKSimpleTextProvider(text: "Roadout"), imageProvider: CLKImageProvider(onePieceImage: UIImage(named: "complicationCars3")!))
        default:
          return nil
    }
  }
}
