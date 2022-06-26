//
//  WCManager.swift
//  Roadout
//
//  Created by David Retegan on 26.12.2021.
//

import Foundation
import WatchConnectivity

class WCManager: NSObject, WCSessionDelegate {
    
    static let sharedInstance = WCManager()
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
         
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
         
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
         
    }
    
}
