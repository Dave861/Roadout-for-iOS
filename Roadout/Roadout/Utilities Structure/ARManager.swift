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
        UserDefaults.roadout!.set(true, forKey: "ro.roadout.Roadout.ARTutorialShownCount")
    }
    
    func shownTutorial() -> Bool {
        return UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.ARTutorialShownCount")
    }
    
}
