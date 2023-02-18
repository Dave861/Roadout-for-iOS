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

enum LicensePlateErrors: Error {
    case wrongFormat
    case unknown
}

let colours = ["Main Yellow", "Dark Orange", "Icons", "Kinda Red", "Second Orange"]

var selectedMapType = MapType.roadout

//Used to help with notification management
var reservationTime = 0 ///Keeps time in Seconds
var delayTime = 300 ///Keeps time in Seconds
var paidTime = 0 ///Keeps time in Hours

///Keeps the selected park location, not safe for use in flows, color coordonation and non-critical actions
var selectedLocation = ParkLocation(name: "Selected Location", rID: "", latitude: 0.0, longitude: 0.0, totalSpots: 0, freeSpots: 0, sections: [ParkSection](), sectionImage: "SelectedLocationSection", accentColor: "Main Yellow")
var selectedParkLocationIndex = 0
var selectedSectionIndex = 0

///Keeps the selected parking spot, safe for use in flows, is reinstated when lost
var selectedSpot = ParkSpot(state: 0, number: 0, rHash: "u82f0bc6m303-f80-h70-p0", rID: "") //Manage rHash once in database - replace with ""

var currentLocationCoord: CLLocationCoordinate2D?

//Flow controllers
var returnToDelay = false
var returnToResult = false
var isPayFlow = false
var isSelectionFlow = false

//Utils
var futureReservations = [FutureReservation]()
var cardNumbers = [String]()

//Pay Parking Utils
var selectedPayLocation: ParkLocation!
var userLicensePlate = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.userLicensePlate") ?? "NO-PLATE"

//Express Lane IDs
var favouriteLocationIDs = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.Roadout.favouriteLocationIDs") ?? [String]()
var favouriteLocations = [ParkLocation]()

//Will use API to get this
var cityParkLocationsCount = 11

///Remembers car location
var carParkHash = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.carParkHash") ?? "roadout_carpark_clear"

//Live Activity
///Decides whether or not to show the unlock card if the app is opened from the Dynamic Island
var openedByLiveActivity = false

//While server is variable, makes changing the url easier
var roadoutServerURL = "api.roadout.live"

///Google API Key for web APIs
var webAPIKey = "AIzaSyD_5r7bTeg94Fr6IqXPKA5X8o-qUQXuTmg"
