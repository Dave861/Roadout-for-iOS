//
//  LinkController.swift
//  RWUI WatchKit Extension
//
//  Created by David Retegan on 22.05.2022.
//

import WatchKit
import WatchConnectivity
import Foundation

class LinkController: WKInterfaceController {
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(receivedUserID), name: .receivedUserOnWatchID, object: nil)
    }
    
    override func awake(withContext context: Any?) {
        self.manageObs()
    }
    
    @objc func receivedUserID() {
        self.sendMessageToIphone()
        self.dismiss()
    }
    
    func sendMessageToIphone() {
        if WCSession.default.isReachable {
            let dataToSend: [String : Any] = ["action" : "Connected User"]
            WCSession.default.sendMessage(dataToSend, replyHandler: nil) { err in
                print(err)
            }
        }
    }
    
}
