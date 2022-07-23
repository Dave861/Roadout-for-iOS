//
//  VariablesManager.swift
//  Roadout
//
//  Created by David Retegan on 20.07.2022.
//

import Foundation
import UIKit
import CoreLocation

//Used to help with notification management
var timerSeconds = 0
var delaySeconds = 300
var paidHours = 0

var selectedLocationName = "Location"
var selectedParkLocationIndex = 0
var selectedSectionIndex = 0
var selectedLocationColor = UIColor(named: "Main Yellow")
var selectedSpotID: String!
var selectedLocationCoord: CLLocationCoordinate2D!

var currentLocationCoord: CLLocationCoordinate2D?

//Decides if Pay Card returns to Delay Card, Find Card or Select Card
var returnToDelay = false
var returnToFind = false

var reminders = [Reminder]()

var cardNumbers = ["**** **** **** 9000", "**** **** **** 7250", "**** **** **** 7784", "**** **** **** 9432"]

let colours = ["Main Yellow", "Brownish", "Dark Orange", "Dark Yellow", "Icons", "Kinda Red", "Second Orange", "Limey"]

//Decides if Duration Card return to Unlocked Card or Search Bar
var isPayFlow = false

//Express Lane IDs
var favouriteLocationIDs = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.Roadout.favouriteLocationIDs") ?? [String]()
var favouriteLocations = [ParkLocation]()

//Will use API to get this
var cityParkLocationsCount = 11
