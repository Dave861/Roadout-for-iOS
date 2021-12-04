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
        completion(QuickReserveIntentResponse(code: .success, userActivity: nil))
        
    }
    
    public func confirm(intent: QuickReserveIntent, completion: @escaping (QuickReserveIntentResponse) -> Void) {
        print("Handling")
        print("Found: Old Town - Section A - Spot 12")
        checkReservation()
        findSpot()
        completion(QuickReserveIntentResponse(code: .ready, userActivity: nil))
    }
    
    func findSpot() {
        //if not found return .noSpotFound
    }
    
    func checkReservation() {
        //if not found return .reservationActive
    }
    
}
