//
//  Roadout_Complication.swift
//  Roadout Complication
//
//  Created by David Retegan on 26.10.2022.
//

import WidgetKit
import SwiftUI

struct RoadoutComplicationEntry: TimelineEntry {
    let date = Date()
    var isReservationActive = false
    var reservationEndDate = Date()
    var reservationParkingName = ""
}

struct RoadoutComplicationProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> RoadoutComplicationEntry {
         return RoadoutComplicationEntry(isReservationActive: false)
     }


     func getSnapshot(in context: Context, completion: @escaping (RoadoutComplicationEntry) -> ()) {
         completion(RoadoutComplicationEntry(isReservationActive: false))
     }

     func getTimeline(in context: Context, completion: @escaping (Timeline<RoadoutComplicationEntry>) -> ()) {
         var entry = RoadoutComplicationEntry()
         //get reservation data
         entry.isReservationActive = false
         
         let timeline = Timeline(entries: [entry], policy: .atEnd)
         completion(timeline)
     }
    
}

struct RoadoutComplicationPlaceholderView: View {
    var body: some View {
        RoadoutComplicationView(date: Date(), isReservationActive: false, reservationEndDate: Date(), reservationParkingName: "")
    }
}
struct RoadoutComplicationEntryView: View {
    var entry: RoadoutComplicationProvider.Entry
    
    var body: some View {
        RoadoutComplicationView(date: Date(), isReservationActive: entry.isReservationActive, reservationEndDate: entry.reservationEndDate, reservationParkingName: entry.reservationParkingName)
    }
}

struct RoadoutComplicationView: View {
    
    let date: Date
    var isReservationActive: Bool
    var reservationEndDate: Date
    var reservationParkingName: String

    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                Image("complicationCars3")
                  .resizable()
                  .widgetAccentable()
                AccessoryWidgetBackground()
            }
            .widgetLabel("Roadout")
        case .accessoryCorner:
            ZStack {
                Image("complicationCars2")
                  .resizable()
                  .widgetAccentable()
                AccessoryWidgetBackground()
            }
            .widgetLabel("Roadout")
        case .accessoryInline:
            Image("complicationCar1")
              .resizable()
              .widgetAccentable()
              .widgetLabel("Roadout Parking")
        case .accessoryRectangular:
            if isReservationActive {
                VStack(alignment: .leading) {
                    HStack {
                        Image("complicationLargeCar1")
                          .resizable()
                          .widgetAccentable()
                          .frame(width: 15, height: 15)
                        Text("Roadout")
                            .font(.headline)
                            .foregroundColor(Color("Main Yellow"))
                            .widgetAccentable()
                    }
                    Text("Reserved for ")
                        .font(.body.bold())
                    + Text(reservationEndDate, style: .time)
                        .font(.body.bold())
                    Text(reservationParkingName)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        Image("complicationLargeCar1")
                          .resizable()
                          .widgetAccentable()
                          .frame(width: 15, height: 15)
                        Text("Roadout")
                            .font(.headline)
                            .foregroundColor(Color("Main Yellow"))
                            .widgetAccentable()
                    }
                    Text("No Reservation")
                        .font(.body.bold())
                    Text("Tap to open")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        default:
                VStack(alignment: .leading, spacing: 30) {
                    
                }
                .frame(width: 200, alignment: .leading)
        }
    }
    
}
@main
struct RoadoutComplication: Widget {
    private let kind = "Roadout_Complication"
    
    var body: some WidgetConfiguration {
        return StaticConfiguration(kind: kind, provider: RoadoutComplicationProvider()) { entry in
            RoadoutComplicationEntryView(entry: entry)
        }
        .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryInline, .accessoryRectangular])
        .configurationDisplayName("Roadout")
        .description("Have Roadout at a glance")
    }
}

struct RoadoutWidgetPreviews: PreviewProvider {
    
    static var previews: some View {
        Group {
            RoadoutComplicationEntryView(entry: RoadoutComplicationEntry())
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
                .previewDisplayName("Accesory Circular")
            RoadoutComplicationEntryView(entry: RoadoutComplicationEntry())
                .previewContext(WidgetPreviewContext(family: .accessoryCorner))
                .previewDisplayName("Accesory Corner")
            RoadoutComplicationEntryView(entry: RoadoutComplicationEntry())
                .previewContext(WidgetPreviewContext(family: .accessoryInline))
                .previewDisplayName("Accesory Inline")
            RoadoutComplicationEntryView(entry: RoadoutComplicationEntry())
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
                .previewDisplayName("Accesory Rectangular")
        }
    }
    
}
