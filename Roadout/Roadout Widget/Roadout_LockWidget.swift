//
//  Roadout_LockWidget.swift
//  Roadout
//
//  Created by David Retegan on 22.10.2022.
//
import Alamofire
import WidgetKit
import SwiftUI

@available(iOS 16.0, *)
struct RoadoutLockEntry: TimelineEntry {
    let date = Date()
}

@available(iOS 16.0, *)
struct RoadoutLockProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> RoadoutLockEntry {
         return RoadoutLockEntry()
     }

     func getSnapshot(in context: Context, completion: @escaping (RoadoutLockEntry) -> ()) {
         completion(RoadoutLockEntry())
     }
    
     func getTimeline(in context: Context, completion: @escaping (Timeline<RoadoutLockEntry>) -> ()) {
         var entry = RoadoutLockEntry()
         let timeline = Timeline(entries: [entry], policy: .never)
         completion(timeline)
     }
}

@available(iOS 16.0, *)
struct RoadoutLockPlaceholderView: View {
    var body: some View {
        RoadoutLockView(date: Date())
    }
}

@available(iOS 16.0, *)
struct RoadoutLockWidgetEntryView: View {
    var entry: RoadoutLockProvider.Entry
    
    var body: some View {
        RoadoutLockView(date: Date())
    }
}

@available(iOS 16.0, *)
struct RoadoutLockView: View {
    
    let date: Date

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
        .supportedFamilies([.accessoryCircular, .accessoryInline])
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
        }
    }
    
}

