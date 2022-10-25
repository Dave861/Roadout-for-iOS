//
//  ErrorReservationView.swift
//  Roadout for Watch Watch App
//
//  Created by David Retegan on 23.10.2022.
//

import SwiftUI

struct ErrorReservationView: View {
    
    @ObservedObject var resManager: ReservationManager
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: true) {
                VStack(spacing: 5) {
                    Text("")
                    VStack(spacing: 3) {
                        Image(systemName: "xmark")
                            .font(.system(size: 27, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                        Text("Error")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                    }
                    Text("There was an error retrieving your reservation data, please check in the iPhone app")
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

