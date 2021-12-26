//
//  NotificationHelper.swift
//  Roadout
//
//  Created by David Retegan on 03.11.2021.
//

import Foundation
import UserNotifications

class NotificationHelper {
    
    static let sharedInstance = NotificationHelper()
    let center = UNUserNotificationCenter.current()
    let UserDefaultsSuite = UserDefaults.init(suiteName: "group.ro.roadout.Roadout")!
    
  //MARK: - Authorization -
    
    func manageNotifications() {
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                print("Gooood")
            } else {
                self.askNotificationPermission(currentNotification: "")
            }
        }
    }
    
    func askNotificationPermission(currentNotification: String, reminder: Reminder? = nil) {
        if #available(iOS 15.0, *) {
            center.requestAuthorization(options: [.alert, .sound, .timeSensitive]) { granted, error in
                if granted {
                    if currentNotification == "Reservation" {
                        self.scheduleReservationNotification()
                    } else if currentNotification == "Reminder" {
                        self.scheduleReminder(reminder: reminder!)
                    }
                } else {
                    print("Bad Luck")
                }
            }
        } else {
            center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted {
                    if currentNotification == "Reservation" {
                        self.scheduleReservationNotification()
                    } else if currentNotification == "Reminder" {
                        self.scheduleReminder(reminder: reminder!)
                    }
                } else {
                    print("Bad Luck")
                }
            }
        }
    }
    
    //MARK: - Reservation -
    
    func scheduleReservationNotification() {
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
        print(timerSeconds)
        let request = UNNotificationRequest(identifier: "ro.roadout.reservationDone", content: content, trigger: trigger)
        center.add(request) { err in
            if err == nil {
                print("Done")
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
    
    //MARK: - Reminders -
    
    func scheduleReminder(reminder: Reminder) {
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                let content = UNMutableNotificationContent()
                content.title = reminder.label
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "carkeysound.aiff"))
                if #available(iOS 15.0, *) {
                    content.interruptionLevel = .timeSensitive
                }
                let calendar = Calendar(identifier: .gregorian)
                let dateComp = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                let request = UNNotificationRequest(identifier: reminder.identifier, content: content, trigger: trigger)
                self.center.add(request) { err in
                    if err == nil {
                        print("Did it")
                    }
                }
            } else {
                self.askNotificationPermission(currentNotification: "Reminder", reminder: reminder)
            }
        }
    }
    
    func removeReminder(reminder: Reminder) {
        center.removePendingNotificationRequests(withIdentifiers: [reminder.identifier])
    }
    
}
