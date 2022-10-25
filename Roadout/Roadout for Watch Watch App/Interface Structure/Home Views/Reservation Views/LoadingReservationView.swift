//
//  LoadingReservationView.swift
//  Roadout for Watch Watch App
//
//  Created by David Retegan on 23.10.2022.
//

import SwiftUI

struct LoadingReservationView: View {
    
    @ObservedObject var resManager: ReservationManager
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: true) {
                VStack(spacing: 5) {
                    Text("")
                    VStack(spacing: 3) {
                        Image(systemName: "rays")
                            .font(.system(size: 27, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                        Text("Loading")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                    }
                    Text("Please wait while we are loading your reservation data")
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

