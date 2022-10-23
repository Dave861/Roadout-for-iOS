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

var selectedMapType = MapType.roadout

//Used to help with notification management
var timerSeconds = 0
var delaySeconds = 300
var paidHours = 0

var selectedLocationName = "Location"
var selectedParkLocationIndex = 0
var selectedSectionIndex = 0
var selectedLocationColor = UIColor(named: "Main Yellow")
var selectedSpotID: String!
var selectedSpotHash = "u82f0bc6m303-f80-h70-p0" //Manage once in database
var selectedLocationCoord: CLLocationCoordinate2D!
var selectedSpotColor = "Main Yellow"

var currentLocationCoord: CLLocationCoordinate2D?

//Decides if Pay Card returns to Delay Card, Find Card or Select Card
var returnToDelay = false
var returnToFind = false

//Decides if Reserve Card returns to Result Card or Spot Card
var returnToResult = false

var reminders = [Reminder]()

var cardNumbers = [String]()

let colours = ["Main Yellow", "Dark Orange", "Icons", "Kinda Red", "Second Orange"]

//Decides if Duration Card return to Unlocked Card or Search Bar
var isPayFlow = false

var selectedPayLocation: ParkLocation!

//Express Lane IDs
var favouriteLocationIDs = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.Roadout.favouriteLocationIDs") ?? [String]()
var favouriteLocations = [ParkLocation]()

//Will use API to get this
var cityParkLocationsCount = 11

//Remember car location
var carParkHash = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.carParkHash") ?? "roadout_carpark_clear"

//While server is variable, makes changing the url easier
var roadoutServerURL = "df6a6bd160e183de.p55.rt3.io"
