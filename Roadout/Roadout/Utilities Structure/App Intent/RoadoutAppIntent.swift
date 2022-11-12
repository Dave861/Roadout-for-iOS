//
//  RoadoutAppIntent.swift
//  RoadoutAppIntent
//
//  Created by David Retegan on 12.11.2022.
//

import AppIntents
import UIKit
import CoreLocation

@available(iOS 16, *)
enum RoadoutIntentErrors: Error {
    case valueZero
    case noFreeSpot
    case reservationActive
    case failureRequiringAppLaunch
    case noSpotFound
    case locationDisabled
}

@available(iOS 16, *)
struct RoadoutAppShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: RoadoutAppIntent(),
            phrases: ["Ask \(.applicationName) to find somewhere to park",
                      "Ask \(.applicationName) to find parking",
                      "Find parking with \(.applicationName)",
                      "Find somewhere to park with \(.applicationName)"]
        )
    }
}

@available(iOS 16, *)
struct RoadoutAppIntent: AppIntent {
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
        } catch let err {
            throw err
        }
         var findingErrorEncountered = false
         await RoadoutIntentHelper.sharedInstance.performFind { result in
             switch result {
             case .success():
                 print(FunctionsManager.sharedInstance.foundLocation.name)
                 
             case .failure(let err):
                 print(err)
                 findingErrorEncountered = true
             }
         }
         if findingErrorEncountered {
             throw RoadoutIntentErrors.failureRequiringAppLaunch
         }
        
        try await requestConfirmation(
              result: .result(
                dialog: "Ready to reserve for 15 RON?",
                view: RoadoutIntentConfirmView(
                    parkLocationName: FunctionsManager.sharedInstance.foundLocation.name,
                    parkSectionLetter: FunctionsManager.sharedInstance.foundSection.name,
                    parkSpotNumber: FunctionsManager.sharedInstance.foundSpot.number,
                    reservationMinutes: reservationMinutes)
              ),
              confirmationActionName: .request
            )
         
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
    }
}

@available(iOS 16, *)
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
    
    func performFind(completion: @escaping(Result<Void, Error>) -> Void) async {
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.isUserSigned") {
            if parkLocations.count == 1 {
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
        } else {
            completion(.failure(RoadoutIntentErrors.failureRequiringAppLaunch))
        }
    }
    
    func reserveSpot(completion: @escaping(Result<Void, Error>) -> Void) async {
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
            print("new location: \(location!.coordinate)")
        }
    }
}

