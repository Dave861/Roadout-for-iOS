//
//  SceneDelegate.swift
//  Roadout
//
//  Created by David Retegan on 25.10.2021.
//

import Foundation
import UIKit
import IOSSecuritySuite

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        if UserDefaults.roadout!.bool(forKey: "eu.roadout.Roadout.isUserSigned") {
            let homeSb = UIStoryboard(name: "Home", bundle: nil)
            let homeVC = homeSb.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
            window?.rootViewController = homeVC
            window?.makeKeyAndVisible()
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        NotificationHelper.sharedInstance.checkNotificationStatus()
        NotificationCenter.default.post(name: .updateLocationID, object: nil)
        
        //Check for reservation status
        if UserDefaults.roadout!.bool(forKey: "eu.roadout.Roadout.isUserSigned") {
            guard let id = UserDefaults.roadout!.object(forKey: "eu.roadout.Roadout.userID") else { return }
            Task {
                do {
                    try await ReservationManager.sharedInstance.checkForReservationAsync(date: Date(), userID: id as! String)
                    if ReservationManager.sharedInstance.isReservationActive == 0 {
                        //active
                        if openedByLiveActivity {
                            openedByLiveActivity = false
                            NotificationCenter.default.post(name: .addUnlockCardID, object: nil)
                        } else {
                            NotificationCenter.default.post(name: .showActiveBarID, object: nil)
                        }
                    } else if ReservationManager.sharedInstance.isReservationActive == 1 {
                        //unlocked
                        NotificationCenter.default.post(name: .showUnlockedViewID, object: nil)
                    } else if ReservationManager.sharedInstance.isReservationActive == 2 {
                        //cancelled
                        NotificationCenter.default.post(name: .showCancelledBarID, object: nil)
                    } else if ReservationManager.sharedInstance.isReservationActive == 3 {
                        //not active
                        NotificationCenter.default.post(name: .returnFromReservationID, object: nil)
                    } else {
                        //error
                        NotificationCenter.default.post(name: .returnToSearchBarWithErrorID, object: nil)
                    }
                }
            }
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if IOSSecuritySuite.amIJailbroken() || IOSSecuritySuite.amIReverseEngineered() || IOSSecuritySuite.amIProxied() {
            let mainSb = UIStoryboard(name: "Main", bundle: nil)
            let dangerVC = mainSb.instantiateViewController(withIdentifier: "DangerVC") as! DangerViewController
            window?.rootViewController = dangerVC
            window?.makeKeyAndVisible()
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let _: UIOpenURLContext = URLContexts.first(where: { $0.url.scheme == "roadout-live" }) else { return }
        if URLContexts.first?.url.absoluteString == "roadout-live://unlock" {
            openedByLiveActivity = true
        }
    }
}

