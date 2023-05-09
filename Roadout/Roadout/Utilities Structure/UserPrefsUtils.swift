//
//  UserPrefs.swift
//  Roadout
//
//  Created by David Retegan on 02.11.2021.
//

import Foundation

class UserPrefsUtils {
    
    static let sharedInstance = UserPrefsUtils()
    
    private init() {}
        
    func returnPrefferedMapsApp() -> String {
        let app = UserDefaults.roadout!.string(forKey: "eu.roadout.defaultDirectionsApp")
        return app ?? "Apple Maps"
    }
    
    func returnMainCard() -> String {
        let cardIndex = UserDefaults.roadout!.integer(forKey: "eu.roadout.defaultPaymentMethod")
        let cardNumbers = UserDefaults.roadout!.stringArray(forKey: "eu.roadout.paymentMethods") ?? [String]()
        if cardIndex < cardNumbers.count {
            let card = cardNumbers[cardIndex]
            return card
        } else {
            return "0000 0000 0000 0000"
        }
    }
     
    func reservationNotificationsEnabled() -> Int {
        let option = UserDefaults.roadout!.integer(forKey: "eu.roadout.reservationNotificationsOption")
        return option
    }
    
    func locationNotificationsEnabled() -> Bool {
        let enabled = UserDefaults.roadout!.bool(forKey: "eu.roadout.locationNotificationsEnabled")
        return enabled
    }
    
    func futureNotificationsEnabled() -> Bool {
        let enabled = UserDefaults.roadout!.bool(forKey: "eu.roadout.futureNotificationsEnabled")
        return enabled
    }
    
}
