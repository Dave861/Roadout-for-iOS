//
//  SpotsView.swift
//  Roadout
//
//  Created by David Retegan on 24.12.2021.
//

import SwiftUI
import GroupActivities
import UIKit

@available (iOS 15.0, *)
struct Spot: Identifiable {
    let id = UUID()
    
    let number: Int
    let section: String
}

@available (iOS 15.0, *)
struct SpotRow: View {
    var spot: Spot

    var body: some View {
        HStack {
            ZStack {
                Text("\(spot.number)")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color(UIColor(named: "Redish")!))
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(UIColor(named: "Redish")!))
                    .opacity(0.4)
                    .frame(width: 60, height: 40, alignment: .leading)
            }
            .padding(.leading, 5.0)
            Text("Section " + spot.section)
                .font(.system(size: 18, weight: .medium))
                .padding(.leading, 3.0)
            Spacer()
            VStack {
                Spacer()
                Text("13 km")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
                    .padding(.bottom, 10.0)
                    .frame(alignment: .bottomLeading)
            }
            .padding(.trailing, 8.0)
        }
        .frame(height: 60)
        .background {
            RoundedRectangle(cornerRadius: 12.0)
                .foregroundColor(Color(UIColor(named: "Secondary Detail")!))
                .frame(width: UIScreen.screenWidth-36, alignment: .center)
        }
    }
}

@available (iOS 15.0, *)
struct GroupSpotsView: View {

    @ObservedObject var session = SharePlayManager.sharedInstance.groupSession!
    
    @State var spots = [
        Spot(number: 11, section: "A"),
        Spot(number: 12, section: "A"),
        Spot(number: 13, section: "A"),
        Spot(number: 1, section: "B"),
        Spot(number: 2, section: "B"),
        Spot(number: 3, section: "B"),
        Spot(number: 4, section: "B"),
        Spot(number: 5, section: "B")
    ]
    
    var body: some View {
        VStack {
            VStack {
                ForEach((0..<session.activeParticipants.count), id: \.self) { i in
                    SpotRow(spot: spots[i])
                        .padding(.bottom, 4.0)
                        .onTapGesture {
                    
                        }
                }
            }
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "person.2.fill")
                    .foregroundColor(Color(UIColor(named: "Redish")!))
                    .font(.system(size: 17, weight: .medium))
                Text("People: \(session.activeParticipants.count)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(UIColor(named: "Redish")!))
                    
            }
            .padding(.trailing, 10)
        }
        .background(Color(UIColor(named: "Second Background")!))
    }
}
@available (iOS 15.0, *)
struct GroupSpotsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSpotsView()
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
