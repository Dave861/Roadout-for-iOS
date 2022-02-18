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

let sections1 = [
    ParkSection(name: "A", totalSpots: 15, freeSpots: 8, rows: [7, 8], spots: spots1, rID: ""),
    ParkSection(name: "B", totalSpots: 11, freeSpots: 6, rows: [6, 5], spots: spots2, rID: ""),
    ParkSection(name: "C", totalSpots: 16, freeSpots: 8, rows: [8, 8], spots: spots3, rID: ""),
    ParkSection(name: "D", totalSpots: 13, freeSpots: 7, rows: [6, 7], spots: spots3, rID: ""),
    ParkSection(name: "E", totalSpots: 12, freeSpots: 5, rows: [3, 9], spots: spots2, rID: ""),
    ParkSection(name: "F", totalSpots: 14, freeSpots: 8, rows: [8, 6], spots: spots1, rID: "")
]
let sections2 = [
    ParkSection(name: "A", totalSpots: 11, freeSpots: 7, rows: [5, 6], spots: spots2, rID: ""),
    ParkSection(name: "B", totalSpots: 16, freeSpots: 10, rows: [7, 9], spots: spots3, rID: ""),
    ParkSection(name: "C", totalSpots: 11, freeSpots: 7, rows: [4, 7], spots: spots1, rID: ""),
    ParkSection(name: "D", totalSpots: 14, freeSpots: 6, rows: [7, 7], spots: spots1, rID: ""),
    ParkSection(name: "E", totalSpots: 15, freeSpots: 8, rows: [7, 8], spots: spots2, rID: ""),
    ParkSection(name: "F", totalSpots: 13, freeSpots: 8, rows: [6, 7], spots: spots2, rID: ""),
    ParkSection(name: "G", totalSpots: 14, freeSpots: 5, rows: [7, 7], spots: spots1, rID: "")
]
let sections3 = [
    ParkSection(name: "A", totalSpots: 16, freeSpots: 8, rows: [8, 8], spots: spots1, rID: ""),
    ParkSection(name: "B", totalSpots: 13, freeSpots: 7, rows: [6, 7], spots: spots3, rID: ""),
    ParkSection(name: "C", totalSpots: 21, freeSpots: 11, rows: [10, 11], spots: spots2, rID: ""),
    ParkSection(name: "D", totalSpots: 15, freeSpots: 10, rows: [7, 8], spots: spots3, rID: ""),
    ParkSection(name: "E", totalSpots: 16, freeSpots: 9, rows: [8, 8], spots: spots2, rID: ""),
    ParkSection(name: "F", totalSpots: 18, freeSpots: 8, rows: [9, 9], spots: spots1, rID: ""),
    ParkSection(name: "G", totalSpots: 17, freeSpots: 7, rows: [10, 7], spots: spots1, rID: "")
]
let sections4 = [
    ParkSection(name: "A", totalSpots: 11, freeSpots: 5, rows: [5, 6], spots: spots1, rID: ""),
    ParkSection(name: "B", totalSpots: 10, freeSpots: 3, rows: [5, 5], spots: spots2, rID: ""),
    ParkSection(name: "C", totalSpots: 13, freeSpots: 7, rows: [7, 6], spots: spots3, rID: ""),
    ParkSection(name: "D", totalSpots: 11, freeSpots: 4, rows: [6, 5], spots: spots1, rID: "")
]
let sections5 = [
    ParkSection(name: "A", totalSpots: 12, freeSpots: 5, rows: [6, 6], spots: spots3, rID: ""),
    ParkSection(name: "B", totalSpots: 13, freeSpots: 6, rows: [6, 7], spots: spots2, rID: ""),
    ParkSection(name: "C", totalSpots: 15, freeSpots: 4, rows: [7, 8], spots: spots1, rID: "")
]
let sections6 = [
    ParkSection(name: "A", totalSpots: 16, freeSpots: 7, rows: [8, 8], spots: spots2, rID: ""),
    ParkSection(name: "B", totalSpots: 13, freeSpots: 6, rows: [6, 7], spots: spots3, rID: "")
]
let sections7 = [
    ParkSection(name: "A", totalSpots: 17, freeSpots: 8, rows: [8, 9], spots: spots1, rID: ""),
    ParkSection(name: "B", totalSpots: 16, freeSpots: 5, rows: [8, 8], spots: spots1, rID: ""),
    ParkSection(name: "C", totalSpots: 21, freeSpots: 9, rows: [10, 11], spots: spots3, rID: "")
]
let sections8 = [
    ParkSection(name: "A", totalSpots: 13, freeSpots: 5, rows: [6, 7], spots: spots3, rID: ""),
    ParkSection(name: "B", totalSpots: 11, freeSpots: 8, rows: [5, 6], spots: spots2, rID: ""),
    ParkSection(name: "C", totalSpots: 12, freeSpots: 9, rows: [6, 6], spots: spots2, rID: ""),
    ParkSection(name: "D", totalSpots: 14, freeSpots: 7, rows: [7, 7], spots: spots1, rID: "")
]
let sections9 = [
    ParkSection(name: "A", totalSpots: 20, freeSpots: 9, rows: [10, 10], spots: spots1, rID: ""),
    ParkSection(name: "B", totalSpots: 22, freeSpots: 12, rows: [11, 11], spots: spots3, rID: ""),
    ParkSection(name: "C", totalSpots: 19, freeSpots: 8, rows: [9, 10], spots: spots2, rID: ""),
    ParkSection(name: "D", totalSpots: 21, freeSpots: 10, rows: [10, 11], spots: spots2, rID: "")
]
let sections10 = [
    ParkSection(name: "A", totalSpots: 17, freeSpots: 6, rows: [7, 10], spots: spots1, rID: ""),
    ParkSection(name: "B", totalSpots: 17, freeSpots: 14, rows: [9, 8], spots: spots1, rID: ""),
    ParkSection(name: "C", totalSpots: 18, freeSpots: 12, rows: [9, 9], spots: spots2, rID: ""),
    ParkSection(name: "D", totalSpots: 17, freeSpots: 8, rows: [8, 9], spots: spots3, rID: "")
]
