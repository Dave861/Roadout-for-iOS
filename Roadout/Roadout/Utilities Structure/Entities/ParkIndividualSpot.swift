//
//  ParkIndividualSpot.swift
//  Roadout
//
//  Created by David Retegan on 19.07.2022.
//

import Foundation

struct ParkIndividualSpot: Hashable, Codable {
    var streetName: String
    var number: Int
    var latitude: Double
    var longitude: Double
    var rID: String
}

var individualSpots = [
    ParkIndividualSpot(streetName: "Avram Iancu", number: 11, latitude: 46.766693, longitude: 23.593228, rID: "Cluj.StrAvramIancu.11"),
    ParkIndividualSpot(streetName: "Avram Iancu", number: 2, latitude: 46.766272, longitude: 23.589810, rID: "Cluj.StrAvramIancu.2"),
    ParkIndividualSpot(streetName: "Clinicilor", number: 6, latitude: 46.764785, longitude: 23.577892, rID: "Cluj.StrClinicilor.6"),
    ParkIndividualSpot(streetName: "Clinicilor", number: 3, latitude: 46.764884, longitude: 23.578633, rID: "Cluj.StrClinicilor.3"),
    ParkIndividualSpot(streetName: "Clinicilor", number: 4, latitude: 46.764711, longitude: 23.576843, rID: "Cluj.StrClinicilor.4"),
    ParkIndividualSpot(streetName: "Constanța", number: 7, latitude: 46.774962, longitude: 23.594820, rID: "Cluj.StrConstanța.7"),
    ParkIndividualSpot(streetName: "Constanța", number: 9, latitude: 46.775160, longitude: 23.594758, rID: "Cluj.StrConstanța.9"),
    ParkIndividualSpot(streetName: "Constanța", number: 15, latitude: 46.775498, longitude: 23.594439, rID: "Cluj.StrConstanța.15"),
]
