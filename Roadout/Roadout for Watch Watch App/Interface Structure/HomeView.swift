//
//  ContentView.swift
//  Roadout for Watch Watch App
//
//  Created by David Retegan on 23.10.2022.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var userManager: UserManager
    @ObservedObject var resManager: ReservationManager
    @ObservedObject var wcManager: WCManager
    
    var body: some View {
        TabView {
            ReservationView(resManager: resManager)
            SettingsView(userManager: userManager, wcManager: wcManager)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                Task {
                    do {
                        try await resManager.getReservationDataAsync(Date(), userID: UserDefaults.roadout.string(forKey: "ro.roadout.Roadout.userID")!)
                    }
                }
            }
        }
    }
}
