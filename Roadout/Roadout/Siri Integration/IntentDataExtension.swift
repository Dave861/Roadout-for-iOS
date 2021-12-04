//
//  IntentDataExtension.swift
//  Roadout
//
//  Created by David Retegan on 30.11.2021.
//

import Foundation
import Intents

extension NSUserActivity {
    
    public static let quickReserveActivityType = "ro.roadout.Roadout.quickReserve"
    
    public static var quickReserveActivity: NSUserActivity {
        let userActivity = NSUserActivity(activityType: NSUserActivity.quickReserveActivityType)
        
        userActivity.title = "Quick Reserve"
        userActivity.persistentIdentifier = NSUserActivityPersistentIdentifier(NSUserActivity.quickReserveActivityType)
        userActivity.isEligibleForPrediction = true
        userActivity.suggestedInvocationPhrase = "Find me a parking spot"
        
        return userActivity
    }
    
    
}
