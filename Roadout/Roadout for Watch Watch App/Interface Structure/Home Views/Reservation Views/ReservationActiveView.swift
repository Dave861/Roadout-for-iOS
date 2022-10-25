//
//  ReservationActiveView.swift
//  Roadout for Watch Watch App
//
//  Created by David Retegan on 23.10.2022.
//

import SwiftUI

struct ReservationActiveView: View {
    
    @ObservedObject var resManager: ReservationManager
    
    @State var showingUnlockAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: true) {
                VStack(spacing: 5) {
                    Text("")
                    HStack {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color("Main Yellow"))
                        Text("13:45")
                            .font(.system(size: 35, weight: .medium))
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
                    Button("Unlock") {
                        showingUnlockAlert.toggle()
                    }
                    .padding(.top)
                    .tint(Color("Main Yellow"))
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.black)
                    .alert("Are you sure you want to unlock the spot?", isPresented: $showingUnlockAlert) {
                        Button("Unlock") {
                            showingUnlockAlert.toggle()
                            resManager.unlockReservation()
                            //if success
                            resManager.isReservationActive = 1
                        }
                        Button("Cancel", role: .cancel, action: {})
                    }
                }
            }
            .navigationTitle("Roadout")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}
