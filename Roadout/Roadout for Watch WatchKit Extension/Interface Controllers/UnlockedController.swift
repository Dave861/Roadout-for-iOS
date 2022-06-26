//
//  UnlockedController.swift
//  RWUI WatchKit Extension
//
//  Created by David Retegan on 23.05.2022.
//

import WatchKit
import Foundation
import WatchConnectivity

class UnlockedController: WKInterfaceController {
    
    @IBOutlet weak var doneGroup: WKInterfaceGroup!
    
    @IBAction func doneTapped() {
        NotificationCenter.default.post(name: .reloadServerDataAWID, object: nil)
        self.dismiss()
    }
    
    override func awake(withContext context: Any?) {
        self.doneGroup.setCornerRadius(20)
    }
    
    override func didAppear() {
        sendMessageToiPhone()
    }
    
    func sendMessageToiPhone() {
        if WCSession.default.isReachable {
            let dataToSend: [String : Any] = ["action" : "Refresh Reservation"]
            WCSession.default.sendMessage(dataToSend, replyHandler: nil) { err in
                print(err)
            }
        }
    }
        
}

