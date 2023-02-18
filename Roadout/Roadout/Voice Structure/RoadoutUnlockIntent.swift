//
//  RoadoutUnlockIntent.swift
//  Roadout
//
//  Created by David Retegan on 16.02.2023.
//

import Foundation
import AppIntents
import UIKit
import GeohashKit

@available(iOS 16, *)
struct RoadoutUnlockIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Unlock you current Reservation"
    
    static var description: IntentDescription = "Unlock and park on your currently reserved spot"
    
    static var authenticationPolicy: IntentAuthenticationPolicy = .requiresLocalDeviceAuthentication
        
    func perform() async throws -> some IntentResult {
        //Check pre-conditions
        if RoadoutUnlockIntentHelper.sharedInstance.checkConditions() == false {
            throw RoadoutIntentErrors.failureRequiringAppLaunch
        }

        //Check if there is an active reservation
        do {
            try await RoadoutUnlockIntentHelper.sharedInstance.checkForReservation()
        } catch {
            throw RoadoutIntentErrors.failureRequiringAppLaunch
        }
        
        if ReservationManager.sharedInstance.isReservationActive == 0 {
            //Ask for confirmation
            try await requestConfirmation(
                  result: .result(
                    dialog: "Are you sure you want to unlock your parking spot? This action is final",
                    view: RoadoutIntentActiveView(reservationTime: ReservationManager.sharedInstance.reservationEndDate)
                  ),
                  confirmationActionName: .continue
                )
            
            //Unlock
            let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
            do {
                try await ReservationManager.sharedInstance.unlockReservationAsync(userID: id, date: Date())
                DispatchQueue.main.async {
                    if ReservationManager.sharedInstance.reservationTimer != nil {
                        ReservationManager.sharedInstance.reservationTimer.invalidate()
                    }
                    NotificationHelper.sharedInstance.cancelReservationNotification()
                    NotificationHelper.sharedInstance.cancelLocationNotification()
                    if #available(iOS 16.1, *) {
                        LiveActivityHelper.sharedInstance.endLiveActivity()
                    }
                }
            } catch {
                throw RoadoutIntentErrors.failureRequiringAppLaunch
            }
            return .result(dialog: "Your spot was unlocked.") {
                RoadoutIntentUnlockedView()
            }
        } else {
            //No active reservation
            return .result(dialog: "It doesn't seem you have any active parking reservation.") {
                RoadoutIntentNoReservationView()
            }
        }
    }
}

@available(iOS 16, *)
class RoadoutUnlockIntentHelper: NSObject {
    
    static let sharedInstance = RoadoutUnlockIntentHelper()
    
    func checkConditions() -> Bool {
        //Checking for user
        return UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.isUserSigned")
    }
    
    func checkForReservation() async throws {
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID")
        do {
            try await ReservationManager.sharedInstance.checkForReservationAsync(date: Date(), userID: id as! String)
        } catch let err {
            throw err
        }
    }
}

