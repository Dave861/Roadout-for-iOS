//
//  RoadoutAppIntentViews.swift
//  Roadout
//
//  Created by David Retegan on 12.11.2022.
//

import Foundation
import SwiftUI
import UIKit

struct RoadoutIntentConfirmSpotView: View {
    
    var parkLocationName: String
    var parkSectionLetter: String
    var parkSpotNumber: Int
    var distance: Double
    
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Reserve Spot")
                    .font(.system(size: 21, weight: .bold))
                HStack() {
                    Image("roadout.car")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 29, height: 18)
                        .foregroundColor(Color("Main Yellow"))
                    HStack(spacing: 0) {
                        Text(parkLocationName + " - Section ")
                            .font(.system(size: 19))
                        Text(parkSectionLetter)
                            .font(.system(size: 19, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                        Text(" - Spot ")
                            .font(.system(size: 19))
                        Text("\(parkSpotNumber)")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                    }
                    Spacer()
                }
                HStack {
                    Image(systemName: "ruler.fill")
                        .frame(width: 33, height: 28)
                        .font(.system(size: 20))
                        .foregroundColor(Color("Main Yellow"))
                    HStack(spacing: 0) {
                        Text("\(String(format: "%.2f", distance))")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                        Text(" km away")
                            .font(.system(size: 19))
                    }
                    Spacer()
                }
            }
        }
        .padding([.top, .leading, .trailing])
    }
}

struct RoadoutIntentConfirmPayView: View {
    
    var reservationMinutes: Int
    var total: Double
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Pay Reservation")
                    .font(.system(size: 21, weight: .bold))
                HStack {
                    Image(systemName: "clock.fill")
                        .frame(width: 30, height: 30)
                        .font(.system(size: 20))
                        .foregroundColor(Color("Main Yellow"))
                    HStack(spacing: 0) {
                        Text("Reserve for ")
                            .font(.system(size: 19))
                        Text("\(reservationMinutes) minutes")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                    }
                    Spacer()
                }
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(UIColor.systemGray3))
                .padding([.bottom], 5)
            HStack(alignment: .center, spacing: 0) {
                Text("Price - ")
                    .font(.system(size: 20))
                Text("\(String(format: "%.2f", total)) RON")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("Main Yellow"))
            }
        }
        .padding([.leading, .trailing, .top])
    }
}

struct RoadoutIntentSuccesView: View {
    
    var reservationTime: Date
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 15)
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color("Main Yellow"))
                Text("Active Reservation")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Text(reservationTime, style: .time)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color("Main Yellow"))
            }
            Spacer(minLength: 15)
        }
        .padding([.leading, .trailing])
        
    }
}