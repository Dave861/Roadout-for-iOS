//
//  VariablesManager.swift
//  Roadout
//
//  Created by David Retegan on 20.07.2022.
//

import Foundation
import UIKit
import CoreLocation

enum MapType {
    case roadout
    case satellite
}

enum RoadoutErrors: Error {
    case wrongFormat
    case unknown
}

var selectedMapType = MapType.roadout

//Used to help with notification management
var timerSeconds = 0
var delaySeconds = 300
var paidHours = 0

var selectedLocation = ParkLocation(name: "Selected Location", rID: "", latitude: 0.0, longitude: 0.0, totalSpots: 0, freeSpots: 0, sections: [ParkSection](), sectionImage: "SelectedLocationSection", accentColor: "Main Yellow")
var selectedParkLocationIndex = 0
var selectedSectionIndex = 0

var selectedSpot = ParkSpot(state: 0, number: 0, rHash: "", rID: "") //Manage once in database - ex: u82f0bc6m303-f80-h70-p0

var currentLocationCoord: CLLocationCoordinate2D?

//Decides if Pay Card returns to Delay Card or Select Card
var returnToDelay = false

//Decides if Reserve Card returns to Result Card or Spot Card
var returnToResult = false

var futureReservations = [FutureReservation]()

var cardNumbers = [String]()

let colours = ["Main Yellow", "Dark Orange", "Icons", "Kinda Red", "Second Orange"]

//Decides if Duration Card return to Unlocked Card or Search Bar
var isPayFlow = false
var selectedPayLocation: ParkLocation!
var userLicensePlate = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.userLicensePlate") ?? "NO-PLATE"

//Express Lane IDs
var favouriteLocationIDs = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.Roadout.favouriteLocationIDs") ?? [String]()
var favouriteLocations = [ParkLocation]()

//Will use API to get this
var cityParkLocationsCount = 11

//Remember car location
var carParkHash = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.carParkHash") ?? "roadout_carpark_clear"

//Live Activity
var openedByLiveActivity = false

//While server is variable, makes changing the url easier
var roadoutServerURL = "api.roadout.live"
