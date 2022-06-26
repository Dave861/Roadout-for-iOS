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
    var rID: String
}

let spots1 = [
    ParkSpot(state: 0, number: 1, rID: ""),
    ParkSpot(state: 1, number: 2, rID: ""),
    ParkSpot(state: 1, number: 3, rID: ""),
    ParkSpot(state: 3, number: 4, rID: ""),
    ParkSpot(state: 3, number: 5, rID: ""),
    ParkSpot(state: 0, number: 6, rID: ""),
    ParkSpot(state: 0, number: 7, rID: ""),
    ParkSpot(state: 0, number: 8, rID: ""),
    ParkSpot(state: 0, number: 9, rID: ""),
    ParkSpot(state: 1, number: 10, rID: ""),
    ParkSpot(state: 1, number: 11, rID: ""),
    ParkSpot(state: 0, number: 12, rID: ""),
    ParkSpot(state: 1, number: 13, rID: ""),
    ParkSpot(state: 2, number: 14, rID: ""),
    ParkSpot(state: 1, number: 15, rID: ""),
    ParkSpot(state: 0, number: 16, rID: ""),
    ParkSpot(state: 0, number: 17, rID: ""),
    ParkSpot(state: 2, number: 18, rID: ""),
    ParkSpot(state: 1, number: 19, rID: ""),
    ParkSpot(state: 1, number: 20, rID: ""),
    ParkSpot(state: 0, number: 21, rID: ""),
    ParkSpot(state: 0, number: 22, rID: "")
]
let spots2 = [
    ParkSpot(state: 1, number: 1, rID: ""),
    ParkSpot(state: 0, number: 2, rID: ""),
    ParkSpot(state: 1, number: 3, rID: ""),
    ParkSpot(state: 2, number: 4, rID: ""),
    ParkSpot(state: 0, number: 5, rID: ""),
    ParkSpot(state: 0, number: 6, rID: ""),
    ParkSpot(state: 1, number: 7, rID: ""),
    ParkSpot(state: 0, number: 8, rID: ""),
    ParkSpot(state: 0, number: 9, rID: ""),
    ParkSpot(state: 1, number: 10, rID: ""),
    ParkSpot(state: 1, number: 11, rID: ""),
    ParkSpot(state: 3, number: 12, rID: ""),
    ParkSpot(state: 0, number: 13, rID: ""),
    ParkSpot(state: 0, number: 14, rID: ""),
    ParkSpot(state: 1, number: 15, rID: ""),
    ParkSpot(state: 1, number: 16, rID: ""),
    ParkSpot(state: 2, number: 17, rID: ""),
    ParkSpot(state: 2, number: 18, rID: ""),
    ParkSpot(state: 0, number: 19, rID: ""),
    ParkSpot(state: 1, number: 20, rID: ""),
    ParkSpot(state: 1, number: 21, rID: ""),
    ParkSpot(state: 0, number: 22, rID: ""),
    
   
]
let spots3 = [
    
    ParkSpot(state: 1, number: 1, rID: ""),
    ParkSpot(state: 0, number: 2, rID: ""),
    ParkSpot(state: 1, number: 3, rID: ""),
    ParkSpot(state: 1, number: 4, rID: ""),
    ParkSpot(state: 2, number: 5, rID: ""),
    ParkSpot(state: 1, number: 6, rID: ""),
    ParkSpot(state: 0, number: 7, rID: ""),
    ParkSpot(state: 0, number: 8, rID: ""),
    ParkSpot(state: 0, number: 9, rID: ""),
    ParkSpot(state: 1, number: 10, rID: ""),
    ParkSpot(state: 1, number: 11, rID: ""),
    ParkSpot(state: 2, number: 12, rID: ""),
    ParkSpot(state: 0, number: 13, rID: ""),
    ParkSpot(state: 0, number: 14, rID: ""),
    ParkSpot(state: 0, number: 15, rID: ""),
    ParkSpot(state: 1, number: 16, rID: ""),
    ParkSpot(state: 1, number: 17, rID: ""),
    ParkSpot(state: 3, number: 18, rID: ""),
    ParkSpot(state: 0, number: 19, rID: ""),
    ParkSpot(state: 0, number: 20, rID: ""),
    ParkSpot(state: 1, number: 21, rID: ""),
    ParkSpot(state: 1, number: 22, rID: "")
]

var dbParkSpots = [ParkSpot]()
