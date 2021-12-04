//
//  UserPrefs.swift
//  Roadout
//
//  Created by David Retegan on 02.11.2021.
//

import Foundation

class UserPrefsUtils {
    
    static let sharedInstance = UserPrefsUtils()
    
    func returnPrefferedMapsApp() -> String {
        let app = UserDefaults.standard.string(forKey: "ro.roadout.defaultDirectionsApp")
        return app ?? "Apple Maps"
    }
    
    func returnMainCard() -> String {
        let cardIndex = UserDefaults.standard.integer(forKey: "ro.roadout.defaultPaymentMethod")
        let cardNumbers = UserDefaults.standard.stringArray(forKey: "ro.roadout.paymentMethods") ?? ["**** **** **** 9000", "**** **** **** 7250", "**** **** **** 7784", "**** **** **** 9432"]
        let card = cardNumbers[cardIndex]
        return card
    }
     
    func reservationNotificationsEnabled() -> Bool {
        let enabled = UserDefaults.standard.bool(forKey: "ro.roadout.reservationNotificationsEnabled")
        return enabled
    }
    
    func reminderNotificationsEnabled() -> Bool {
        let enabled = UserDefaults.standard.bool(forKey: "ro.roadout.reminderNotificationsEnabled")
        return enabled
    }
    
}
