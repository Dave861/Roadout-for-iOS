//
//  Roadout_Widget.swift
//  Roadout Widget
//
//  Created by David Retegan on 24.12.2021.
//

import WidgetKit
import SwiftUI
import Intents
import Alamofire

struct RoadoutWidgetEntry: TimelineEntry {
    let date = Date()
    let configuration: ConfigurationIntent
}

struct RoadoutWidgetProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> RoadoutWidgetEntry {
        return Entry(configuration: ConfigurationIntent())
    }
    
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (RoadoutWidgetEntry) -> ()) {
        completion(Entry(configuration: configuration))
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<RoadoutWidgetEntry>) -> ()) {
        Task {
            let entry = Entry(configuration: configuration)
            
            let _headers : HTTPHeaders = ["Content-Type":"application/json"]
            let params1 : Parameters = ["id":entry.configuration.location1?.rID ?? ""]
            let params2 : Parameters = ["id":entry.configuration.location2?.rID ?? ""]
            
            let downloadRequest1 = AF.request("https://\(roadoutServerURL)/Parking/GetFreeParkingSpots.php", method: .post, parameters: params1, encoding: JSONEncoding.default, headers: _headers)
            let downloadRequest2 = AF.request("https://\(roadoutServerURL)/Parking/GetFreeParkingSpots.php", method: .post, parameters: params2, encoding: JSONEncoding.default, headers: _headers)
            
            
            var responseJson1: String!
            do {
                responseJson1 = try await downloadRequest1.serializingString().value
            } catch let err {
                print(err)
            }
            let data1 = responseJson1.data(using: .utf8)!
            var jsonArray1: [String:Any]!
            do {
                jsonArray1 = try JSONSerialization.jsonObject(with: data1, options : .allowFragments) as? [String:Any]
            } catch let err {
                print(err)
            }
            
            if jsonArray1["status"] as! String == "Success" {
                entry.configuration.location1?.freeSpots = Int(jsonArray1["result"] as! String) as NSNumber?
                entry.configuration.location1?.occupancyColor = self.makeAccentColor(freeSpots: entry.configuration.location1?.freeSpots ?? 1, totalSpots: entry.configuration.location1?.totalSpots ?? 1)
            }
            
            
            
            var responseJson2: String!
            do {
                responseJson2 = try await downloadRequest2.serializingString().value
            } catch let err {
                print(err)
            }
            let data2 = responseJson2.data(using: .utf8)!
            var jsonArray2: [String:Any]!
            do {
                jsonArray2 = try JSONSerialization.jsonObject(with: data2, options : .allowFragments) as? [String:Any]
            } catch let err {
                print(err)
            }
            
            if jsonArray2["status"] as! String == "Success" {
                entry.configuration.location2?.freeSpots = Int(jsonArray2["result"] as! String) as NSNumber?
                entry.configuration.location2?.occupancyColor = self.makeAccentColor(freeSpots: entry.configuration.location2?.freeSpots ?? 1, totalSpots: entry.configuration.location2?.totalSpots ?? 1)
            }
            
            
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(5400)))
            completion(timeline)
        }
    }
    
    func makeAccentColor(freeSpots: NSNumber, totalSpots: NSNumber) -> String {
        let percentage = 100-(Double(truncating: freeSpots)/Double(truncating: totalSpots))*100
        if percentage >= 90 {
            return "Kinda Red"
        } else if percentage >= 80 {
            return "Dark Orange"
        } else if percentage >= 60 {
            return "Second Orange"
        } else if percentage >= 50 {
            return "Icons"
        } else {
            return "Main Yellow"
        }
    }
    
}

struct RoadoutWidgetPlaceholderView: View {
    var body: some View {
        RoadoutWidgetView(date: Date())
    }
}

struct RoadoutWidgetEntryView: View {
    var entry: RoadoutWidgetProvider.Entry
    
    var body: some View {
        RoadoutWidgetView(date: Date(),
                          location1: entry.configuration.location1,
                          location2: entry.configuration.location2)
    }
}

struct RoadoutWidgetView: View {
    
    let date: Date
    var location1: WidgetParkLocation?
    var location2: WidgetParkLocation?

    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
                VStack(alignment: .leading, spacing: 7) {
                    Image("Marker_" + (location1?.occupancyColor ?? "Main Yellow"))
                        .resizable()
                        .frame(width: 23.24, height: 34, alignment: .topTrailing)
                        .padding(.leading, 2)
                    Text(location1?.locationName ?? "Location Name")
                        .font(.system(size: 18, weight: .bold))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    HStack(alignment: .center, spacing: 6) {
                        Image(systemName: "rectangle.portrait")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 14, height: 19, alignment: .center)
                            .foregroundColor(Color(location1?.occupancyColor ?? "Main Yellow"))
                        Text("\(location1?.freeSpots ?? 0) free spots")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 3)
                    HStack(alignment: .center, spacing: 5) {
                        Image(systemName: "clock.fill")
                            .resizable()
                            .frame(width: 17, height: 17, alignment: .center)
                            .foregroundColor(Color(location1?.occupancyColor ?? "Main Yellow"))
                        HStack(alignment: .center, spacing: 4) {
                            Text("at")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                            Text(date, style: .time)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.leading, 2)
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.top, 14)
                .padding(.trailing, 4)
            
        case .systemMedium:
            HStack {
                VStack(alignment: .leading, spacing: 7) {
                    Image("Marker_" + (location1?.occupancyColor ?? "Main Yellow"))
                        .resizable()
                        .frame(width: 23.24, height: 34, alignment: .topTrailing)
                        .padding(.leading, 2)
                    Text(location1?.locationName ?? "Location Name")
                        .font(.system(size: 18, weight: .bold))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    HStack(alignment: .center, spacing: 6) {
                        Image(systemName: "rectangle.portrait")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 14, height: 19, alignment: .center)
                            .foregroundColor(Color(location1?.occupancyColor ?? "Main Yellow"))
                        Text("\(location1?.freeSpots ?? 0) free spots")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 3)
                    HStack(alignment: .center, spacing: 5) {
                        Image(systemName: "clock.fill")
                            .resizable()
                            .frame(width: 17, height: 17, alignment: .center)
                            .foregroundColor(Color(location1?.occupancyColor ?? "Main Yellow"))
                        HStack(alignment: .center, spacing: 4) {
                            Text("at")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                            Text(date, style: .time)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.leading, 2)
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.top, 14)
                .background(Color("WidgetBackground"))
                VStack(alignment: .leading, spacing: 7) {
                    Image("Marker_" + (location2?.occupancyColor ?? "Main Yellow"))
                        .resizable()
                        .frame(width: 23.24, height: 34, alignment: .topTrailing)
                        .padding(.leading, 2)
                    Text(location2?.locationName ?? "Location Name")
                        .font(.system(size: 18, weight: .bold))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    HStack(alignment: .center, spacing: 6) {
                        Image(systemName: "rectangle.portrait")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 14, height: 19, alignment: .center)
                            .foregroundColor(Color(location2?.occupancyColor ?? "Main Yellow"))
                        Text("\(location2?.freeSpots ?? 0) free spots")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 3)
                    HStack(alignment: .center, spacing: 5) {
                        Image(systemName: "clock.fill")
                            .resizable()
                            .frame(width: 17, height: 17, alignment: .center)
                            .foregroundColor(Color(location2?.occupancyColor ?? "Main Yellow"))
                        HStack(alignment: .center, spacing: 4) {
                            Text("at")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                            Text(date, style: .time)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.leading, 2)
                    Spacer()
                }
                .padding(.leading, 10)
                .padding(.top, 14)
                .padding(.trailing, 4)
                .background(Color("Secondary Detail"))
            }
        default:
            if #available(iOS 16.0, *) {
                if family == .accessoryRectangular {
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
                        Text(location1?.locationName ?? "Location Name")
                            .font(.body.bold())
                        Text("\(location1?.freeSpots ?? 0) free spots")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("Unimplemented")
                }
            } else {
                Text("Unimplemented")
            }
        }
    }
    
}

struct RoadoutWidget: Widget {
    private let kind = "Roadout_Widget"
    
    var body: some WidgetConfiguration {
        if #available(iOSApplicationExtension 16.0, *) {
            return IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: RoadoutWidgetProvider()) { entry in
                RoadoutWidgetEntryView(entry: entry)
            }
            .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular])
            .configurationDisplayName("Roadout")
            .description("Your Favourite Parking at a Glance".widgetLocalize())
        } else {
            return IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: RoadoutWidgetProvider()) { entry in
                RoadoutWidgetEntryView(entry: entry)
            }
            .supportedFamilies([.systemSmall, .systemMedium])
            .configurationDisplayName("Roadout")
            .description("Your Favourite Parking at a Glance".widgetLocalize())
        }
    }
}
/**
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
 */
