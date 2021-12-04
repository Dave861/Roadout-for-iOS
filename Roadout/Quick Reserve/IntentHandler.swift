//
//  IntentHandler.swift
//  Quick Reserve
//
//  Created by David Retegan on 30.11.2021.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        
        guard intent is QuickReserveIntent else {
            print("Error!!! Unrecognized intent!!!")
            fatalError()
        }
        
        return QuickReserveIntentHandler()
    }
    
}
