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

let eroilorPoints = ["A" : ParkSectionImagePoint(x: 41, y: 39), "B" : ParkSectionImagePoint(x: 71, y: 39), "C" : ParkSectionImagePoint(x: 58, y: 64)]
let decembriePoints = ["A" : ParkSectionImagePoint(x: 35, y: 38), "B" : ParkSectionImagePoint(x: 40, y: 78), "C" : ParkSectionImagePoint(x: 60, y: 62)]
let marastiPoints = ["A" : ParkSectionImagePoint(x: 15, y: 32), "B" : ParkSectionImagePoint(x: 30, y: 32), "C" : ParkSectionImagePoint(x: 45, y: 32), "D" : ParkSectionImagePoint(x: 88, y: 32), "E" : ParkSectionImagePoint(x: 15, y: 73), "F" : ParkSectionImagePoint(x: 30, y: 68), "G" : ParkSectionImagePoint(x: 45, y: 63)]
let mihaiViteazuPoints = ["A" : ParkSectionImagePoint(x: 52, y: 30), "B" : ParkSectionImagePoint(x: 36, y: 71)]
let oldTownPoints = ["A" : ParkSectionImagePoint(x: 32, y: 46), "B" : ParkSectionImagePoint(x: 47, y: 31), "C" : ParkSectionImagePoint(x: 62, y: 18), "D" : ParkSectionImagePoint(x: 54, y: 66)]

let sections1 = [
    ParkSection(name: "A", totalSpots: 15, freeSpots: 8, rows: [7, 8], spots: spots1, imagePoint: ParkSectionImagePoint(x: 29, y: 27), rID: ""),
    ParkSection(name: "B", totalSpots: 11, freeSpots: 6, rows: [6, 5], spots: spots2, imagePoint: ParkSectionImagePoint(x: 51, y: 30), rID: ""),
    ParkSection(name: "C", totalSpots: 16, freeSpots: 8, rows: [8, 8], spots: spots3, imagePoint: ParkSectionImagePoint(x: 72, y: 29), rID: ""),
    ParkSection(name: "D", totalSpots: 13, freeSpots: 7, rows: [6, 7], spots: spots3, imagePoint: ParkSectionImagePoint(x: 30, y: 68), rID: ""),
    ParkSection(name: "E", totalSpots: 12, freeSpots: 5, rows: [3, 9], spots: spots2, imagePoint: ParkSectionImagePoint(x: 51, y: 70), rID: ""),
    ParkSection(name: "F", totalSpots: 14, freeSpots: 8, rows: [8, 6], spots: spots1, imagePoint: ParkSectionImagePoint(x: 72, y: 70), rID: "")
]
let sections2 = [
    ParkSection(name: "A", totalSpots: 11, freeSpots: 7, rows: [5, 6], spots: spots2, imagePoint: ParkSectionImagePoint(x: 25, y: 34), rID: ""),
    ParkSection(name: "B", totalSpots: 16, freeSpots: 10, rows: [7, 9], spots: spots3, imagePoint: ParkSectionImagePoint(x: 42, y: 34), rID: ""),
    ParkSection(name: "C", totalSpots: 11, freeSpots: 7, rows: [4, 7], spots: spots1, imagePoint: ParkSectionImagePoint(x: 61, y: 34), rID: ""),
    ParkSection(name: "D", totalSpots: 14, freeSpots: 6, rows: [7, 7], spots: spots1, imagePoint: ParkSectionImagePoint(x: 80, y: 35), rID: ""),
    ParkSection(name: "E", totalSpots: 15, freeSpots: 8, rows: [7, 8], spots: spots2, imagePoint: ParkSectionImagePoint(x: 25, y: 72), rID: ""),
    ParkSection(name: "F", totalSpots: 13, freeSpots: 8, rows: [6, 7], spots: spots2, imagePoint: ParkSectionImagePoint(x: 42, y: 71), rID: ""),
    ParkSection(name: "G", totalSpots: 14, freeSpots: 5, rows: [7, 7], spots: spots1, imagePoint: ParkSectionImagePoint(x: 61, y: 68), rID: "")
]
/*let sections3 = [
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
]*/
let sections8 = [
    ParkSection(name: "A", totalSpots: 13, freeSpots: 5, rows: [6, 7], spots: spots3, imagePoint: ParkSectionImagePoint(x: 36, y: 49), rID: ""),
    ParkSection(name: "B", totalSpots: 11, freeSpots: 8, rows: [5, 6], spots: spots2, imagePoint: ParkSectionImagePoint(x: 50, y: 24), rID: ""),
    ParkSection(name: "C", totalSpots: 12, freeSpots: 9, rows: [6, 6], spots: spots2, imagePoint: ParkSectionImagePoint(x: 50, y: 71), rID: ""),
    ParkSection(name: "D", totalSpots: 14, freeSpots: 7, rows: [7, 7], spots: spots1, imagePoint: ParkSectionImagePoint(x: 64, y: 49), rID: "")
]
let sections9 = [
    ParkSection(name: "A", totalSpots: 20, freeSpots: 9, rows: [10, 10], spots: spots1, imagePoint: ParkSectionImagePoint(x: 32, y: 27), rID: ""),
    ParkSection(name: "B", totalSpots: 22, freeSpots: 12, rows: [11, 11], spots: spots3, imagePoint: ParkSectionImagePoint(x: 26, y: 78), rID: ""),
    ParkSection(name: "C", totalSpots: 19, freeSpots: 8, rows: [9, 10], spots: spots2, imagePoint: ParkSectionImagePoint(x: 59, y: 52), rID: ""),
    ParkSection(name: "D", totalSpots: 21, freeSpots: 10, rows: [10, 11], spots: spots2, imagePoint: ParkSectionImagePoint(x: 67, y: 88), rID: "")
]
let sections10 = [
    ParkSection(name: "A", totalSpots: 17, freeSpots: 6, rows: [7, 10], spots: spots1, imagePoint: ParkSectionImagePoint(x: 21, y: 44), rID: ""),
    ParkSection(name: "B", totalSpots: 17, freeSpots: 14, rows: [9, 8], spots: spots1, imagePoint: ParkSectionImagePoint(x: 38, y: 44), rID: ""),
    ParkSection(name: "C", totalSpots: 18, freeSpots: 12, rows: [9, 9], spots: spots2, imagePoint: ParkSectionImagePoint(x: 56, y: 44), rID: ""),
    ParkSection(name: "D", totalSpots: 17, freeSpots: 8, rows: [8, 9], spots: spots3, imagePoint: ParkSectionImagePoint(x: 73, y: 44), rID: "")
]

var dbParkSections = [ParkSection]()
