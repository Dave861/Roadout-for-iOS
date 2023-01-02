//
//  Roadout_Live_Activity.swift
//  Roadout Live Activity
//
//  Created by David Retegan on 31.12.2022.
//

import WidgetKit
import SwiftUI
import ActivityKit
import UIKit

@main
struct RoadoutReservationActivityWidget: Widget {
        
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RoadoutReservationAttributes.self) { context in
            LockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    DILeadingView(context: context)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    DITrailingView(context: context)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    DIBottonView(context: context)
                }
            } compactLeading: {
                Image("roadoutcar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
            } compactTrailing: {
                Text(timerInterval: context.state.endTime, countsDown: true)
                    .multilineTextAlignment(.center)
                    .frame(width: 45)
                    .foregroundColor(Color("Main Yellow"))
            } minimal: {
                Image("roadoutcar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
            }
            .keylineTint(Color("Main Yellow"))
        }
        
    }
}
//MARK: -Dynamic Island-
struct DILeadingView: View {
    
    var context: ActivityViewContext<RoadoutReservationAttributes>
    
    var body: some View {
        Text("Roadout")
            .font(.system(size: 22, weight: .bold))
            .padding(.top, 5)
        HStack(spacing: 6) {
            Image("roadoutcar")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
            Text("Parking")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(Color("Main Yellow"))
        }
        .dynamicIsland(verticalPlacement: .belowIfTooWide)
    }
}

struct DITrailingView: View {
    
    var context: ActivityViewContext<RoadoutReservationAttributes>
    
    var body: some View {
        Text(timerInterval: context.state.endTime, countsDown: true)
            .multilineTextAlignment(.trailing)
            .foregroundColor(Color("Main Yellow"))
            .font(.system(size: 30, weight: .medium))
            .padding(.bottom, 3)
        HStack(spacing: 0) {
            Text("Section ")
                .font(.system(size: 17, weight: .regular))
            Text(context.attributes.parkSpotID.decodeSpotID()[1])
                .foregroundColor(Color("Main Yellow"))
                .font(.system(size: 17, weight: .medium))
            Text(" - Spot ")
                .font(.system(size: 17, weight: .regular))
            Text(context.attributes.parkSpotID.decodeSpotID()[2])
                .foregroundColor(Color("Main Yellow"))
                .font(.system(size: 17, weight: .medium))
        }
        .dynamicIsland(verticalPlacement: .belowIfTooWide)
    }
}

struct DIBottonView: View {
    
    var context: ActivityViewContext<RoadoutReservationAttributes>
    
    var body: some View {
        Link(destination: URL(string: "roadout-live://unlock")!) {
            Button {} label: {
                HStack {
                    Spacer()
                    Label("Unlock Spot", systemImage: "lock.fill")
                        .frame(height: 44)
                        .font(.system(size: 18, weight: .medium))
                    Spacer()
                }
            }
            .tint(Color("Main Yellow"))
            .buttonStyle(.bordered)
            .frame(height: 44)
            .cornerRadius(22.5)
        }
    }
}
//MARK: -LockScreen-
struct LockScreenView: View {
    
    var context: ActivityViewContext<RoadoutReservationAttributes>
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("Background"))
            VStack(spacing: 5) {
                VStack(spacing: 0) {
                    HStack(alignment: .center) {
                        Text("Roadout")
                            .font(.system(size: 22, weight: .bold))
                        Spacer()
                        Text(timerInterval: context.state.endTime, countsDown: true)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(Color("Main Yellow"))
                            .font(.system(size: 30, weight: .medium))
                        
                    }
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 6)
                }
                .padding([.top, .leading, .trailing])
                ZStack {
                    Rectangle()
                        .foregroundColor(Color("Secondary Yellow"))
                    HStack(spacing: 0) {
                        Image("roadoutcar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                        Text("Parking")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                            .padding(.leading, 6)
                        Spacer()
                        Text("Section ")
                            .font(.system(size: 17, weight: .regular))
                        Text(context.attributes.parkSpotID.decodeSpotID()[1])
                            .foregroundColor(Color("Main Yellow"))
                            .font(.system(size: 17, weight: .medium))
                        Text(" - Spot ")
                            .font(.system(size: 17, weight: .regular))
                        Text(context.attributes.parkSpotID.decodeSpotID()[2])
                            .foregroundColor(Color("Main Yellow"))
                            .font(.system(size: 17, weight: .medium))
                    }
                    .padding([.leading, .trailing])
                    .padding([.top, .bottom], 13)
                }
            }
            .activityBackgroundTint(Color("Main Yellow"))
        }
    }
}
extension String {
    func camelCaseToWords() -> String {
        return unicodeScalars.dropFirst().reduce(String(prefix(1))) {
            return CharacterSet.uppercaseLetters.contains($1)
            ? $0 + " " + String($1)
            : $0 + String($1)
        }
    }
    
    func decodeSpotID() -> [String] {
        var details = [String]()
        details = self.components(separatedBy: ".")
        details.remove(at: 0)
        details[0] = details[0].camelCaseToWords()
        return details
    }
}

