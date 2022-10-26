//
//  SettingsView.swift
//  Roadout for Watch Watch App
//
//  Created by David Retegan on 23.10.2022.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var userManager: UserManager
    @ObservedObject var wcManager: WCManager
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: true) {
                VStack(spacing: 5) {
                    Text("")
                    VStack(spacing: 3) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 27, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                        Text($userManager.userName.wrappedValue)
                            .font(.system(size: 23, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                    }
                    Text("Open the iPhone app for more options")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                    Button("Sign Out") {
                        UserDefaults.roadout.removeObject(forKey: "ro.roadout.Roadout.userID")
                        wcManager.userID = nil
                    }
                    .padding(.top)
                    .tint(Color("Main Yellow"))
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.black)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                userManager.getUserName(UserDefaults.roadout.string(forKey: "ro.roadout.Roadout.userID")!) { result in
                    switch result {
                        case .success():
                            print("User Name retrieved succesfully")
                        case .failure(let err):
                            print(err)
                    }
                }
            }
        }
    }
}
