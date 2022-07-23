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
    var latitude: Double
    var longitude: Double
    var rID: String
}

let localParkSpots = [
    ParkSpot(state: 0, number: 1, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 1, number: 2, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 1, number: 3, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 3, number: 4, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 3, number: 5, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 0, number: 6, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 0, number: 7, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 0, number: 8, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 0, number: 9, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 1, number: 10, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 1, number: 11, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 0, number: 12, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 1, number: 13, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 2, number: 14, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 1, number: 15, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 0, number: 16, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 0, number: 17, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 2, number: 18, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 1, number: 19, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 1, number: 20, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 0, number: 21, latitude: 46.764539, longitude: 23.596642, rID: ""),
    ParkSpot(state: 0, number: 22, latitude: 46.764539, longitude: 23.596642, rID: "")
]

var dbParkSpots = [ParkSpot]()
