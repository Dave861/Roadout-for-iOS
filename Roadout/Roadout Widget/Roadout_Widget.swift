//
//  Roadout_Widget.swift
//  Roadout Widget
//
//  Created by David Retegan on 24.12.2021.
//

import WidgetKit
import SwiftUI
import Intents

struct RoadoutEntry: TimelineEntry {
    let date = Date()
    let configuration: ConfigurationIntent
}

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> RoadoutEntry {
        return Entry(configuration: ConfigurationIntent())
    }
    
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (RoadoutEntry) -> ()) {
        completion(Entry(configuration: configuration))
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = Entry(configuration: configuration)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
}

struct PlaceholderView: View {
    var body: some View {
        RoadoutView(date: Date(), spots1: 10, spots2: 10, location1: "Location", location2: "Location")
    }
}
struct WidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        RoadoutView(date: Date(), spots1: parkLocations[entry.configuration.location1.rawValue-1].freeSpots, spots2: parkLocations[entry.configuration.location2.rawValue-1].freeSpots, location1: parkLocations[entry.configuration.location1.rawValue-1].name, location2: parkLocations[entry.configuration.location2.rawValue-1].name)
    }
}

struct RoadoutView: View {
    
    let date: Date
    var spots1: Int
    var spots2: Int
    var location1: String
    var location2: String

    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            HStack {
                VStack(alignment: .leading) {
                    Text("\(spots1)")
                        .fontWeight(.medium)
                        .font(.system(size: 33))
                        .foregroundColor(Color("AccentColor"))
                        .multilineTextAlignment(.leading)
                        .padding(.top, 14.0)
                        .padding(.leading, 10.0)
                    Text("Free Spots")
                        .fontWeight(.medium)
                        .font(.system(size: 15))
                        .foregroundColor(Color("AccentColor"))
                        .padding(.leading, 12.0)
                    Text(location1)
                        .fontWeight(.semibold)
                        .font(.system(size: 16))
                        .padding(EdgeInsets(top: -4.0, leading: 12.0, bottom: 0.0, trailing: 0.0))
                    Spacer()
                    ZStack(alignment: .bottomTrailing) {
                        HStack() {
                            Spacer()
                            Image("YellowThing")
                                .resizable()
                                .frame(width: 31.0, height: 36.0)
                        }
                    }
                    .padding([.leading, .bottom], 10.0)
                }
                Spacer()
            }
             
        case .systemMedium:
            HStack() {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(spots1)")
                            .fontWeight(.medium)
                            .font(.system(size: 35))
                            .foregroundColor(Color("AccentColor"))
                            .multilineTextAlignment(.leading)
                            .padding(.top, 14.0)
                            .padding(.leading, 10.0)
                        Text("Free Spots")
                            .fontWeight(.medium)
                            .font(.system(size: 15))
                            .foregroundColor(Color("AccentColor"))
                            .padding(.leading, 12.0)
                        Text(location1)
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .padding(EdgeInsets(top: -4.0, leading: 12.0, bottom: 0.0, trailing: 0.0))
                        Spacer()
                        ZStack(alignment: .bottomTrailing) {
                            HStack() {
                                Spacer()
                                Image("YellowThing")
                                    .resizable()
                                    .frame(width: 31.0, height: 36.0)
                            }
                        }
                        .padding([.leading, .bottom], 10.0)
                    }
                    Spacer()
                }
                .background(Color("WidgetBackground"))
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(spots2)")
                            .fontWeight(.medium)
                            .font(.system(size: 35))
                            .foregroundColor(Color("Dark Orange"))
                            .multilineTextAlignment(.leading)
                            .padding(EdgeInsets(top: 16.0, leading: 8.0, bottom: 0.0, trailing: 0.0))
                        Text("Free Spots")
                            .fontWeight(.medium)
                            .font(.system(size: 15))
                            .foregroundColor(Color("Dark Orange"))
                            .padding(.leading, 10.0)
                        Text(location2)
                            .fontWeight(.semibold)
                            .font(.system(size: 16))
                            .padding(EdgeInsets(top: -4.0, leading: 10.0, bottom: 0.0, trailing: 0.0))
                        Spacer()
                        ZStack(alignment: .bottomTrailing) {
                            HStack() {
                                Spacer()
                                Image("OrangeThing")
                                    .resizable()
                                    .frame(width: 31.0, height: 39.0)
                            }
                        }
                        .padding([.leading, .bottom], 12.0)
                    }
                    Spacer()
                }
                .background(Color("Secondary Detail"))
            }
        default:
            VStack(alignment: .leading, spacing: 30) {
    
            }
            .frame(width: 200, alignment: .leading)
        }
    }
    
}
@main
struct RoadoutWidget: Widget {
    private let kind = "Roadout_Widget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Roadout")
        .description("See in real-time free spots at certain locations right on your homescreen")
    }
}