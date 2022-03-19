//
//  FunctionsManager.swift
//  Roadout
//
//  Created by David Retegan on 13.02.2022.
//

import Foundation
import CoreLocation
import UIKit

var selectedLocationName = "Location"
var selectedParkLocation = parkLocations.first!
var selectedSection = parkLocations.first!.sections.first!
var selectedLocationColor = UIColor(named: "Main Yellow")
var selectedLocationCoord: CLLocationCoordinate2D!
var currentLocationCoord: CLLocationCoordinate2D?

class FunctionsManager {
    
    static let sharedInstance = FunctionsManager()
    
    //MARK: -Find Spot-
        
    var foundLocation: ParkLocation!
    var foundSection: ParkSection!
    var foundSpot: ParkSpot!
    
    var sortedLocations = [ParkLocation]()
    
    func findSpot(_ currentLocation: CLLocationCoordinate2D, completion: (_ success: Bool) -> Void) {
        self.sortLocations(currentLocation: currentLocation, completion: { success in
            for location in sortedLocations {
                print(location.name)
            }
            var runs = 0
            while foundSpot == nil {
                //Will call server api here
                findInLocation(sortedLocations[runs])
                runs += 1
            }
            completion(true)
        })
    }
    
    func sortLocations(currentLocation: CLLocationCoordinate2D, completion: (_ success: Bool) -> Void) {
        let current = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        var dictArray = [[String: Any]]()
        for i in 0 ..< parkLocations.count {
            let loc = CLLocation(latitude: parkLocations[i].latitude, longitude: parkLocations[i].longitude)
            let distanceInMeters = current.distance(from: loc)
            let a:[String: Any] = ["distance": distanceInMeters, "location": parkLocations[i]]
            dictArray.append(a)
        }
        dictArray = dictArray.sorted(by: {($0["distance"] as! CLLocationDistance) < ($1["distance"] as! CLLocationDistance)})
        
        var sortedArray = [ParkLocation]()
        print("Running this shi... with coords \(currentLocation.latitude),  \(currentLocation.longitude)")
        for i in dictArray {
            sortedArray.append(i["location"] as! ParkLocation)
        }
        
        sortedLocations = sortedArray
        completion(true)
    }
    
    func findInLocation(_ location: ParkLocation) {
        foundLocation = location
        outerLoop: for section in location.sections {
            for spot in section.spots {
                if spot.state == 0 {
                    foundSection = section
                    foundSpot = spot
                    selectedLocationCoord = CLLocationCoordinate2D(latitude: foundLocation.latitude, longitude: foundLocation.longitude)
                    
                    break outerLoop
                }
            }
        }
        print(foundSection.name)
        print(foundSpot.number)
        if foundSpot == nil {
            print("FUCK FUCK Handle this")
        }
    }

}
