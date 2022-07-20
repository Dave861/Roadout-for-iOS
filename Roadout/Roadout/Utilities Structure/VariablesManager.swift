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
