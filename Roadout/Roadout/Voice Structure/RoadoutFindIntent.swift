//
//  RoadoutAppIntent.swift
//  RoadoutAppIntent
//
//  Created by David Retegan on 12.11.2022.
//

import UIKit
import AppIntents
import CoreLocation

@available(iOS 16, *)
struct RoadoutFindIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Reserve the closest Parking Spot"
    
    static var description: IntentDescription = "Find and easily reserve the closest available parking spot"

    @Parameter(title: "Duration", description: "The duration of the reservation", requestValueDialog: IntentDialog("For how many minutes do you want to reserve? The maximum is 20 minutes."))
    var reservationMinutes: Int?
    
    static var parameterSummary: some ParameterSummary {
        Summary("Reserve the nearest parking spot for \(\.$reservationMinutes) minutes")
    }
    
    static var authenticationPolicy: IntentAuthenticationPolicy = .requiresLocalDeviceAuthentication
    
    func perform() async throws -> some IntentResult {
        //Check pre-conditions
        do {
            let conditionsCheckResult = try await RoadoutFindIntentHelper.sharedInstance.checkConditions()
            if conditionsCheckResult == false {
                throw RoadoutIntentErrors.failureRequiringAppLaunch
            }
        } catch {
            throw RoadoutIntentErrors.failureRequiringAppLaunch
        }
        
        //Get user location
        guard let userCoords = await RoadoutFindIntentHelper.sharedInstance.getCurrentCoordinates() else {
            throw RoadoutIntentErrors.locationDisabled
        }

        //Find Way
        FunctionsManager.sharedInstance.foundSpot = nil
        FunctionsManager.sharedInstance.sortLocations(currentLocation: userCoords)
        do {
            let didFindSpot = try await FunctionsManager.sharedInstance.findWay()
            if !didFindSpot {
                throw RoadoutIntentErrors.failureRequiringAppLaunch
            }
        } catch let err {
            print(err)
            throw RoadoutIntentErrors.failureRequiringAppLaunch
        }
        
        //Make distance
        let distanceInMeters = CLLocation(latitude: FunctionsManager.sharedInstance.foundLocation.latitude, longitude: FunctionsManager.sharedInstance.foundLocation.longitude).distance(from: CLLocation(latitude: userCoords.latitude, longitude: userCoords.longitude))
        let distance = (distanceInMeters/1000.0).rounded(toPlaces: 2)
        
        try await requestConfirmation(
              result: .result(
                dialog: "The nearest parking is Spot \(FunctionsManager.sharedInstance.foundSpot.number) in Section \( FunctionsManager.sharedInstance.foundSection.name), \(FunctionsManager.sharedInstance.foundLocation.name), \(String(format: "%.2f", distance)) km away. Continue?",
                view: RoadoutIntentConfirmSpotView(
                    parkLocationName: FunctionsManager.sharedInstance.foundLocation.name,
                    parkSectionLetter: FunctionsManager.sharedInstance.foundSection.name,
                    parkSpotNumber: FunctionsManager.sharedInstance.foundSpot.number,
                    distance: distance)
              ),
              confirmationActionName: .continue
            )
        
        //Ask for minutes
        reservationMinutes = try await $reservationMinutes.requestValue()
        guard reservationMinutes != nil else {
            throw RoadoutIntentErrors.valueZero
        }
        
        if reservationMinutes! > 20 {
            reservationMinutes = 20
        } else if reservationMinutes! <= 0 {
            throw RoadoutIntentErrors.valueZero
        }
                
        //Make price
        let resPrice = Double(reservationMinutes!).rounded(toPlaces: 2)*0.75
        
        try await requestConfirmation(
              result: .result(
                dialog: "The total comes to \(String(format: "%.2f", resPrice)) RON. Ready to reserve for \(reservationMinutes!) minutes?",
                view: RoadoutIntentConfirmPayView(
                    minutesValue: reservationMinutes!,
                    total: resPrice,
                    isReservation: true)
              ),
              confirmationActionName: .pay
            )
         
        //Reserve spot
        let id = UserDefaults.roadout!.object(forKey: "eu.roadout.Roadout.userID") as! String
        do {
            try await ReservationManager.sharedInstance.makeReservationAsync(date: Date(), time: reservationMinutes!, spotID: selectedSpot.rID, payment: Int(resPrice), userID: id)
        } catch {
            throw RoadoutIntentErrors.failureRequiringAppLaunch
        }
        
        return .result(dialog: "Spot Reserved! Open Roadout for more actions.") {
            RoadoutIntentActiveView(reservationTime: ReservationManager.sharedInstance.reservationEndDate)
        }
    }
}

@available(iOS 16, *)
class RoadoutFindIntentHelper: NSObject {
    
    static let sharedInstance = RoadoutFindIntentHelper()
    
    var userLocationCallback: ((CLLocationCoordinate2D?) -> Void)?
    var locationManager: CLLocationManager!
    
    private override init() {
        super.init()
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
        }
    }
    
    func checkConditions() async throws -> Bool {
        //Checking for user
        if UserDefaults.roadout!.bool(forKey: "eu.roadout.Roadout.isUserSigned") == false {
            return false
        }
        //Checking for active reservation
        guard let id = UserDefaults.roadout!.object(forKey: "eu.roadout.Roadout.userID") else {
            throw RoadoutIntentErrors.failureRequiringAppLaunch
        }
        do {
            try await ReservationManager.sharedInstance.checkForReservationAsync(date: Date(), userID: id as! String)
        } catch let err {
            throw err
        }
        if ReservationManager.sharedInstance.isReservationActive == 0 {
            return false
        }
        //Checking for parking locations
        if parkLocations.count == testParkLocations.count {
            do {
                try await saveCityData()
                return true
            } catch let err {
                throw err
            }
        }
        return true
    }
    
    func saveCityData() async throws {
        do {
            try await downloadCityData("Cluj")
            parkLocations = testParkLocations + dbParkLocations
        } catch let err {
            throw err
        }
    }
    
    func downloadCityData(_ city: String) async throws {
        do {
            try await EntityManager.sharedInstance.saveParkLocationsAsync(city)
        } catch let err {
            throw err
        }
        for pI in 0...dbParkLocations.count-1 {
            do {
                try await EntityManager.sharedInstance.saveParkSectionsAsync(dbParkLocations[pI].rID)
                dbParkLocations[pI].sections = dbParkSections
            } catch let err {
                throw err
            }
        }
    }
    
    func getCurrentCoordinates() async -> CLLocationCoordinate2D? {
        await withCheckedContinuation { continuation in
           getCurrentCoordinates() { coordinates in
                continuation.resume(returning: coordinates)
            }
        }
    }
    
    func getCurrentCoordinates(callback: @escaping (CLLocationCoordinate2D?) -> Void) {
        let status = locationManager.authorizationStatus
        guard status == .authorizedAlways || status == .authorizedWhenInUse else {
            userLocationCallback?(nil)
            return
        }
        
        self.userLocationCallback = callback
        locationManager.requestLocation()
    }
    
}
@available(iOS 16, *)
extension RoadoutFindIntentHelper: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.userLocationCallback?(locations.first?.coordinate)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        self.userLocationCallback?(nil)
    }
}
