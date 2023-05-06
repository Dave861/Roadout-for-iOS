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
    var areNotificationsAllowed: Bool?
    
    enum NotificationType {
        case reservation
        case location
        case none
    }
    
  //MARK: - Authorization -
    
    func manageNotifications() {
        center.getNotificationSettings { settings in
            if settings.authorizationStatus != .authorized && settings.authorizationStatus != .provisional {
                self.askNotificationPermission(currentNotification: .none)
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
    
    func askNotificationPermission(currentNotification: NotificationType, futureReservation: FutureReservation? = nil) {
        if #available(iOS 15.0, *) {
            center.requestAuthorization(options: [.alert, .sound, .timeSensitive]) { granted, error in
                if granted {
                    if currentNotification == .reservation {
                        self.scheduleReservationNotification()
                    }
                }
            }
        } else {
            center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted {
                    if currentNotification == .reservation {
                        self.scheduleReservationNotification()
                    }
                }
            }
        }
    }
    
    //MARK: - Reservation Notifications -
    
    func scheduleReservationNotification() {
        if UserPrefsUtils.sharedInstance.reservationNotificationsEnabled() == 1 {
            center.getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                    self.cancelReservationNotification()
                    if reservationTime > 0 {
                        self.scheduleReservationEndNot()
                    }
                    if reservationTime > 60 {
                        self.scheduleReservation1Not()
                    }
                    if reservationTime > 300 {
                        self.scheduleReservation5Not()
                    }
                } else {
                    self.askNotificationPermission(currentNotification: .reservation)
                }
            }
        } else if UserPrefsUtils.sharedInstance.reservationNotificationsEnabled() == 2 {
            if #available(iOS 16.1, *) {
                LiveActivityHelper.sharedInstance.startLiveActivity(with: reservationTime)
            }
        }
    }
    
    func scheduleReservationEndNot() {
        let content = UNMutableNotificationContent()
        content.title = "Reservation Done".localized()
        content.body = "Thank you for using Roadout! We hope you enjoyed the experience!".localized()
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "hornsound.aiff"))
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .timeSensitive
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(reservationTime), repeats: false)
        let request = UNNotificationRequest(identifier: "ro.roadout.reservationDone", content: content, trigger: trigger)
        center.add(request) { err in
            if err == nil {
                UserDefaults.roadout!.set(true, forKey: "ro.roadout.setDoneReservation")
            }
        }
    }
    
    func scheduleReservation1Not() {
        let content = UNMutableNotificationContent()
        content.title = "1 Minute Left".localized()
        content.body = "There is a minute left from your reservation.".localized()
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "hornsound.aiff"))
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .timeSensitive
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(reservationTime-60), repeats: false)
        let request = UNNotificationRequest(identifier: "ro.roadout.reservation1", content: content, trigger: trigger)
        center.add(request) { err in
            if err == nil {
                UserDefaults.roadout!.set(true, forKey: "ro.roadout.set1Reservation")
            }
        }
    }
    
    func scheduleReservation5Not() {
        let content = UNMutableNotificationContent()
        content.title = "5 Minutes Left".localized()
        content.body = "There are 5 minutes left from your reservation.".localized()
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "hornsound.aiff"))
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .timeSensitive
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(reservationTime-300), repeats: false)
        let request = UNNotificationRequest(identifier: "ro.roadout.reservation5", content: content, trigger: trigger)
        center.add(request) { err in
            if err == nil {
                UserDefaults.roadout!.set(true, forKey: "ro.roadout.set5Reservation")
            }
        }
    }
    
    func cancelReservationNotification() {
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.set5Reservation") {
            center.removePendingNotificationRequests(withIdentifiers: ["ro.roadout.reservation5"])
            UserDefaults.roadout!.set(false, forKey: "ro.roadout.set5Reservation")
        }
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.set1Reservation") {
            center.removePendingNotificationRequests(withIdentifiers: ["ro.roadout.reservation1"])
            UserDefaults.roadout!.set(false, forKey: "ro.roadout.set1Reservation")
        }
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.setDoneReservation") {
            center.removePendingNotificationRequests(withIdentifiers: ["ro.roadout.reservationDone"])
            UserDefaults.roadout!.set(false, forKey: "ro.roadout.setDoneReservation")
        }
    }
    
    //MARK: - Location Notifications -
    
    func scheduleLocationNotification() {
        if UserPrefsUtils.sharedInstance.locationNotificationsEnabled() {
            center.getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                    let content = UNMutableNotificationContent()
                    content.title = "Arrived at Parking".localized()
                    content.body = "It seems you have arrived at your parking location.".localized()
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "hornsound.aiff"))
                    if #available(iOS 15.0, *) {
                        content.interruptionLevel = .timeSensitive
                    }
                    let region = CLCircularRegion(center: self.decodeCoordsFromGeohash(), radius: 5.0, identifier: "ro.roadout.parkingSpotRegion")
                    let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
                    let request = UNNotificationRequest(identifier: "ro.roadout.setLocationReservation", content: content, trigger: trigger)
                    self.center.add(request) { err in
                        if err == nil {
                            UserDefaults.roadout!.set(true, forKey: "ro.roadout.setLocationReservation")
                        }
                    }
                }
            }
        }
    }
    
    func cancelLocationNotification() {
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.setLocationReservation") {
            center.removePendingNotificationRequests(withIdentifiers: ["ro.roadout.setLocationReservation"])
            UserDefaults.roadout!.set(false, forKey: "ro.roadout.setLocationReservation")
        }
    }
    
    func decodeCoordsFromGeohash() -> CLLocationCoordinate2D {
        let hashComponents = selectedSpot.rHash.components(separatedBy: "-") //[hash, fNR, hNR, pNR]
        
        let lat = Geohash(geohash: hashComponents[0])!.coordinates.latitude
        let long = Geohash(geohash: hashComponents[0])!.coordinates.longitude
        
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
}

@available(iOS 16.1, *)
class LiveActivityHelper {
    
    static let sharedInstance = LiveActivityHelper()
    
    var roadoutLiveActivity: Activity<RoadoutReservationAttributes>!
    
    private init() {}
    
    func startLiveActivity(with reservationTime: Int) {
        if Activity<RoadoutReservationAttributes>.activities.isEmpty {
            //Start new activity
            let roadoutReservationAttributes = RoadoutReservationAttributes(parkSpotID: selectedSpot.rID)
            let initialContentState = RoadoutReservationAttributes.RoadoutReservationStatus(endTime: Date()...Date().addingTimeInterval(Double(reservationTime)))
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
            updateLiveActivity(with: reservationTime)
        }
    }
    
    func updateLiveActivity(with reservationTime: Int) {
        if roadoutLiveActivity == nil {
            roadoutLiveActivity = Activity<RoadoutReservationAttributes>.activities.first
        }
        guard roadoutLiveActivity != nil else {
            startLiveActivity(with: reservationTime)
            return
        }
        //Update
        let updatedStatus = RoadoutReservationAttributes.RoadoutReservationStatus(endTime: Date()...Date().addingTimeInterval(Double(reservationTime)))
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

