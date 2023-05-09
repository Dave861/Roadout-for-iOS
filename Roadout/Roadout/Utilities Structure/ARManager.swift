//
//  ARManager.swift
//  Roadout
//
//  Created by David Retegan on 17.12.2022.
//

import Foundation

class ARManager {
    
    enum ARHelpMode {
        case info
        case questions
    }
    
    static let sharedInstance = ARManager()
    
    private init() {}
    
    var helpMode: ARHelpMode = .info
    
    func markTutorial() {
        UserDefaults.roadout!.set(true, forKey: "eu.roadout.Roadout.ARTutorialShownCount")
    }
    
    func shownTutorial() -> Bool {
        return UserDefaults.roadout!.bool(forKey: "eu.roadout.Roadout.ARTutorialShownCount")
    }
    
}
