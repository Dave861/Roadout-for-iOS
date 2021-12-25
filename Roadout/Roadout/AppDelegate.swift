//
//  AppDelegate.swift
//  Roadout
//
//  Created by David Retegan on 25.10.2021.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let showActiveBarID = "ro.roadout.Roadout.showActiveBarID"
    let showUnlockedBarID = "ro.roadout.Roadout.showUnlockedBarID"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyCGi6_yxY1g5857pCuiBoYQZYMU7dUxPGI")
        ConnectionManager.sharedInstance.observeReachability()
        
        print(ReservationManager.sharedInstance.getReservationDate())
        
        if ReservationManager.sharedInstance.checkActiveReservation() {
            if ReservationManager.sharedInstance.reservationDate > Date() {
                NotificationCenter.default.post(name: Notification.Name(showActiveBarID), object: nil)
                ReservationManager.sharedInstance.saveActiveReservation(true)
            } else {
                NotificationCenter.default.post(name: Notification.Name(showUnlockedBarID), object: nil)
                ReservationManager.sharedInstance.saveActiveReservation(false)
            }
        }
        
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

