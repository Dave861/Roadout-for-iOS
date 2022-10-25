//
//  WCManager.swift
//  Roadout for Watch Watch App
//
//  Created by David Retegan on 23.10.2022.
//

import Foundation
import WatchConnectivity

class WCManager: NSObject, ObservableObject {
    
    @Published var userID = UserDefaults.roadout.string(forKey: "ro.roadout.Roadout.userID")
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func requestUserID(maxRetries: Int) {
        if maxRetries > 0 {
            if WCSession.default.isReachable {
                let dataToSend: [String : Any] = ["action" : "Send UserID"]
                WCSession.default.sendMessage(dataToSend, replyHandler: nil) { err in
                    print(err)
                }
                print("sent")
            } else {
                print("unreachable")
                self.requestUserID(maxRetries: maxRetries-1)
            }
        }
    }
    
}
extension WCManager: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            print("active WC")
        } else {
            print(error?.localizedDescription as Any)
        }
        DispatchQueue.main.async {
            self.requestUserID(maxRetries: 3)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if message["action"] as! String == "UserID" {
                if message["userID"] as? String == "none" {
                    self.userID = nil
                    UserDefaults.roadout.removeObject(forKey: "ro.roadout.Roadout.userID")
                } else {
                    self.userID = message["userID"] as? String
                    UserDefaults.roadout.set(self.userID, forKey: "ro.roadout.Roadout.userID")
                    
                }
            } else {
                print(message["action"] as! String)
            }
        }
    }
    
}

