//
//  QuickReserveIntentHandler.swift
//  Roadout
//
//  Created by David Retegan on 30.11.2021.
//

import Foundation
import Intents

public class QuickReserveIntentHandler: NSObject, QuickReserveIntentHandling {
    
    public func handle(intent: QuickReserveIntent, completion: @escaping (QuickReserveIntentResponse) -> Void) {
        print("Confirmed")
        print("Do the reservation")
        reserveSpot()
        timerSeconds = 15*60
        if UserPrefsUtils.sharedInstance.reservationNotificationsEnabled() {
            NotificationHelper.sharedInstance.scheduleReservationNotification()
        }
        completion(QuickReserveIntentResponse(code: .success, userActivity: nil))
        
    }
    
    public func confirm(intent: QuickReserveIntent, completion: @escaping (QuickReserveIntentResponse) -> Void) {
        print("Handling")
        if checkReservation() {
            completion(QuickReserveIntentResponse(code: .reservationActive, userActivity: nil))
        }
        findSpot()
        print("Found: Old Town - Section A - Spot 12")
        completion(QuickReserveIntentResponse(code: .ready, userActivity: nil))
    }
    
    func findSpot() {
        //if not found return .noSpotFound
    }
    
    func checkReservation() -> Bool {
        return ReservationManager.sharedInstance.checkActiveReservation()
    }
    
    func reserveSpot() {
        ReservationManager.sharedInstance.saveReservationDate(Date().addingTimeInterval(TimeInterval(900)))
        ReservationManager.sharedInstance.saveActiveReservation(true)
    }
    
}
