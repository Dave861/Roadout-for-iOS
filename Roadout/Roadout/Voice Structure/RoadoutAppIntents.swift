//
//  RoadoutAppIntents.swift
//  Roadout
//
//  Created by David Retegan on 16.02.2023.
//

import AppIntents
import CoreLocation

@available(iOS 16, *)
enum RoadoutIntentErrors: Error {
    case valueZero
    case failureRequiringAppLaunch
    case locationDisabled
    case alreadyDelayed
}

@available(iOS 16, *)
struct RoadoutAppShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: RoadoutFindIntent(),
            phrases: ["Find parking with \(.applicationName)",
                      "Find somewhere to park with \(.applicationName)",
                      "Ask \(.applicationName) to find somewhere to park",
                      "Ask \(.applicationName) to find parking"]
        )
        AppShortcut(
            intent: RoadoutStatusIntent(),
            phrases: ["What's my \(.applicationName) reservation status",
                      "What's the status of my \(.applicationName) reservation",
                      "What are my \(.applicationName) reservation details",
                      "Get my \(.applicationName) reservation status",
                      "Tell me about my \(.applicationName) reservation"]
        )
        AppShortcut(
            intent: RoadoutDirectionsIntent(),
            phrases: ["Navigate to my \(.applicationName) reservation",
                      "Get directions to my \(.applicationName) reservation",
                      "Take me to my \(.applicationName) reservation",
                      "Show me directions to my \(.applicationName) reservation"]
        )
        AppShortcut(
            intent: RoadoutDelayIntent(),
            phrases: ["Delay my \(.applicationName) reservation",
                      "Add more time to my \(.applicationName) reservation",
                      "I want to delay my \(.applicationName) reservation",
                      "Add more minutes to my \(.applicationName) reservation"]
        )
        AppShortcut(
            intent: RoadoutUnlockIntent(),
            phrases: ["Unlock my \(.applicationName) reservation",
                      "Finish my \(.applicationName) reservation",
                      "I want to unlock my \(.applicationName) reservation",
                      "Unlock my \(.applicationName) parking spot"]
        )
    }
}
