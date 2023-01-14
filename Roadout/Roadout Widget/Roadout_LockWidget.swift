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
    var isReservationActive = false
    var reservationEndDate = ""
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
         Task {
             var entry = RoadoutLockEntry()
             
             if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.isUserSigned") {
                 let _headers: HTTPHeaders = ["Content-Type":"application/json"]
                 let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                 let convertedDate = dateFormatter.string(from: Date())
                 let params: Parameters = ["date": convertedDate, "userID": UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String]
                 
                 let checkRequest = AF.request("https://\(roadoutServerURL)/Authentification/CheckEndDate.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
                 
                 var responseJson: String!
                 do {
                     responseJson = try await checkRequest.serializingString().value
                 } catch {
                     entry.isReservationActive = false
                     let timeline = Timeline(entries: [entry], policy: .atEnd)
                     completion(timeline)
                 }
                 
                 let data = responseJson.data(using: .utf8)!
                 var jsonArray: [String:Any]!
                 do {
                     jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
                 } catch {
                     entry.isReservationActive = false
                     let timeline = Timeline(entries: [entry], policy: .atEnd)
                     completion(timeline)
                 }
                 
                 if jsonArray["status"] as! String == "Success" && jsonArray["message"] as! String == "active" {
                     entry.isReservationActive = true
                     entry.reservationParkingName = EntityManager.sharedInstance.decodeSpotID(jsonArray["spotID"] as! String)[0]
                     
                     let formattedEndDate = jsonArray["endDate"] as! String
                     let convertedEndDate = dateFormatter.date(from: formattedEndDate)
                     dateFormatter.dateFormat = "HH:mm"
                     entry.reservationEndDate = dateFormatter.string(from: convertedEndDate!)
                     
                     let timeline = Timeline(entries: [entry], policy: .after(convertedEndDate!.addingTimeInterval(15)))
                     completion(timeline)
                 } else {
                     entry.isReservationActive = false
                     let timeline = Timeline(entries: [entry], policy: .atEnd)
                     completion(timeline)
                 }
             } else {
                 entry.isReservationActive = false
                 let timeline = Timeline(entries: [entry], policy: .atEnd)
                 completion(timeline)
             }
         }
     }
}

@available(iOS 16.0, *)
struct RoadoutLockPlaceholderView: View {
    var body: some View {
        RoadoutLockView(date: Date(), isReservationActive: false, reservationEndDate: "", reservationParkingName: "")
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
    var reservationEndDate: String
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
                    + Text(reservationEndDate)
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

