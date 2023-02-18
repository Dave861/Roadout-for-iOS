//
//  RoadoutDirectionsIntent.swift
//  Roadout
//
//  Created by David Retegan on 16.02.2023.
//

import Foundation
import AppIntents
import UIKit
import GeohashKit

@available(iOS 16, *)
struct RoadoutDirectionsIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Navigate to your current Reservation"
    
    static var description: IntentDescription = "Get directions in your favourite maps app to the spot you reserved"
    
    static var authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed
    
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult {
        //Check pre-conditions
        if RoadoutDirectionsIntentHelper.sharedInstance.checkConditions() == false {
            throw RoadoutIntentErrors.failureRequiringAppLaunch
        }

        //Check if there is an active reservation
        do {
            try await RoadoutDirectionsIntentHelper.sharedInstance.checkForReservation()
        } catch {
            throw RoadoutIntentErrors.failureRequiringAppLaunch
        }
        
        //Get directions
        if ReservationManager.sharedInstance.isReservationActive == 0 || ReservationManager.sharedInstance.isReservationActive == 1 {
            let hashComponents = selectedSpot.rHash.components(separatedBy: "-") //[hash, fNR, hNR, pNR]
            let lat = Geohash(geohash: hashComponents[0])!.coordinates.latitude
            let long = Geohash(geohash: hashComponents[0])!.coordinates.longitude
            DispatchQueue.main.async {
                RoadoutDirectionsIntentHelper.sharedInstance.openDirectionsToCoords(lat: lat, long: long)
            }
            return .result(dialog: "Navigating...")
        } else {
            return .result(dialog: "It doesn't seem you have any active parking reservation.")
        }
    }
}

@available(iOS 16, *)
class RoadoutDirectionsIntentHelper: NSObject {
    
    static let sharedInstance = RoadoutDirectionsIntentHelper()
    
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
    
    func openDirectionsToCoords(lat: Double, long: Double) {
        var link: String
        switch UserPrefsUtils.sharedInstance.returnPrefferedMapsApp() {
        case "Google Maps":
            link = "https://www.google.com/maps/search/?api=1&query=\(lat),\(long)"
        case "Waze":
            link = "https://www.waze.com/ul?ll=\(lat)%2C-\(long)&navigate=yes&zoom=15"
        default:
            link = "https://maps.apple.com/?ll=\(lat),\(long)&q=Roadout%20Location"
        }
        guard UIApplication.shared.canOpenURL(URL(string: link)!) else { return }
        UIApplication.shared.open(URL(string: link)!)
    }
}

