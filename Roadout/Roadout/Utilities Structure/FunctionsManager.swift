//
//  FunctionsManager.swift
//  Roadout
//
//  Created by David Retegan on 13.02.2022.
//

import Foundation
import CoreLocation
import Alamofire
import UIKit

class FunctionsManager {
    
    static let sharedInstance = FunctionsManager()
    
    enum FunctionsErrors: Error {
        case databaseFailure
        case errorWithJson
        case networkError
        case unknownError
        case notFound
    }
            
    var foundLocation: ParkLocation!
    var foundSection: ParkSection!
    var foundSpot: ParkSpot!
    
    var sortedLocations = [ParkLocation]()
    
    func sortLocations(currentLocation: CLLocationCoordinate2D) {
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
       
        for i in dictArray {
            sortedArray.append(i["location"] as! ParkLocation)
        }
        
        sortedLocations = sortedArray
    }
    
    //MARK: - Finding Functions -
    
    func findSpotInSectionAsync(sectionId: String) async throws -> Bool {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id": sectionId]
        
        let checkRequest = AF.request("https://\(roadoutServerURL)/Parking/FirstSpot.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await checkRequest.serializingString().value
        } catch {
            throw FunctionsErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw FunctionsErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String == "Success" {
            if (jsonArray["id"] as! String).lowercased() != "null" {
                let spotID = jsonArray["id"] as! String
                self.foundSpot = ParkSpot(state: 0, number: Int(EntityManager.sharedInstance.decodeSpotID(spotID)[2])!, rHash: "u82f0ftyjk0w-f120-h70-p0", rID: spotID)
                //u82f0bc6m303
                return true
            } else {
                return false
            }
        } else {
            throw FunctionsErrors.unknownError
        }
    }

    func findSpotInLocationAsync(location: ParkLocation) async throws {
        foundLocation = location
        foundSpot = nil
        
        for parkSection in location.sections {
            if foundSpot != nil {
                break
            } else {
                do {
                    let didFindSpot = try await self.findSpotInSectionAsync(sectionId: parkSection.rID)
                    if didFindSpot {
                        foundSection = parkSection
                        selectedSpot.rID = foundSpot.rID
                        selectedSpot.rHash = foundSpot.rHash
                        selectedLocation.latitude = foundLocation.latitude
                        selectedLocation.longitude = foundLocation.longitude
                        selectedLocation.accentColor = location.accentColor
                    }
                } catch let err {
                    throw err
                }
            }
        }
        if foundSpot == nil {
            throw FunctionsErrors.notFound
        }
    }
    
    func findWay() async throws -> Bool {
        foundSpot = nil
        for parkLocation in sortedLocations {
            if foundSpot != nil {
                break
            }
            foundLocation = parkLocation
            for parkSection in parkLocation.sections {
                if foundSpot != nil {
                    break
                } else {
                    do {
                        let didFindSpot = try await self.findSpotInSectionAsync(sectionId: parkSection.rID)
                        if didFindSpot {
                            foundSection = parkSection
                            selectedSpot.rID = foundSpot.rID
                            selectedSpot.rHash = foundSpot.rHash
                            selectedLocation.latitude = foundLocation.latitude
                            selectedLocation.longitude = foundLocation.longitude
                            selectedLocation.accentColor = parkLocation.accentColor
                            return true
                        }
                    } catch let err {
                        print(err) //!IMPORTANT should throw errors in production
                    }
                }
            }
        }
        if foundSpot != nil {
            return true
        } else {
            return false
        }
    }
}
