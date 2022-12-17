//
//  SceneDelegate.swift
//  Roadout
//
//  Created by David Retegan on 25.10.2021.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IOSSecuritySuite
import WatchConnectivity

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.isUserSigned") {
            let homeSb = UIStoryboard(name: "Home", bundle: nil)
            let homeVC = homeSb.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
            window?.rootViewController = homeVC
            window?.makeKeyAndVisible()
    
            let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
            Task {
                do {
                    try await UserManager.sharedInstance.getUserNameAsync(id)
                } catch let err {
                    print(err)
                }
            }
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        NotificationHelper.sharedInstance.checkNotificationStatus()
        NotificationCenter.default.post(name: .updateLocationID, object: nil)
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.isUserSigned") {
            guard let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") else { return }
            //Send user ID to Apple Watch if reachable
            if WCSession.isSupported() && WCSession.default.isReachable {
                let data = [
                    "action" : "UserID",
                    "userID" : UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
                ]
                WCSession.default.sendMessage(data, replyHandler: nil)
            }
            Task {
                do {
                    try await ReservationManager.sharedInstance.checkForReservationAsync(date: Date(), userID: id as! String)
                    if ReservationManager.sharedInstance.isReservationActive == 0 {
                        //active
                        NotificationCenter.default.post(name: .showActiveBarID, object: nil)
                    } else if ReservationManager.sharedInstance.isReservationActive == 1 {
                        //unlocked
                        //do nothing, keep current state
                    } else if ReservationManager.sharedInstance.isReservationActive == 2 {
                        //cancelled
                        NotificationCenter.default.post(name: .showCancelledBarID, object: nil)
                    } else if ReservationManager.sharedInstance.isReservationActive == 4 {
                        //located
                        //update timer and show screen if not shown
                    }else {
                        //error or not active
                        //do nothing, keep current state
                    }
                }
            }
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if IOSSecuritySuite.amIJailbroken() || IOSSecuritySuite.amIReverseEngineered() || IOSSecuritySuite.amIProxied() {
            let mainSb = UIStoryboard(name: "Main", bundle: nil)
            let dangerVC = mainSb.instantiateViewController(withIdentifier: "DangerVC") as! DangerViewController
            window?.rootViewController = dangerVC
            window?.makeKeyAndVisible()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

