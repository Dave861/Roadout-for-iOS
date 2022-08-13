//
//  ParkSpot.swift
//  Roadout
//
//  Created by David Retegan on 27.12.2021.
//

import Foundation

struct ParkSpot: Hashable, Codable {
    var state: Int
    var number: Int
    var rHash: String
    var rID: String
}

let localParkSpots = [
    ParkSpot(state: 0, number: 1, rHash: "", rID: ""),
    ParkSpot(state: 1, number: 2, rHash: "", rID: ""),
    ParkSpot(state: 1, number: 3, rHash: "", rID: ""),
    ParkSpot(state: 3, number: 4, rHash: "", rID: ""),
    ParkSpot(state: 3, number: 5, rHash: "", rID: ""),
    ParkSpot(state: 0, number: 6, rHash: "", rID: ""),
    ParkSpot(state: 0, number: 7, rHash: "", rID: ""),
    ParkSpot(state: 0, number: 8, rHash: "", rID: ""),
    ParkSpot(state: 0, number: 9, rHash: "", rID: ""),
    ParkSpot(state: 1, number: 10, rHash: "", rID: ""),
    ParkSpot(state: 1, number: 11, rHash: "", rID: ""),
    ParkSpot(state: 0, number: 12, rHash: "", rID: ""),
    ParkSpot(state: 1, number: 13, rHash: "", rID: ""),
    ParkSpot(state: 2, number: 14, rHash: "", rID: ""),
    ParkSpot(state: 1, number: 15, rHash: "", rID: ""),
    ParkSpot(state: 0, number: 16, rHash: "", rID: ""),
    ParkSpot(state: 0, number: 17, rHash: "", rID: ""),
    ParkSpot(state: 2, number: 18, rHash: "", rID: ""),
    ParkSpot(state: 1, number: 19, rHash: "", rID: ""),
    ParkSpot(state: 1, number: 20, rHash: "", rID: ""),
    ParkSpot(state: 0, number: 21, rHash: "", rID: ""),
    ParkSpot(state: 0, number: 22, rHash: "", rID: "")
]

var dbParkSpots = [ParkSpot]()
