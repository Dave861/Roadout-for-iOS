//
//  AppDelegate.swift
//  Roadout
//
//  Created by David Retegan on 25.10.2021.
//

import UIKit
import GoogleMaps
import GooglePlaces
import WatchConnectivity

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyCGi6_yxY1g5857pCuiBoYQZYMU7dUxPGI")
        GMSPlacesClient.provideAPIKey("AIzaSyDsBR6LpKv1fNOCDM7BILZ7oj5JmYlYy64")
        ConnectionManager.sharedInstance.observeReachability()
        
        NotificationHelper.sharedInstance.checkNotificationStatus()
        self.setUpWCSession()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
extension AppDelegate: WCSessionDelegate {
    
    //Setting up the session when app launches
    func setUpWCSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
            case .activated:
                print("Activated WCSession")
                if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.isUserSigned") {
                    let data = [
                        "action" : "UserID",
                        "userID" : UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
                    ]
                    WCSession.default.sendMessage(data, replyHandler: nil)
                }
            case .inactive:
                print("Inactivated WCSession" + (error?.localizedDescription ?? ""))
            case .notActivated:
                print("Not Activated WCSession" + (error?.localizedDescription ?? ""))
            @unknown default:
                print("UNKNOWN WC STATE")
        }
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //Manage when/if needed
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //Manage when/if needed
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if message["action"] as? String == "Refresh Reservation" {
            guard let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") else { return }
            Task {
                do {
                    try await ReservationManager.sharedInstance.checkForReservationAsync(date: Date(), userID: id as! String)
                    if ReservationManager.sharedInstance.isReservationActive == 0 {
                        //active
                        NotificationCenter.default.post(name: .showActiveBarID, object: nil)
                    } else if ReservationManager.sharedInstance.isReservationActive == 1 {
                        //unlocked
                        NotificationCenter.default.post(name: .showUnlockedViewID, object: nil)
                    } else if ReservationManager.sharedInstance.isReservationActive == 2 {
                        //cancelled
                        NotificationCenter.default.post(name: .showCancelledBarID, object: nil)
                    } else if ReservationManager.sharedInstance.isReservationActive == 3 {
                        //not active
                        NotificationCenter.default.post(name: .returnToSearchBarID, object: nil)
                    } else {
                        //error
                        NotificationCenter.default.post(name: .returnToSearchBarWithErrorID, object: nil)
                    }
                } catch let err {
                    print(err)
                }
            }
        } else if message["action"] as? String == "Send UserID" {
            if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.isUserSigned") {
                let data = [
                    "action" : "UserID",
                    "userID" : UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
                ]
                WCSession.default.sendMessage(data, replyHandler: nil)
            }
        }
    }
    
}

