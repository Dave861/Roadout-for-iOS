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
        
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params1 : Parameters = ["id":entry.configuration.location1?.rID ?? ""]
        let params2 : Parameters = ["id":entry.configuration.location2?.rID ?? ""]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Parking/GetFreeParkingSpots.php", method: .post, parameters: params1, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    if jsonArray["status"] as! String == "Success" {
                        entry.configuration.location1?.freeSpots = Int(jsonArray["result"] as! String) as NSNumber?
                    }
                }
            } catch let error as NSError {
                print(error)

            }
        }
        
        Alamofire.Session.default.request("https://www.roadout.ro/Parking/GetFreeParkingSpots.php", method: .post, parameters: params2, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    if jsonArray["status"] as! String == "Success" {
                        entry.configuration.location2?.freeSpots = Int(jsonArray["result"] as! String) as NSNumber?
                    }
                }
            } catch let error as NSError {
                print(error)

            }
        }
        
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
}

struct PlaceholderView: View {
    var body: some View {
        RoadoutView(date: Date(), spots1: 10, spots2: 10, freeSpots1: 5, freeSpots2: 5, coords1: "-, -", coords2: "-, -", location1: "Location 1", location2: "Location 2")
    }
}
struct WidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        RoadoutView(date: Date(),
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

struct RoadoutView: View {
    
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
                        Image(systemName: "barometer")
                            .resizable()
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
                            Image(systemName: "barometer")
                                .resizable()
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
                            Image(systemName: "barometer")
                                .resizable()
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
           if #available(iOS 16, *) {
                if family == .accessoryCircular {
                    ZStack {
                      Image("ThreeThing")
                            .resizable()
                        
                    }
                    .background(Color(uiColor: UIColor(named: "AccentColor")!.withAlphaComponent(0.4)))
                }
            } else {
                VStack(alignment: .leading, spacing: 30) {
                    
                }
                .frame(width: 200, alignment: .leading)
            }
        }
    }
    
}
@main
struct RoadoutWidget: Widget {
    private let kind = "Roadout_Widget"
    
    var body: some WidgetConfiguration {
        if #available(iOSApplicationExtension 16.0, *) {
            return IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
                WidgetEntryView(entry: entry)
            }
            .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular])
            .configurationDisplayName("Roadout")
            .description("Have Roadout at a glance".widgetLocalize())
        } else {
            return IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
                WidgetEntryView(entry: entry)
            }
            .supportedFamilies([.systemSmall, .systemMedium])
            .configurationDisplayName("Roadout")
            .description("Have Roadout at a glance".widgetLocalize())
        }
    }
}
