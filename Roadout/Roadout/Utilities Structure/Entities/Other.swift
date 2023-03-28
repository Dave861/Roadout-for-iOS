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
        static var mainYellow: UIColor  { return UIColor(named: "Main Yellow")! }
    }
    struct Backgrounds {
        
    }
}
