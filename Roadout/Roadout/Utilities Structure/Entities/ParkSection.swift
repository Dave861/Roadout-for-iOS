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
    var imagePoint: ParkSectionImagePoint
    var rID: String
}

struct ParkSectionImagePoint: Hashable, Codable {
    var x: Int
    var y: Int
}

let sections1 = [
    ParkSection(name: "A", totalSpots: 15, freeSpots: 8, rows: [7, 8], spots: localParkSpots, imagePoint: ParkSectionImagePoint(x: 29, y: 27), rID: ""),
    ParkSection(name: "B", totalSpots: 11, freeSpots: 6, rows: [6, 5], spots: localParkSpots, imagePoint: ParkSectionImagePoint(x: 51, y: 30), rID: ""),
    ParkSection(name: "C", totalSpots: 16, freeSpots: 8, rows: [8, 8], spots: localParkSpots, imagePoint: ParkSectionImagePoint(x: 72, y: 29), rID: ""),
    ParkSection(name: "D", totalSpots: 13, freeSpots: 7, rows: [6, 7], spots: localParkSpots, imagePoint: ParkSectionImagePoint(x: 30, y: 68), rID: ""),
    ParkSection(name: "E", totalSpots: 12, freeSpots: 5, rows: [3, 9], spots: localParkSpots, imagePoint: ParkSectionImagePoint(x: 51, y: 70), rID: ""),
    ParkSection(name: "F", totalSpots: 14, freeSpots: 8, rows: [8, 6], spots: localParkSpots, imagePoint: ParkSectionImagePoint(x: 72, y: 70), rID: "")
]
let sections2 = [
    ParkSection(name: "A", totalSpots: 11, freeSpots: 7, rows: [5, 6], spots: localParkSpots, imagePoint: ParkSectionImagePoint(x: 25, y: 34), rID: ""),
    ParkSection(name: "B", totalSpots: 16, freeSpots: 10, rows: [7, 9], spots: localParkSpots, imagePoint: ParkSectionImagePoint(x: 42, y: 34), rID: ""),
    ParkSection(name: "C", totalSpots: 11, freeSpots: 7, rows: [4, 7], spots: localParkSpots, imagePoint: ParkSectionImagePoint(x: 61, y: 34), rID: ""),
    ParkSection(name: "D", totalSpots: 14, freeSpots: 6, rows: [7, 7], spots: localParkSpots, imagePoint: ParkSectionImagePoint(x: 80, y: 35), rID: ""),
    ParkSection(name: "E", totalSpots: 15, freeSpots: 8, rows: [7, 8], spots: localParkSpots, imagePoint: ParkSectionImagePoint(x: 25, y: 72), rID: ""),
    ParkSection(name: "F", totalSpots: 13, freeSpots: 8, rows: [6, 7], spots: localParkSpots, imagePoint: ParkSectionImagePoint(x: 42, y: 71), rID: ""),
    ParkSection(name: "G", totalSpots: 14, freeSpots: 5, rows: [7, 7], spots: localParkSpots, imagePoint: ParkSectionImagePoint(x: 61, y: 68), rID: "")
]

var dbParkSections = [ParkSection]()
