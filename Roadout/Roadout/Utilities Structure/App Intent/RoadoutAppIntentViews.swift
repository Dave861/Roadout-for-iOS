//
//  RoadoutAppIntentViews.swift
//  Roadout
//
//  Created by David Retegan on 12.11.2022.
//

import Foundation
import SwiftUI

struct RoadoutIntentConfirmView: View {
    
    var parkLocationName: String
    var parkSectionLetter: String
    var parkSpotNumber: Int
    var reservationMinutes: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading,spacing: 2) {
                HStack {
                    Image("IntentCarIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 27)
                    HStack(spacing: 0) {
                        Text(parkLocationName + " - Section ")
                            .font(.system(size: 17))
                        Text(parkSectionLetter)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(Color("Icons"))
                        Text(" - Spot ")
                            .font(.system(size: 17))
                        Text("\(parkSpotNumber)")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(Color("Icons"))
                    }
                }
                HStack {
                    Image(systemName: "clock")
                        .frame(width: 30, height: 30)
                        .font(.system(size: 20))
                        .foregroundColor(Color("Icons"))
                    HStack(spacing: 0) {
                        Text("Reserve for ")
                            .font(.system(size: 17))
                        Text("\(reservationMinutes) minutes")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(Color("Icons"))
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .padding([.leading, .top])
    }
}

struct RoadoutIntentSuccesView: View {
    var reservationTime: Date
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 15)
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 23))
                    .foregroundColor(Color("Icons"))
                Text("Active Reservation")
                    .font(.system(size: 17))
                Spacer()
                Text(reservationTime, style: .time)
                    .font(.system(size: 21, weight: .medium))
                    .foregroundColor(Color("Icons"))
            }
            Spacer(minLength: 15)
        }
        .padding([.leading, .trailing])
        
    }
}
