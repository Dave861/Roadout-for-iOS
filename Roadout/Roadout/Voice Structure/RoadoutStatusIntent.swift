//
//  RoadoutStatusIntent.swift
//  Roadout
//
//  Created by David Retegan on 16.02.2023.
//

import UIKit
import AppIntents
import SwiftUI

@available(iOS 16, *)
struct RoadoutStatusIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Check your Reservation Status"
    
    static var description: IntentDescription = "Get a summary about your current reservation"
    
    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed
    
    func perform() async throws -> some IntentResult {
        //Check pre-conditions
        if RoadoutStatusIntentHelper.sharedInstance.checkConditions() == false {
            throw RoadoutIntentErrors.failureRequiringAppLaunch
        }

        //Check if there is an active reservation
        var reservationDetails: IntentDialog!
        do {
            reservationDetails = try await RoadoutStatusIntentHelper.sharedInstance.getReservationDetails()
        } catch {
            throw RoadoutIntentErrors.failureRequiringAppLaunch
        }
        
        //Return reservation status
        if ReservationManager.sharedInstance.isReservationActive == 0 {
            return .result(dialog: reservationDetails) {
                RoadoutIntentActiveView(reservationTime: ReservationManager.sharedInstance.reservationEndDate)
            }
        } else if ReservationManager.sharedInstance.isReservationActive == 1 {
            return .result(dialog: reservationDetails) {
                RoadoutIntentUnlockedView()
            }
        } else {
            return .result(dialog: reservationDetails) {
                RoadoutIntentNoReservationView()
            }
        }
    }
}

@available(iOS 16, *)
class RoadoutStatusIntentHelper: NSObject {
    
    static let sharedInstance = RoadoutStatusIntentHelper()
    
    func checkConditions() -> Bool {
        //Checking for user
        return UserDefaults.roadout!.bool(forKey: "eu.roadout.Roadout.isUserSigned")
    }
    
    func getReservationDetails() async throws -> IntentDialog {
        let id = UserDefaults.roadout!.object(forKey: "eu.roadout.Roadout.userID")
        do {
            try await ReservationManager.sharedInstance.checkForReservationAsync(date: Date(), userID: id as! String)
        } catch let err {
            throw err
        }
        if ReservationManager.sharedInstance.isReservationActive == 0 {
            let spotDetails = EntityManager.sharedInstance.decodeSpotID(selectedSpot.rID)
            let timeLeft = ReservationManager.sharedInstance.reservationEndDate.timeIntervalSinceNow
            return "You have a Roadout parking reservation for Spot \(spotDetails[2]) in Section \(spotDetails[1]), \(spotDetails[0]). It seems you have about \(Int(timeLeft/60)) minutes left from it."
        } else if ReservationManager.sharedInstance.isReservationActive == 1 {
            return "It seems you have just unlocked your parking reservation."
        } else {
            return "It doesn't seem you have any active parking reservation."
        }
    }
}
