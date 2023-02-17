//
//  RoadoutDelayIntent.swift
//  Roadout
//
//  Created by David Retegan on 16.02.2023.
//

import Foundation
import AppIntents
import UIKit
import GeohashKit

@available(iOS 16, *)
struct RoadoutDelayIntent: AppIntent {
    static var title: LocalizedStringResource = "Delay you current Reservation"
    
    static var description: IntentDescription = "Add more minutes to your current reservation so you get to your spot in time"
    
    @Parameter(title: "Duration", description: "The duration of the delay", requestValueDialog: IntentDialog("For how many minutes do you want to delay? The maximum is 10 minutes."))
    var delayMinutes: Int?
    
    static var parameterSummary: some ParameterSummary {
        Summary("Delay your parking reservation for \(\.$delayMinutes) minutes")
    }
    
    static var authenticationPolicy: IntentAuthenticationPolicy = .requiresLocalDeviceAuthentication
        
    func perform() async throws -> some IntentResult {
        //Check pre-conditions
        if RoadoutDelayIntentHelper.sharedInstance.checkConditions() == false {
            throw RoadoutIntentErrors.failureRequiringAppLaunch
        }

        //Check if there is an active reservation
        do {
            try await RoadoutDelayIntentHelper.sharedInstance.checkForReservation()
        } catch {
            throw RoadoutIntentErrors.failureRequiringAppLaunch
        }
        
        if ReservationManager.sharedInstance.isReservationActive == 0 {
            //Active reservation found
            //Check if already delayed
            var delayWasMade: Bool?
            do {
                let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID")
                delayWasMade = try await ReservationManager.sharedInstance.checkReservationWasDelayedAsync(userID: id as! String)
            } catch {
                throw RoadoutIntentErrors.alreadyDelayed
            }
            
            if !(delayWasMade ?? true) {
                //Ask for minutes
                delayMinutes = try await $delayMinutes.requestValue()
                guard delayMinutes != nil else {
                    throw RoadoutIntentErrors.valueZero
                }
                
                if delayMinutes! > 10 {
                    delayMinutes = 10
                } else if delayMinutes! <= 0 {
                    throw RoadoutIntentErrors.valueZero
                }
                                
                //Make price
                let delayPrice = Double(delayMinutes!).rounded(toPlaces: 2)*0.75
                
                try await requestConfirmation(
                      result: .result(
                        dialog: "The total comes to \(String(format: "%.2f", delayPrice)) RON. Ready to delay for \(delayMinutes!) minutes?",
                        view: RoadoutIntentConfirmPayView(
                            minutesValue: delayMinutes!,
                            total: delayPrice,
                            isReservation: false)
                      ),
                      confirmationActionName: .pay
                    )
                
                //Delay
                let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
                do {
                    try await ReservationManager.sharedInstance.delayReservationAsync(date: Date(), minutes: delayMinutes!, userID: id)
                } catch {
                    throw RoadoutIntentErrors.failureRequiringAppLaunch
                }
                
                return .result(dialog: "Reservation Delayed! Open Roadout for more actions.") {
                    RoadoutIntentActiveView(reservationTime: ReservationManager.sharedInstance.reservationEndDate)
                }
            } else {
                return .result(dialog: "It seems you have already delayed your reservation.") {
                    RoadoutIntentAlreadyDelayedView()
                }
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
class RoadoutDelayIntentHelper: NSObject {
    
    static let sharedInstance = RoadoutDelayIntentHelper()
    
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

