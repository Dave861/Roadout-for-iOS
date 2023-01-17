//
//  Other.swift
//  Roadout
//
//  Created by David Retegan on 16.01.2023.
//

import Foundation

struct FutureReservation: Codable {
    var place: String
    var date: Date
    var identifier: String
}

struct WorldLocation {
    var latitude: Double
    var longitude: Double
    var fov: Int
    var heading: Int
    var pitch: Int
}

struct HistoryItem {
    var parkingSpotID: String
    
    var time: Int
    var price: Float
    var date: Date
}

struct VoteOption {
    var title: String
    var description: String
    var highlightedWords: [String]
}

struct Reason {
    var description: String
    var isSelected: Bool
}
