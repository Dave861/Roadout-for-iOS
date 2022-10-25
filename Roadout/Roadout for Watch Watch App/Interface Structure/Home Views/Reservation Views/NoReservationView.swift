//
//  NoReservationView.swift
//  Roadout for Watch Watch App
//
//  Created by David Retegan on 23.10.2022.
//

import SwiftUI

struct NoReservationView: View {
    
    @ObservedObject var resManager: ReservationManager
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: true) {
                VStack(spacing: 5) {
                    Text("")
                    VStack(spacing: 0) {
                        Image("roadout.car")
                            .resizable()
                            .frame(width: 28, height: 23.5)
                            .foregroundColor(Color("Main Yellow"))
                        Text("No Reservation")
                            .font(.system(size: 23, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                    }
                    Text("Use the iPhone app to make a reservation")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .navigationTitle("Roadout")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

