//
//  Roadout_LockWidget.swift
//  Roadout
//
//  Created by David Retegan on 22.10.2022.
//

import WidgetKit
import SwiftUI

@available(iOS 16.0, *)
struct RoadoutLockEntry: TimelineEntry {
    let date = Date()
    var isReservationActive = false
    var reservationEndDate = Date()
    var reservationParkingName = ""
}

@available(iOS 16.0, *)
struct RoadoutLockProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> RoadoutLockEntry {
         return RoadoutLockEntry(isReservationActive: false)
     }

     func getSnapshot(in context: Context, completion: @escaping (RoadoutLockEntry) -> ()) {
         completion(RoadoutLockEntry(isReservationActive: false))
     }

     func getTimeline(in context: Context, completion: @escaping (Timeline<RoadoutLockEntry>) -> ()) {
         var entry = RoadoutLockEntry()
         //get reservation data
         entry.isReservationActive = false
         
         let timeline = Timeline(entries: [entry], policy: .atEnd)
         completion(timeline)
     }
    
}

@available(iOS 16.0, *)
struct RoadoutLockPlaceholderView: View {
    var body: some View {
        RoadoutLockView(date: Date(), isReservationActive: false, reservationEndDate: Date(), reservationParkingName: "")
    }
}

@available(iOS 16.0, *)
struct RoadoutLockWidgetEntryView: View {
    var entry: RoadoutLockProvider.Entry
    
    var body: some View {
        RoadoutLockView(date: Date(), isReservationActive: entry.isReservationActive, reservationEndDate: entry.reservationEndDate, reservationParkingName: entry.reservationParkingName)
    }
}

@available(iOS 16.0, *)
struct RoadoutLockView: View {
    
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
                AccessoryWidgetBackground()
                Image("complicationCars3")
                  .resizable()
                  .widgetAccentable()
            }
            .widgetLabel("Roadout")
        case .accessoryInline:
            Label {
                Text("Roadout")
            } icon: {
                Image("roadout.car")
                    .resizable()
                    .widgetAccentable()
            }
        case .accessoryRectangular:
            if isReservationActive {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Image("roadout.car")
                          .resizable()
                          .widgetAccentable()
                          .frame(width: 15, height: 12.5)
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
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Image("roadout.car")
                          .resizable()
                          .widgetAccentable()
                          .frame(width: 15, height: 12.5)
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
                Text("Unimplemented")
        }
    }
    
}

@available(iOS 16.0, *)
struct RoadoutLockWidget: Widget {
    private let kind = "Roadout_LockWidget"
    
    var body: some WidgetConfiguration {
        return StaticConfiguration(kind: kind, provider: RoadoutLockProvider()) { entry in
            RoadoutLockWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.accessoryCircular, .accessoryInline, .accessoryRectangular])
        .configurationDisplayName("Roadout")
        .description("Have Roadout at a glance")
    }
}

@available(iOS 16.0, *)
struct RoadoutLockWidgetPreviews: PreviewProvider {
    
    static var previews: some View {
        Group {
            RoadoutLockWidgetEntryView(entry: RoadoutLockEntry())
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
                .previewDisplayName("Accesory Circular")
            RoadoutLockWidgetEntryView(entry: RoadoutLockEntry())
                .previewContext(WidgetPreviewContext(family: .accessoryInline))
                .previewDisplayName("Accesory Inline")
            RoadoutLockWidgetEntryView(entry: RoadoutLockEntry())
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
                .previewDisplayName("Accesory Rectangular")
        }
    }
    
}

