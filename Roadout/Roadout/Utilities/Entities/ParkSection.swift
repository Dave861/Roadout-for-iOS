//
//  ParkSection.swift
//  Roadout
//
//  Created by David Retegan on 27.12.2021.
//

import Foundation

struct ParkSection: Hashable, Codable {
    var name: String
    var totalSpots: Int
    var freeSpots: Int
    var rows: [Int]
    var spots: [ParkSpot]
    var rID: String
}
