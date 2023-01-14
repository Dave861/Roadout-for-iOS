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
            }
            
            
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
            completion(timeline)
        }
    }
    
}

struct RoadoutWidgetPlaceholderView: View {
    var body: some View {
        RoadoutWidgetView(date: Date(), spots1: 10, spots2: 10, freeSpots1: 5, freeSpots2: 5, coords1: "-, -", coords2: "-, -", location1: "Location 1", location2: "Location 2")
    }
}

struct RoadoutWidgetEntryView: View {
    var entry: RoadoutWidgetProvider.Entry
    
    var body: some View {
        RoadoutWidgetView(date: Date(),
                    spots1: entry.configuration.location1?.totalSpots as? Int ?? 0,
                    spots2: entry.configuration.location2?.totalSpots as? Int ?? 0,
                    freeSpots1: entry.configuration.location1?.freeSpots as? Int ?? 0,
                    freeSpots2: entry.configuration.location2?.freeSpots as? Int ?? 0,
                    coords1: entry.configuration.location1?.coords ?? "-, -",
                    coords2: entry.configuration.location2?.coords ?? "-, -",
                    location1: entry.configuration.location1?.locationName ?? "No Location",
                    location2: entry.configuration.location2?.locationName ?? "No Location")
    }
}

struct RoadoutWidgetView: View {
    
    let date: Date
    var spots1: Int
    var spots2: Int
    var freeSpots1: Int
    var freeSpots2: Int
    var coords1: String
    var coords2: String
    var location1: String
    var location2: String

    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            HStack {
                Text(" ")
                VStack(alignment: .leading, spacing: 7) {
                    Image(uiImage: UIImage(named: "YellowThing")!)
                        .resizable()
                        .frame(width: 24.57, height: 21, alignment: .topTrailing)
                    Text(location1)
                        .font(.system(size: 18, weight: .bold))
                    HStack(alignment: .center, spacing: 6) {
                        Image("gauge.fill")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 17, height: 17, alignment: .center)
                            .foregroundColor(Color("AccentColor"))
                        HStack(alignment: .center, spacing: 4) {
                            Text("\(freeSpots1)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                            Text("free spots")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                        }
                    }
                    HStack(alignment: .center, spacing: 3) {
                        Text("")
                        Image(systemName: "mappin")
                            .resizable()
                            .frame(width: 9, height: 22, alignment: .center)
                            .foregroundColor(Color("AccentColor"))
                        HStack(alignment: .center, spacing: 4) {
                            Text(" " + coords1)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "rectangle.portrait")
                            .resizable()
                            .frame(width: 15, height: 18, alignment: .center)
                            .foregroundColor(Color("AccentColor"))
                        HStack(alignment: .center, spacing: 4) {
                            Text("\(spots1)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.gray)
                            Text("spots")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                        }
                    }
                    
                }
            }
            
        case .systemMedium:
            HStack() {
                HStack {
                    Text(" ")
                    VStack(alignment: .leading, spacing: 7) {
                        Spacer()
                        Image(uiImage: UIImage(named: "YellowThing")!)
                            .resizable()
                            .frame(width: 24.57, height: 21, alignment: .topTrailing)
                        Text(location1)
                            .font(.system(size: 18, weight: .bold))
                        HStack(alignment: .center, spacing: 6) {
                            Image("gauge.fill")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 17, height: 17, alignment: .center)
                                .foregroundColor(Color("AccentColor"))
                            HStack(alignment: .center, spacing: 4) {
                                Text("\(freeSpots1)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                Text("free spots")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                        }
                        HStack(alignment: .center, spacing: 3) {
                            Text("")
                            Image(systemName: "mappin")
                                .resizable()
                                .frame(width: 9, height: 22, alignment: .center)
                                .foregroundColor(Color("AccentColor"))
                            HStack(alignment: .center, spacing: 4) {
                                Text(" " + coords1)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "rectangle.portrait")
                                .resizable()
                                .frame(width: 15, height: 18, alignment: .center)
                                .foregroundColor(Color("AccentColor"))
                            HStack(alignment: .center, spacing: 4) {
                                Text("\(spots1)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                Text("spots")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                    }
                }
                .background(Color("WidgetBackground"))
                HStack {
                    Text(" ")
                    VStack(alignment: .leading, spacing: 7) {
                        Spacer()
                        Image(uiImage: UIImage(named: "OrangeThing")!)
                            .resizable()
                            .frame(width: 24.57, height: 21, alignment: .topTrailing)
                        Text(location2)
                            .font(.system(size: 18, weight: .bold))
                        HStack(alignment: .center, spacing: 6) {
                            Image("gauge.fill")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 17, height: 17, alignment: .center)
                                .foregroundColor(Color("Dark Orange"))
                            HStack(alignment: .center, spacing: 4) {
                                Text("\(freeSpots2)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                Text("free spots")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                        }
                        HStack(alignment: .center, spacing: 3) {
                            Text("")
                            Image(systemName: "mappin")
                                .resizable()
                                .frame(width: 9, height: 22, alignment: .center)
                                .foregroundColor(Color("Dark Orange"))
                            HStack(alignment: .center, spacing: 4) {
                                Text(" " + coords2)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "rectangle.portrait")
                                .resizable()
                                .frame(width: 15, height: 18, alignment: .center)
                                .foregroundColor(Color("Dark Orange"))
                            HStack(alignment: .center, spacing: 4) {
                                Text("\(spots2)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                                Text("spots")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                    }
                }
                .background(Color("Secondary Detail"))
            }
        default:
           Text("Unimplemented")
        }
    }
    
}

struct RoadoutWidget: Widget {
    private let kind = "Roadout_Widget"
    
    var body: some WidgetConfiguration {
        return IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: RoadoutWidgetProvider()) { entry in
            RoadoutWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Roadout")
        .description("Your favourite parking at a glance".widgetLocalize())
    }
}
