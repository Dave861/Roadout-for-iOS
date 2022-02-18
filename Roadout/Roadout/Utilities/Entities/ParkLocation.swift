//
//  ParkLocation.swift
//  Roadout
//
//  Created by David Retegan on 04.11.2021.
//

import Foundation

struct ParkLocation: Hashable, Codable {
    var name: String
    //var keywords: [String]
    var rID: String
    var latitude: Double
    var longitude: Double
    var totalSpots: Int
    var freeSpots: Int
    var sections: [ParkSection]
    var sectionImage: String
}

let parkLocations = [ParkLocation(name: "Buna Ziua", rID: "Cluj.BunaZiua", latitude: 46.752207, longitude: 23.603324, totalSpots: 81, freeSpots: 42, sections: sections1, sectionImage: "Cluj.BunaZiua.Section"),
                 ParkLocation(name: "Airport", rID: "Cluj.Airport", latitude: 46.781864, longitude: 23.671744, totalSpots: 94, freeSpots: 51, sections: sections2, sectionImage: "Cluj.Airport.Section"),
                 ParkLocation(name: "Marasti", rID: "Cluj.Marasti", latitude: 46.782288, longitude: 23.613756, totalSpots: 116, freeSpots: 63, sections: sections3, sectionImage: "Cluj.Marasti.Section"),
                 ParkLocation(name: "Old Town", rID: "Cluj.OldTown", latitude: 46.772051, longitude: 23.587260, totalSpots: 45, freeSpots: 19, sections: sections4, sectionImage: "Cluj.OldTown.Section"),
                 ParkLocation(name: "21 Decembrie", rID: "Cluj.21Decembrie", latitude: 46.772798, longitude: 23.594725, totalSpots: 40, freeSpots: 15, sections: sections5, sectionImage: "Cluj.21Decembrie.Section"),
                 ParkLocation(name: "Mihai Viteazu", rID: "Cluj.MihaiViteazu", latitude: 46.775235, longitude: 23.590412, totalSpots: 29, freeSpots: 13, sections: sections6, sectionImage: "Cluj.MihaiViteazu.Section"),
                 ParkLocation(name: "Eroilor", rID: "Cluj.Eroilor", latitude: 46.769916, longitude: 23.593454, totalSpots: 54, freeSpots: 22, sections: sections7, sectionImage: "Cluj.Eroilor.Section"),
                 ParkLocation(name: "Gheorgheni", rID: "Cluj.Gheorgheni", latitude: 46.767300, longitude: 23.622005, totalSpots: 49, freeSpots: 29, sections: sections8, sectionImage: "Cluj.Gheorgheni.Section"),
                 ParkLocation(name: "Manastur", rID: "Cluj.Manastur", latitude: 46.758061, longitude: 23.554228, totalSpots: 82, freeSpots: 39, sections: sections9, sectionImage: "Cluj.Manastur.Section"),
                 ParkLocation(name: "Andrei Muresanu", rID: "Cluj.AndreiMuresanu", latitude: 46.758449, longitude: 23.606643, totalSpots: 69, freeSpots: 40, sections: sections10, sectionImage: "Cluj.AndreiMuresanu.Section")]
