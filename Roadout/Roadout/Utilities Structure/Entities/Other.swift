//
//  Other.swift
//  Roadout
//
//  Created by David Retegan on 16.01.2023.
//

import Foundation
import UIKit

struct FutureReservation: Codable {
    var place: String
    var date: Date
    var identifier: String
}

struct HistoryReservation {
    var parkingSpotID: String
    var time: Int
    var price: Float
    var date: Date
}

struct WorldLocation {
    var latitude: Double
    var longitude: Double
    var fov: Int
    var heading: Int
    var pitch: Int
}

struct RateReason {
    var description: String
    var isSelected: Bool
}

extension UIColor {
    struct Roadout {
        static var mainYellow = UIColor(named: "Main Yellow")!
        static var secondOrange = UIColor(named: "Second Orange")!//here
        static var darkOrange = UIColor(named: "Dark Orange")!
        static var brownish = UIColor(named: "Brownish")!
        static var darkYellow = UIColor(named: "Dark Yellow")!
        static var cashYellow = UIColor(named: "Cash Yellow")!
        static var devBrown = UIColor(named: "DevBrown")!
        static var expressFocus = UIColor(named: "ExpressFocus")!
        static var goldBrown = UIColor(named: "GoldBrown")!
        static var greyish = UIColor(named: "Greyish")!
        static var icons = UIColor(named: "Icons")!
        static var kindaRed = UIColor(named: "Kinda Red")!
        static var redish = UIColor(named: "Redish")!
        static var limey = UIColor(named: "Limey")!
    }
}
