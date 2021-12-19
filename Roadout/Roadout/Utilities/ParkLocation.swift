//
//  ParkLocation.swift
//  Roadout
//
//  Created by David Retegan on 04.11.2021.
//

import Foundation

struct ParkLocation: Hashable, Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    let freeSpots: Int
}

