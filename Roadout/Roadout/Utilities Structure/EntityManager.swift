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
    
    //MARK: - Get & Set Functions -
    
    func getParkLocationsAsync(_ city: String) async throws -> String {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id": city]
        let downloadRequest = AF.request("https://\(roadoutServerURL)/Parking/GetParkingLots.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        return try await downloadRequest.serializingString().value
    }
    
    func saveParkLocationsAsync(_ city: String) async throws {
        var responseJson: String!
        do {
            responseJson = try await getParkLocationsAsync(city)
        } catch {
            throw EntityErrors.databaseFailure
        }
        
        let data = ("[" + responseJson.dropLast() + "]").data(using: .utf8)!
        var jsonArray: Array<[String:Any]>!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Array<[String:Any]>
        } catch {
            throw EntityErrors.errorWithJson
        }
        
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
    }
    
    func getParkSectionsAsync(_ location: String) async throws -> String {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":location]
        let downloadRequest = AF.request("https://\(roadoutServerURL)/Parking/GetParkingSections.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        return try await downloadRequest.serializingString().value
    }
    
    func saveParkSectionsAsync(_ location: String) async throws {
        var responseJson: String!
        do {
            responseJson = try await getParkSectionsAsync(location)
        } catch {
            throw EntityErrors.databaseFailure
        }
        
        let data = ("[" + responseJson.dropLast() + "]").data(using: .utf8)!
        var jsonArray: Array<[String:Any]>!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Array<[String:Any]>
        } catch {
            throw EntityErrors.errorWithJson
        }
        
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
    }
    
    func getParkSpotsAsync(_ section: String) async throws -> String {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":section]
        let downloadRequest = AF.request("https://\(roadoutServerURL)/Parking/GetSectionInf.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        return try await downloadRequest.serializingString().value
    }
    
    func saveParkSpotsAsync(_ section: String) async throws {
        var responseJson: String!
        do {
            responseJson = try await getParkSpotsAsync(section)
        } catch {
            throw EntityErrors.databaseFailure
        }
        
        let data = ("[" + responseJson.dropLast() + "]").data(using: .utf8)!
        var jsonArray: Array<[String:Any]>!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Array<[String:Any]>
        } catch {
            throw EntityErrors.errorWithJson
        }
        
        dbParkSpots = [ParkSpot]()
        for json in jsonArray {
            dbParkSpots.append(
                ParkSpot(state: Int(json["state"] as! String)!,
                         number: Int(json["number"] as! String)!,
                         rHash: "u82f0ftyjk0w-f120-h20-p0", //get from db
                         rID: json["id"] as! String))
        }
        dbParkSpots.sort { $0.number < $1.number }
    }
    
    func getNumbers(_ strArray: String) -> [Int] {
        let stringRecordedArr = strArray.components(separatedBy: ",")
        return stringRecordedArr.map { Int($0)!}
    }
    
    //MARK: - Update Functions -
    
    func getFreeParkSpotsAsync(_ location: String) async throws -> String {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":location]
        let downloadRequest = AF.request("https://\(roadoutServerURL)/Parking/GetFreeParkingSpots.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        return try await downloadRequest.serializingString().value
    }
    
    func updateFreeParkSpotsAsync(_ location: String, _ index: Int) async throws {
        var responseJson: String!
        do {
            responseJson = try await getFreeParkSpotsAsync(location)
        } catch {
            throw EntityErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw EntityErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String == "Success" {
            parkLocations[index].freeSpots = Int(jsonArray["result"] as! String)!
            self.makeAccentColor(parkLocation: &parkLocations[index])
        } else {
            throw EntityErrors.unknownError
        }
    }
    
    //MARK: - Utilities -
    
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
            parkLocation.accentColor = "Kinda Red"
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
