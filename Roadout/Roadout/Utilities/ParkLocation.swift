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

let parkLocations = [ParkLocation(name: "Buna Ziua", latitude: 46.752207, longitude: 23.603324, freeSpots: 11),
                 ParkLocation(name: "Airport", latitude: 46.781864, longitude: 23.671744, freeSpots: 7),
                 ParkLocation(name: "Marasti", latitude: 46.782288, longitude: 23.613756, freeSpots: 15),
                 ParkLocation(name: "Old Town", latitude: 46.772051, longitude: 23.587260, freeSpots: 22),
                 ParkLocation(name: "21 Decembrie", latitude: 46.772798, longitude: 23.594725, freeSpots: 35),
                 ParkLocation(name: "Mihai Viteazu", latitude: 46.775235, longitude: 23.590412, freeSpots: 18),
                 ParkLocation(name: "Eroilor", latitude: 46.769916, longitude: 23.593454, freeSpots: 9),
                 ParkLocation(name: "Gheorgheni", latitude: 46.768776, longitude: 23.618535, freeSpots: 26),
                 ParkLocation(name: "Manastur", latitude: 46.758061, longitude: 23.554228, freeSpots: 13),
                 ParkLocation(name: "Andrei Muresanu", latitude: 46.758449, longitude: 23.606643, freeSpots: 39)]
