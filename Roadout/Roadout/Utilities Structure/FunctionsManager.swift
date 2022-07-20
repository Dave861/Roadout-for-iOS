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
    
    //MARK: -Find Spot-
        
    var foundLocation: ParkLocation!
    var foundSection: ParkSection!
    var foundSpot: ParkSpot!
    
    var sortedLocations = [ParkLocation]()

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
       
        for i in dictArray {
            sortedArray.append(i["location"] as! ParkLocation)
        }
        
        sortedLocations = sortedArray
        completion(true)
    }

    
    func expressReserveInLocation(sectionIndex: Int, location: ParkLocation) {
        foundLocation = location
        if sectionIndex < location.sections.count-1 && foundSpot == nil {
            self.findInSection(location.sections[sectionIndex].rID) { result in
                  switch result {
                      case .success(let didFindSpot):
                          if didFindSpot {
                              self.foundSection = location.sections[sectionIndex]
                              selectedSpotID = self.foundSpot.rID
                              selectedLocationCoord = CLLocationCoordinate2D(latitude: self.foundLocation.latitude, longitude: self.foundLocation.longitude)
                              selectedLocationColor = UIColor(named: "Dark Orange")!
                              NotificationCenter.default.post(name: .addExpressViewID, object: nil)
                              NotificationCenter.default.post(name: .showExpressLaneFreeSpotID, object: nil)
                          } else {
                              self.expressReserveInLocation(sectionIndex: sectionIndex+1, location: location)
                          }
                      case .failure(let err):
                        NotificationCenter.default.post(name: .showNoFreeSpotInLocationID, object: nil)
                        print(err)
                }
            }
        } else {
            if foundSpot == nil {
                NotificationCenter.default.post(name: .showNoFreeSpotInLocationID, object: nil)
            }
        }
    }
    
    func findInSection(_ sectionId: String, completion: @escaping(Result<Bool, Error>) -> Void) {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id": sectionId]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Parking/FirstSpot.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                completion(.failure(FunctionsErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any] {
                    if jsonArray["status"] as! String == "Success" {
                        if (jsonArray["id"] as! String).lowercased() != "null" {
                            let spotID = jsonArray["id"] as! String
                            self.foundSpot = ParkSpot(state: 0, number: Int(EntityManager.sharedInstance.decodeSpotID(spotID)[2])!, rID: spotID)
                            completion(.success(true))
                        } else {
                            completion(.success(false))
                        }
                    } else {
                        print(jsonArray["status"]!)
                        completion(.failure(FunctionsErrors.unknownError))
                    }
                }
            } catch let error as NSError {
                print(error)
                completion(.failure(FunctionsErrors.errorWithJson))
            }
        }
    }
   
    
    func findSpot(completion: @escaping(_ success: Bool) -> Void) {
        
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            for location in self.sortedLocations {
                if self.foundSpot != nil {
                    break
                }
                self.foundLocation = location
                for section in location.sections {
                    if self.foundSpot != nil {
                        break
                    }
                    self.findInSection(section.rID) { result in
                        switch result {
                            case .success(let didFind):
                                if didFind {
                                    self.foundSection = section
                                    selectedSpotID = self.foundSpot.rID
                                    selectedLocationCoord = CLLocationCoordinate2D(latitude: self.foundLocation.latitude, longitude: self.foundLocation.longitude)
                                }
                            case .failure(let err):
                                print(err)
                        }
                        dispatchSemaphore.signal()
                    }
                    dispatchSemaphore.wait()
                }
            }
            if self.foundSpot == nil {
                completion(false)
            } else {
                completion(true)
            }
        }
        
    }
    
}
