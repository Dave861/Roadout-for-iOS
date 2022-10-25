//
//  Roadout_for_WatchApp.swift
//  Roadout for Watch Watch App
//
//  Created by David Retegan on 23.10.2022.
//

import SwiftUI

@main
struct Roadout_for_Watch_Watch_AppApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var resManager = ReservationManager()
    @ObservedObject var wcManager = WCManager()
    @ObservedObject var userManager = UserManager()
    
    var body: some Scene {
        WindowGroup {
            if $wcManager.userID.wrappedValue == nil {
                NoAccountView()
                    .onChange(of: scenePhase) { newPhase in
                        if newPhase == .active {
                            wcManager.requestUserID(maxRetries: 3)
                        }
                    }
            } else {
                HomeView(userManager: userManager, resManager: resManager, wcManager: wcManager)
            }
        }
        
    }
}
