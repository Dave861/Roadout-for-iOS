//
//  ParkLocation.swift
//  Roadout
//
//  Created by David Retegan on 04.11.2021.
//

import Foundation

struct ParkLocation: Hashable, Codable {
    var name: String
    var rID: String
    var latitude: Double
    var longitude: Double
    var totalSpots: Int
    var freeSpots: Int
    var sections: [ParkSection]
    var sectionImage: String
    var accentColor: String
}

var parkLocations = [
    ParkLocation(name: "Buna Ziua", rID: "Cluj.BunaZiua", latitude: 46.752207, longitude: 23.603324, totalSpots: 81, freeSpots: 42, sections: sections1, sectionImage: "Cluj.BunaZiua.Section", accentColor: colours.randomElement()!),
        ParkLocation(name: "Airport", rID: "Cluj.Airport", latitude: 46.781864, longitude: 23.671744, totalSpots: 94, freeSpots: 51, sections: sections2, sectionImage: "Cluj.Airport.Section", accentColor: colours.randomElement()!)
    ]

var dbParkLocations = [ParkLocation]()

var testParkLocations = [
        ParkLocation(name: "Buna Ziua", rID: "Cluj.BunaZiua", latitude: 46.752207, longitude: 23.603324, totalSpots: 81, freeSpots: 42, sections: sections1, sectionImage: "Cluj.BunaZiua.Section", accentColor: colours.randomElement()!),
        ParkLocation(name: "Airport", rID: "Cluj.Airport", latitude: 46.781864, longitude: 23.671744, totalSpots: 94, freeSpots: 51, sections: sections2, sectionImage: "Cluj.Airport.Section", accentColor: colours.randomElement()!)
]
