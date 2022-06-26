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
    
    @IBOutlet weak var infoGroup: WKInterfaceGroup!
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(receivedUserID), name: .receivedUserOnWatchID, object: nil)
    }
    
    override func awake(withContext context: Any?) {
        self.manageObs()
        self.infoGroup.setCornerRadius(15.8)
    }
    
    @objc func receivedUserID() {
        self.sendMessageToIphone()
        WKInterfaceController.reloadRootPageControllers(withNames: ["HomeWKI", "SettingsWKI"], contexts: nil, orientation: .horizontal, pageIndex: 0)
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
