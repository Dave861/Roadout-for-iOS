//
//  UserPrefs.swift
//  Roadout
//
//  Created by David Retegan on 02.11.2021.
//

import Foundation

class UserPrefsUtils {
    
    static let sharedInstance = UserPrefsUtils()
    let UserDefaultsSuite = UserDefaults.init(suiteName: "group.ro.roadout.Roadout")!
    
    func returnPrefferedMapsApp() -> String {
        let app = UserDefaultsSuite.string(forKey: "ro.roadout.defaultDirectionsApp")
        return app ?? "Apple Maps"
    }
    
    func returnMainCard() -> String {
        let cardIndex = UserDefaultsSuite.integer(forKey: "ro.roadout.defaultPaymentMethod")
        let cardNumbers = UserDefaultsSuite.stringArray(forKey: "ro.roadout.paymentMethods") ?? ["**** **** **** 9000", "**** **** **** 7250", "**** **** **** 7784", "**** **** **** 9432"]
        let card = cardNumbers[cardIndex]
        return card
    }
     
    func reservationNotificationsEnabled() -> Bool {
        let enabled = UserDefaultsSuite.bool(forKey: "ro.roadout.reservationNotificationsEnabled")
        return enabled
    }
    
    func reminderNotificationsEnabled() -> Bool {
        let enabled = UserDefaultsSuite.bool(forKey: "ro.roadout.reminderNotificationsEnabled")
        return enabled
    }
    
}
