//
//  NotificationHelper.swift
//  Roadout
//
//  Created by David Retegan on 03.11.2021.
//

import Foundation
import CoreLocation
import GeohashKit
import UserNotifications

#if canImport(ActivityKit)
import ActivityKit
#endif

class NotificationHelper {
    
    static let sharedInstance = NotificationHelper()
    let center = UNUserNotificationCenter.current()
    let UserDefaultsSuite = UserDefaults.init(suiteName: "group.ro.roadout.Roadout")!
    var areNotificationsAllowed: Bool?
    
  //MARK: - Authorization -
    
    func manageNotifications() {
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                print("Notifications are authorized")
            } else {
                self.askNotificationPermission(currentNotification: "")
            }
        }
    }
    
    func checkNotificationStatus() {
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .denied {
                self.areNotificationsAllowed = false
            } else {
                self.areNotificationsAllowed = true
            }
        }
    }
    
    func askNotificationPermission(currentNotification: String, futureReservation: FutureReservation? = nil) {
        if #available(iOS 15.0, *) {
            center.requestAuthorization(options: [.alert, .sound, .timeSensitive]) { granted, error in
                if granted {
                    if currentNotification == "Reservation" {
                        self.scheduleReservationNotification()
                    } else if currentNotification == "Future Reservation" {
                        self.scheduleFutureReservation(futureReservation: futureReservation!)
                    }
                } else {
                    print("Notifications are denied")
                }
            }
        } else {
            center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted {
                    if currentNotification == "Reservation" {
                        self.scheduleReservationNotification()
                    } else if currentNotification == "Future Reservation" {
                        self.scheduleFutureReservation(futureReservation: futureReservation!)
                    }
                } else {
                    print("Notifications are denied")
                }
            }
        }
    }
    
    //MARK: - Reservation -
    
    func scheduleReservationNotification() {
        if UserPrefsUtils.sharedInstance.reservationNotificationsEnabled() == 1 {
            center.getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                    self.cancelReservationNotification()
                    if timerSeconds > 0 {
                        self.scheduleReservationEndNot()
                    }
                    if timerSeconds > 60 {
                        self.scheduleReservation1Not()
                    }
                    if timerSeconds > 300 {
                        self.scheduleReservation5Not()
                    }
                } else {
                    self.askNotificationPermission(currentNotification: "Reservation")
                }
            }
        } else if UserPrefsUtils.sharedInstance.reservationNotificationsEnabled() == 2 {
            if #available(iOS 16.1, *) {
                LiveActivityHelper.sharedInstance.startLiveActivity(with: timerSeconds)
            }
        }
    }
    
    func scheduleReservationEndNot() {
        let content = UNMutableNotificationContent()
        content.title = "Reservation Done"
        content.body = "Thank you for using Roadout! We hope you enjoyed the experience!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "hornsound.aiff"))
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .timeSensitive
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(timerSeconds), repeats: false)
        let request = UNNotificationRequest(identifier: "ro.roadout.reservationDone", content: content, trigger: trigger)
        center.add(request) { err in
            if err == nil {
                print("Scheduled End Notification")
                self.UserDefaultsSuite.set(true, forKey: "ro.roadout.setDoneReservation")
            }
        }
    }
    
    func scheduleReservation1Not() {
        let content = UNMutableNotificationContent()
        content.title = "1 Minute Left"
        content.body = "There is a minute left from your reservation."
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "hornsound.aiff"))
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .timeSensitive
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(timerSeconds-60), repeats: false)
        let request = UNNotificationRequest(identifier: "ro.roadout.reservation1", content: content, trigger: trigger)
        center.add(request) { err in
            if err == nil {
                self.UserDefaultsSuite.set(true, forKey: "ro.roadout.set1Reservation")
            }
        }
    }
    
    func scheduleReservation5Not() {
        let content = UNMutableNotificationContent()
        content.title = "5 Minutes Left"
        content.body = "There are 5 minutes left from your reservation."
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "hornsound.aiff"))
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .timeSensitive
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(timerSeconds-300), repeats: false)
        let request = UNNotificationRequest(identifier: "ro.roadout.reservation5", content: content, trigger: trigger)
        center.add(request) { err in
            if err == nil {
                self.UserDefaultsSuite.set(true, forKey: "ro.roadout.set5Reservation")
            }
        }
    }
    
    func cancelReservationNotification() {
        if UserDefaultsSuite.bool(forKey: "ro.roadout.set5Reservation") {
            center.removePendingNotificationRequests(withIdentifiers: ["ro.roadout.reservation5"])
            self.UserDefaultsSuite.set(false, forKey: "ro.roadout.set5Reservation")
        }
        if UserDefaultsSuite.bool(forKey: "ro.roadout.set1Reservation") {
            center.removePendingNotificationRequests(withIdentifiers: ["ro.roadout.reservation1"])
            self.UserDefaultsSuite.set(false, forKey: "ro.roadout.set1Reservation")
        }
        if UserDefaultsSuite.bool(forKey: "ro.roadout.setDoneReservation") {
            center.removePendingNotificationRequests(withIdentifiers: ["ro.roadout.reservationDone"])
            self.UserDefaultsSuite.set(false, forKey: "ro.roadout.setDoneReservation")
        }
    }
    
    //MARK: - Location Notifications -
    
    func scheduleLocationNotification() {
        if UserPrefsUtils.sharedInstance.locationNotificationsEnabled() {
            center.getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                    let content = UNMutableNotificationContent()
                    content.title = "Arrived at Parking"
                    content.body = "It seems you have arrived at your parking location."
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "hornsound.aiff"))
                    if #available(iOS 15.0, *) {
                        content.interruptionLevel = .timeSensitive
                    }
                    let region = CLCircularRegion(center: self.decodeCoordsFromGeohash(), radius: 5.0, identifier: "ro.roadout.parkingSpotRegion")
                    let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
                    let request = UNNotificationRequest(identifier: "ro.roadout.setLocationReservation", content: content, trigger: trigger)
                    self.center.add(request) { err in
                        if err == nil {
                            self.UserDefaultsSuite.set(true, forKey: "ro.roadout.setLocationReservation")
                        }
                    }
                }
            }
        }
    }
    
    func cancelLocationNotification() {
        if UserDefaultsSuite.bool(forKey: "ro.roadout.setLocationReservation") {
            center.removePendingNotificationRequests(withIdentifiers: ["ro.roadout.setLocationReservation"])
            self.UserDefaultsSuite.set(false, forKey: "ro.roadout.setLocationReservation")
        }
    }
    
    func decodeCoordsFromGeohash() -> CLLocationCoordinate2D {
        let hashComponents = selectedSpotHash.components(separatedBy: "-") //[hash, fNR, hNR, pNR]
        let fov = String(hashComponents[1].dropFirst())
        let heading = String(hashComponents[2].dropFirst())
        let pitch = String(hashComponents[3].dropFirst())
        
        let lat = Geohash(geohash: hashComponents[0])!.coordinates.latitude
        let long = Geohash(geohash: hashComponents[0])!.coordinates.longitude
        
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    //MARK: - Future Reservations -
    
    func scheduleFutureReservation(futureReservation: FutureReservation) {
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                let content = UNMutableNotificationContent()
                content.title = "Reserve near " + futureReservation.place
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "carkeysound.aiff"))
                if #available(iOS 15.0, *) {
                    content.interruptionLevel = .timeSensitive
                }
                let calendar = Calendar(identifier: .gregorian)
                let dateComp = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: futureReservation.date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                let request = UNNotificationRequest(identifier: futureReservation.identifier, content: content, trigger: trigger)
                self.center.add(request) { _ in }
            } else {
                self.askNotificationPermission(currentNotification: "Future Reservation", futureReservation: futureReservation)
            }
        }
    }
    
    func removeFutureReservation(futureReservation: FutureReservation) {
        center.removePendingNotificationRequests(withIdentifiers: [futureReservation.identifier])
    }
    
}

@available(iOS 16.1, *)
class LiveActivityHelper {
    
    static let sharedInstance = LiveActivityHelper()
    
    var roadoutLiveActivity: Activity<RoadoutReservationAttributes>!
    
    private init() {}
    
    func startLiveActivity(with timerSeconds: Int) {
        if Activity<RoadoutReservationAttributes>.activities.isEmpty {
            //Start new activity
            let roadoutReservationAttributes = RoadoutReservationAttributes(parkSpotID: selectedSpotID)
            let initialContentState = RoadoutReservationAttributes.RoadoutReservationStatus(endTime: Date()...Date().addingTimeInterval(Double(timerSeconds)))
            Task {
                do {
                    roadoutLiveActivity = try Activity<RoadoutReservationAttributes>.request(
                        attributes: roadoutReservationAttributes,
                        contentState: initialContentState,
                        pushType: nil)
                } catch let err {
                    print(err)
                }
            }
        } else {
            updateLiveActivity(with: timerSeconds)
        }
    }
    
    func updateLiveActivity(with timerSeconds: Int) {
        if roadoutLiveActivity == nil {
            roadoutLiveActivity = Activity<RoadoutReservationAttributes>.activities.first
        }
        guard roadoutLiveActivity != nil else {
            startLiveActivity(with: timerSeconds)
            return
        }
        //Update
        let updatedStatus = RoadoutReservationAttributes.RoadoutReservationStatus(endTime: Date()...Date().addingTimeInterval(Double(timerSeconds)))
        Task {
            await roadoutLiveActivity.update(using: updatedStatus)
        }
    }
    
    func endLiveActivity() {
        if roadoutLiveActivity == nil {
            roadoutLiveActivity = Activity<RoadoutReservationAttributes>.activities.first
        }
        guard roadoutLiveActivity != nil else {
            //Already ended
            return
        }
        //End
        let updatedStatus = RoadoutReservationAttributes.RoadoutReservationStatus(endTime: Date()...Date())
        Task {
            await roadoutLiveActivity.end(using: updatedStatus, dismissalPolicy: .immediate)
        }
    }
}

