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
    
    var intentHandled = false
    
    var locationManager: CLLocationManager?

    public func confirm(intent: QuickReserveIntent, completion: @escaping (QuickReserveIntentResponse) -> Void) {
        if checkReservation() {
            completion(QuickReserveIntentResponse(code: .reservationActive, userActivity: nil))
        }
        
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
            self.locationManager?.startUpdatingLocation()
            self.locationManager?.requestLocation()
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                if self.locationManager?.location != nil {
                    FunctionsManager.sharedInstance.findSpot(self.locationManager!.location!.coordinate) { success in
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
                    completion(QuickReserveIntentResponse(code: .locationDisabled, userActivity: nil))
                }
            }
        }
    }

    public func handle(intent: QuickReserveIntent, completion: @escaping (QuickReserveIntentResponse) -> Void) {
            reserveSpot()
            locationManager?.stopUpdatingLocation()
            timerSeconds = 15*60
            if UserPrefsUtils.sharedInstance.reservationNotificationsEnabled() {
                NotificationHelper.sharedInstance.scheduleReservationNotification()
            }
            UserDefaults.roadout?.removeObject(forKey: "ro.roadout.Roadout.SiriName")
            UserDefaults.roadout?.removeObject(forKey: "ro.roadout.Roadout.SiriSection")
            UserDefaults.roadout?.removeObject(forKey: "ro.roadout.Roadout.SiriSpot")
            completion(QuickReserveIntentResponse(code: .success, userActivity: nil))
       }
    
    func checkReservation() -> Bool {
        return ReservationManager.sharedInstance.checkActiveReservation()
    }
    
    func reserveSpot() {
        ReservationManager.sharedInstance.saveReservationDate(Date().addingTimeInterval(TimeInterval(900)))
        ReservationManager.sharedInstance.saveActiveReservation(true)
    }
    
}
extension QuickReserveIntentHandler: CLLocationManagerDelegate {
 
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.last != nil {
            let location = locations.last
            print("Here2")
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
