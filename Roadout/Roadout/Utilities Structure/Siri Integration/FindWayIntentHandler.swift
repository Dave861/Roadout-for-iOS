//
//  QuickReserveIntentHandler.swift
//  Roadout
//
//  Created by David Retegan on 30.11.2021.
//

import Foundation
import Intents
import CoreLocation

public class QuickReserveIntentHandler: NSObject, QuickReserveIntentHandling {
        
    var locationManager: CLLocationManager?

    public func confirm(intent: QuickReserveIntent, completion: @escaping (QuickReserveIntentResponse) -> Void) {
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.isUserSigned") {
            if parkLocations.count < 11 {
                self.downloadCityData()
            }
            
            guard let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") else { return }
            ReservationManager.sharedInstance.checkForReservation(Date(), userID: id as! String) { result in
                switch result {
                    case .success():
                        if ReservationManager.sharedInstance.isReservationActive == 0 {
                            completion(QuickReserveIntentResponse(code: .reservationActive, userActivity: nil))
                        }
                    case .failure(let err):
                        print(err)
                        completion(QuickReserveIntentResponse(code: .failureRequiringAppLaunch, userActivity: nil))
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
                                        UserDefaults.roadout?.set(FunctionsManager.sharedInstance.foundLocation.name, forKey: "ro.roadout.Roadout.SiriName")
                                        UserDefaults.roadout?.set(FunctionsManager.sharedInstance.foundSection.name, forKey: "ro.roadout.Roadout.SiriSection")
                                        UserDefaults.roadout?.set(FunctionsManager.sharedInstance.foundSpot.number, forKey: "ro.roadout.Roadout.SiriSpot")
                                        completion(QuickReserveIntentResponse(code: .ready, userActivity: nil))
                                    } else {
                                        completion(QuickReserveIntentResponse(code: .noSpotFound, userActivity: nil))
                                    }
                                }
                            } else {
                                completion(QuickReserveIntentResponse(code: .noSpotFound, userActivity: nil))
                            }
                        }
                    } else {
                        completion(QuickReserveIntentResponse(code: .locationDisabled, userActivity: nil))
                    }
                }
            }
        } else {
            completion(QuickReserveIntentResponse(code: .failureRequiringAppLaunch, userActivity: nil))
        }
    }

    public func handle(intent: QuickReserveIntent, completion: @escaping (QuickReserveIntentResponse) -> Void) {
            locationManager?.stopUpdatingLocation()
            timerSeconds = 15*60
            let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
            ReservationManager.sharedInstance.makeReservation(Date(), time: 15, spotID: FunctionsManager.sharedInstance.foundSpot.rID, payment: 10, userID: id) { result in
                switch result {
                    case .success():
                        print("WE RESERVED")
                        completion(QuickReserveIntentResponse(code: .success, userActivity: nil))
                    case .failure(let err):
                        print("err is here: \(err)")
                        completion(QuickReserveIntentResponse(code: .failureRequiringAppLaunch, userActivity: nil))
                }
            }
            UserDefaults.roadout?.removeObject(forKey: "ro.roadout.Roadout.SiriName")
            UserDefaults.roadout?.removeObject(forKey: "ro.roadout.Roadout.SiriSection")
            UserDefaults.roadout?.removeObject(forKey: "ro.roadout.Roadout.SiriSpot")
       }
    
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
    
}
extension QuickReserveIntentHandler: CLLocationManagerDelegate {
 
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.last != nil {
            let location = locations.last
            print("location:: \(location!.coordinate)")
        }

    }
}
class SiriDataManager {
    
    static let sharedInstance = SiriDataManager()
    
    var parkName = UserDefaults.roadout?.string(forKey: "ro.roadout.Roadout.SiriName") ?? "-----"
    var parkSection = UserDefaults.roadout?.string(forKey: "ro.roadout.Roadout.SiriSection") ?? "-"
    var parkSpot = UserDefaults.roadout?.integer(forKey: "ro.roadout.Roadout.SiriSpot") ?? 0
    
}
