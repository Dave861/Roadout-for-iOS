//
//  EntityManager.swift
//  Roadout
//
//  Created by David Retegan on 17.02.2022.
//

import Foundation
import Network
import CryptoKit
import Alamofire

class EntityManager {
    
    static let sharedInstance = EntityManager()
        
    enum EntityErrors: Error {
        case databaseFailure
        case errorWithJson
        case networkError
        case unknownError
    }
    
    func getParkLocationsAsync(_ city: String) async throws -> String {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id": city]
        let downloadRequest = AF.request("https://\(roadoutServerURL)/Parking/GetParkingLots.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        return try await downloadRequest.serializingString().value
    }
    
    func saveParkLocationsAsync(_ city: String) async throws {
        do {
            let responseJson = try await getParkLocationsAsync(city)
            let data = ("[" + responseJson.dropLast() + "]").data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Array<[String:Any]> {
                    dbParkLocations = [ParkLocation]()
                    for json in jsonArray {
                        var dbParkLocation = ParkLocation(name: json["name"] as! String,
                                                          rID: json["id"] as! String,
                                                          latitude: Double(json["lat"] as! String)!,
                                                          longitude: Double(json["lng"] as! String)!,
                                                          totalSpots: Int(json["nrParkingSpots"] as! String)!,
                                                          freeSpots: Int(json["freeParkingSpots"] as! String)!,
                                                          sections: [ParkSection](),
                                                          sectionImage: json["id"] as! String + ".Section",
                                                          accentColor: "Main Yellow")
                        self.makeAccentColor(parkLocation: &dbParkLocation)
                        dbParkLocations.append(dbParkLocation)
                    }
                } else {
                    throw EntityErrors.unknownError
                }
            } catch {
                throw EntityErrors.errorWithJson
            }
        } catch {
            throw EntityErrors.databaseFailure
        }
    }
    
    func getParkSectionsAsync(_ location: String) async throws -> String {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":location]
        let downloadRequest = AF.request("https://\(roadoutServerURL)/Parking/GetParkingSections.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        return try await downloadRequest.serializingString().value
    }
    
    func saveParkSectionsAsync(_ location: String) async throws {
        do {
            let responseJson = try await getParkSectionsAsync(location)
            let data = ("[" + responseJson.dropLast() + "]").data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Array<[String:Any]> {
                    dbParkSections = [ParkSection]()
                    for json in jsonArray {
                        let imagePoint = ParkSectionImagePoint(x: Int(json["iOSPointImage.x"] as! String)!, y: Int(json["iOSPointImage.y"] as! String)!)
                        dbParkSections.append(
                            ParkSection(name: json["name"] as! String,
                                        totalSpots: Int(json["nrParkingSpots"] as! String)!, freeSpots: 0,
                                        rows: self.getNumbers(json["nrRows"] as! String),
                                        spots: [ParkSpot](),
                                        imagePoint: imagePoint,
                                        rID: json["sectionID"] as! String))
                    }
                } else {
                    throw EntityErrors.unknownError
                }
            } catch {
                throw EntityErrors.errorWithJson
            }
        } catch {
            throw EntityErrors.databaseFailure
        }
    }
    
    func getParkSpotsAsync(_ section: String) async throws -> String {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":section]
        let downloadRequest = AF.request("https://\(roadoutServerURL)/Parking/GetSectionInf.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        return try await downloadRequest.serializingString().value
    }
    
    func saveParkSpotsAsync(_ section: String) async throws {
        do {
            let responseJson = try await getParkSpotsAsync(section)
            let data = ("[" + responseJson.dropLast() + "]").data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Array<[String:Any]> {
                    dbParkSpots = [ParkSpot]()
                    for json in jsonArray {
                        dbParkSpots.append(
                            ParkSpot(state: Int(json["state"] as! String)!,
                                     number: Int(json["number"] as! String)!,
                                     rHash: "u82f0bc6m303-f80-h70-p0",
                                     rID: json["id"] as! String))
                    }
                    dbParkSpots.sort { $0.number < $1.number }
                } else {
                    throw EntityErrors.unknownError
                }
            } catch {
                throw EntityErrors.errorWithJson
            }
        } catch {
            throw EntityErrors.databaseFailure
        }
    }
    
    func getNumbers(_ strArray: String) -> [Int] {
        let stringRecordedArr = strArray.components(separatedBy: ",")
        return stringRecordedArr.map { Int($0)!}
    }
    
    func getFreeParkSpotsAsync(_ location: String) async throws -> String {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":location]
        let downloadRequest = AF.request("https://\(roadoutServerURL)/Parking/GetFreeParkingSpots.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        return try await downloadRequest.serializingString().value
    }
    
    func updateFreeParkSpotsAsync(_ location: String, _ index: Int) async throws {
        do {
            let responseJson = try await getFreeParkSpotsAsync(location)
            let data = responseJson.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    if jsonArray["status"] as! String == "Success" {
                        parkLocations[index].freeSpots = Int(jsonArray["result"] as! String)!
                        self.makeAccentColor(parkLocation: &parkLocations[index])
                    } else {
                        throw EntityErrors.unknownError
                    }
                } else {
                    throw EntityErrors.unknownError
                }
            } catch {
                throw EntityErrors.errorWithJson
            }
        } catch {
            throw EntityErrors.databaseFailure
        }
    }
    
    func decodeSpotID(_ spotID: String) -> [String] {
        var details = [String]()
        details = spotID.components(separatedBy: ".")
        details.remove(at: 0)
        details[0] = details[0].camelCaseToWords()
        return details
    }
    
    func makeAccentColor(parkLocation: inout ParkLocation) {
        let percentage = 100-(Double(parkLocation.freeSpots)/Double(parkLocation.totalSpots))*100
        if percentage >= 90 {
            parkLocation.accentColor = "KindaRed"
        } else if percentage >= 80 {
            parkLocation.accentColor = "Dark Orange"
        } else if percentage >= 60 {
            parkLocation.accentColor = "Second Orange"
        } else if percentage >= 50 {
            parkLocation.accentColor = "Icons"
        } else {
            parkLocation.accentColor = "Main Yellow"
        }
    }
    
}
extension String {
    func camelCaseToWords() -> String {
        return unicodeScalars.dropFirst().reduce(String(prefix(1))) {
            return CharacterSet.uppercaseLetters.contains($1)
                ? $0 + " " + String($1)
                : $0 + String($1)
        }
    }
}
