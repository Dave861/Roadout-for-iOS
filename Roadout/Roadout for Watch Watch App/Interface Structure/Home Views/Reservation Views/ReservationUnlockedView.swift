//
//  ReservationUnlockedView.swift
//  Roadout for Watch Watch App
//
//  Created by David Retegan on 23.10.2022.
//

import SwiftUI

struct ReservationUnlockedView: View {
    
    @ObservedObject var resManager: ReservationManager
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: true) {
                VStack(spacing: 5) {
                    Text("")
                    HStack {
                        Image(systemName: "lock.open.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color("Main Yellow"))
                        Text("Unlocked")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                    }
                    VStack(spacing: 0) {
                        Text("21 Decembrie")
                            .font(.system(size: 20))
                        Text("Section ")
                            .font(.system(size: 20))
                        + Text("A")
                            .font(.system(size: 20))
                            .foregroundColor(Color("Main Yellow"))
                        + Text(" - Spot ")
                            .font(.system(size: 20))
                        + Text("12")
                            .font(.system(size: 20))
                            .foregroundColor(Color("Main Yellow"))
                    }
                    Button("Done") {
                        resManager.isReservationActive = 3
                        Task {
                            do {
                                try await resManager.getReservationDataAsync(Date(), userID: UserDefaults.roadout.string(forKey: "ro.roadout.Roadout.userID")!)
                            }
                        }
                    }
                    .padding(.top)
                    .tint(Color("Main Yellow"))
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.black)
                }
            }
            .navigationTitle("Roadout")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

