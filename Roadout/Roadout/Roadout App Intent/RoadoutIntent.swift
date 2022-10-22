//
//  RoadoutIntent.swift
//  Roadout
//
//  Created by David Retegan on 17.09.2022.
//

import Foundation
import UIKit
import CoreLocation
import AppIntents

@available (iOS 16.0, *)
enum RoadoutIntentErrors: Error {
    case valueZero
    case noFreeSpot
    case reservationActive
    case failureRequiringAppLaunch
    case noSpotFound
    case locationDisabled
}

@available (iOS 16.0, *)
struct RoadoutIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Roadout Reservation"
    
    @Parameter(title: "Duration", description: "The duration of the reservation", requestValueDialog: IntentDialog("For how many minutes do you want to reserve? The maximum is 20 minutes."))
    var reservationMinutes: Int!
    
    static var parameterSummary: some ParameterSummary {
        Summary("Reserve the nearest parking spot for \(\.$reservationMinutes) minutes")
    }
    
    func perform() async throws -> some IntentResult {
        do {
            reservationMinutes = try await $reservationMinutes.requestValue()
            
            if reservationMinutes > 20 {
                reservationMinutes = 20
            } else if reservationMinutes <= 0 {
                throw RoadoutIntentErrors.valueZero
            }
            
           /* var findingErrorEncountered = false
            RoadoutIntentHelper.sharedInstance.performFind { result in
                switch result {
                case .success():
                    print("Found Spot!")
                    print(FunctionsManager.sharedInstance.foundLocation.name)
                    
                case .failure(let err):
                    print(err)
                    findingErrorEncountered = true
                }
            }
            if findingErrorEncountered {
                throw RoadoutIntentErrors.failureRequiringAppLaunch
            }*/
            
            try await requestConfirmation(result: .result(dialog: "Ready to reserve for 15 RON?") {
                RoadoutIntentConfirmView(
                    parkLocationName: "Test Location",
                    /*FunctionsManager.sharedInstance.foundLocation.name*/
                    parkSectionLetter: "T",
                    /*FunctionsManager.sharedInstance.foundSection.name*/
                    parkSpotNumber: 1,
                    /*FunctionsManager.sharedInstance.foundSpot.number*/
                    reservationMinutes: reservationMinutes)
            })
            /*
            var reservingErrorEncountered = false
            RoadoutIntentHelper.sharedInstance.reserveSpot { result in
                switch result {
                case .success():
                    print("Spot Reserved")
                case .failure(let err):
                    print(err)
                    reservingErrorEncountered = true
                }
            }
            if reservingErrorEncountered {
                throw RoadoutIntentErrors.failureRequiringAppLaunch
            }
            */
            return .result(dialog: "Spot Reserved! Open the app for directions.") {
                RoadoutIntentSuccesView(reservationTime: Date().addingTimeInterval(Double(reservationMinutes)*60))
            }
        } catch let err {
            throw err
        }
    }
    
}

@available (iOS 16.0, *)
struct RoadoutAutoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: RoadoutIntent(),
            phrases: ["Ask \(.applicationName) to find somewhere to park",
                      "Ask \(.applicationName) to find parking",
                      "Find parking with \(.applicationName)",
                      "Find somewhere to park with \(.applicationName)"]
        )
    }
}

@available (iOS 16.0, *)
class RoadoutIntentHelper: NSObject {
    
    static let sharedInstance = RoadoutIntentHelper()
    
    private override init() {}
    
    var locationManager: CLLocationManager?
    
    func downloadCityData() {
        parkLocations = testParkLocations //will empty here
        EntityManager.sharedInstance.getParkLocations("Cluj") { result in
            switch result {
                case .success():
                for index in 0...dbParkLocations.count-1 {
                    EntityManager.sharedInstance.getParkSections(dbParkLocations[index].rID) { res in
                        switch res {
                            case .success():
                                dbParkLocations[index].sections = dbParkSections
                                parkLocations.append(dbParkLocations[index])
                            case .failure(let err):
                                print(err)
                        }
                    }
                }
                case .failure(let err):
                    print(err)
            }
        }
    }
    
    func performFind(completion: @escaping(Result<Void, Error>) -> Void) {
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.isUserSigned") {
            if parkLocations.count < 11 {
                self.downloadCityData()
            }
            
            guard let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") else { return }
            ReservationManager.sharedInstance.checkForReservation(Date(), userID: id as! String) { result in
                switch result {
                    case .success():
                        if ReservationManager.sharedInstance.isReservationActive == 0 {
                            completion(.failure(RoadoutIntentErrors.reservationActive))
                        }
                    case .failure(let err):
                        print(err)
                        completion(.failure(RoadoutIntentErrors.failureRequiringAppLaunch))
                }
            }
            
            FunctionsManager.sharedInstance.foundSpot = nil
            DispatchQueue.main.async {
                self.locationManager = CLLocationManager()
                self.locationManager?.delegate = self
                self.locationManager?.startUpdatingLocation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if self.locationManager?.location != nil {
                        FunctionsManager.sharedInstance.sortLocations(currentLocation: (self.locationManager?.location!.coordinate)!) { success in
                            if success {
                                FunctionsManager.sharedInstance.findSpot { success in
                                    if success {
                                        completion(.success(()))
                                    } else {
                                        completion(.failure(RoadoutIntentErrors.noFreeSpot))
                                    }
                                }
                            } else {
                                completion(.failure(RoadoutIntentErrors.noFreeSpot))
                            }
                        }
                    } else {
                        completion(.failure(RoadoutIntentErrors.locationDisabled))
                    }
                }
            }
        } else {
            completion(.failure(RoadoutIntentErrors.failureRequiringAppLaunch))
        }
    }
    
    func reserveSpot(completion: @escaping(Result<Void, Error>) -> Void) {
        locationManager?.stopUpdatingLocation()
        timerSeconds = 15*60
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        ReservationManager.sharedInstance.makeReservation(Date(), time: 15, spotID: FunctionsManager.sharedInstance.foundSpot.rID, payment: 10, userID: id) { result in
            switch result {
                case .success():
                    completion(.success(()))
                case .failure(let err):
                    print("err is here: \(err)")
                    completion(.failure(RoadoutIntentErrors.failureRequiringAppLaunch))
            }
        }
    }
    
}

@available (iOS 16.0, *)
extension RoadoutIntentHelper: CLLocationManagerDelegate {
 
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.last != nil {
            let location = locations.last
            print("location:: \(location!.coordinate)")
        }

    }
}
