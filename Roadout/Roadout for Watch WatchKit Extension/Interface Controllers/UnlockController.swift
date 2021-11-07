//
//  UnlockController.swift
//  Roadout for Watch WatchKit Extension
//
//  Created by David Retegan on 06.11.2021.
//

import WatchKit
import Foundation


class UnlockController: WKInterfaceController {

    @IBAction func unlockTapped() {
        let rootControllerIdentifier = "UnlockedVC"
        WKInterfaceController.reloadRootControllers(withNamesAndContexts: [(name: rootControllerIdentifier, context: [:] as AnyObject)])
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
