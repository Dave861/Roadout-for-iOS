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
        RoadoutView(date: Date(), spots1: 10, spots2: 10, location1: "Location 1", location2: "Location 2")
    }
}
struct WidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        RoadoutView(date: Date(), spots1: entry.configuration.location1?.freeSpots as? Int ?? 999, spots2: entry.configuration.location2?.freeSpots as? Int ?? 999, location1: entry.configuration.location1?.locationName ?? "Not Found", location2: entry.configuration.location2?.locationName ?? "Not Found")
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
                    Text("Free Spots".widgetLocalize())
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
                                .frame(width: 36.0, height: 30.0)
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
                        Text("Free Spots".widgetLocalize())
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
                                    .frame(width: 36.0, height: 30.0)
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
                        Text("Free Spots".widgetLocalize())
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
                                    .frame(width: 36.0, height: 30.0)
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
        .description("See in real-time free spots at certain locations right on your homescreen".widgetLocalize())
    }
}
