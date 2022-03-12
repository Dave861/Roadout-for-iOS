//
//  SceneDelegate.swift
//  Roadout
//
//  Created by David Retegan on 25.10.2021.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.isUserSigned") {
              let sb = UIStoryboard(name: "Home", bundle: nil)
              let vc = sb.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
              window?.rootViewController = vc
              window?.makeKeyAndVisible()
              let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
            UserManager.sharedInstance.getUserName(id) { result in
                print(result)
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
        NotificationCenter.default.post(name: .updateLocationID, object: nil)
        print(ReservationManager.sharedInstance.getReservationDate())
          
          if ReservationManager.sharedInstance.checkActiveReservation() {
              if ReservationManager.sharedInstance.reservationDate > Date() {
                  NotificationCenter.default.post(name: .showActiveBarID, object: nil)
                  ReservationManager.sharedInstance.saveActiveReservation(true)
              } else {
                  NotificationCenter.default.post(name: .showUnlockedBarID, object: nil)
                  ReservationManager.sharedInstance.saveActiveReservation(false)
              }
          }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print(ReservationManager.sharedInstance.getReservationDate())
        ReservationManager.sharedInstance.saveReservationDate((ReservationManager.sharedInstance.reservationDate))
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print(ReservationManager.sharedInstance.getReservationDate())
        if ReservationManager.sharedInstance.checkActiveReservation() {
            if ReservationManager.sharedInstance.reservationDate > Date() {
                NotificationCenter.default.post(name: .showActiveBarID, object: nil)
                ReservationManager.sharedInstance.saveActiveReservation(true)
            } else {
                NotificationCenter.default.post(name: .showUnlockedBarID, object: nil)
                ReservationManager.sharedInstance.saveActiveReservation(false)
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

