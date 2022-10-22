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
    
    func getParkLocations(_ city: String, completion: @escaping(Result<Void, Error>) -> Void) {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":city]
        
        Alamofire.Session.default.request("https://\(roadoutServerURL)/Parking/GetParkingLots.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                completion(.failure(EntityErrors.databaseFailure))
                return
            }
            let data = ("[" + response.value!.dropLast() + "]").data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Array<[String:Any]> {
                    dbParkLocations = [ParkLocation]()
                    for json in jsonArray {
                        dbParkLocations.append(ParkLocation(name: json["name"] as! String, rID: json["id"] as! String, latitude: Double(json["lat"] as! String)!, longitude: Double(json["lng"] as! String)!, totalSpots: Int(json["nrParkingSpots"] as! String)!, freeSpots: Int(json["freeParkingSpots"] as! String)!, sections: [ParkSection](), sectionImage: json["id"] as! String + ".Section", accentColor: colours.randomElement()!))
                    }
                    completion(.success(()))
                } else {
                    print("unknown error")
                    completion(.failure(EntityErrors.unknownError))
                }
            } catch let error as NSError {
                print(error)

                completion(.failure(EntityErrors.errorWithJson))
            }
        }
    }
    
    func getParkSections(_ location: String, completion: @escaping(Result<Void, Error>) -> Void) {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":location]
        
        Alamofire.Session.default.request("https://\(roadoutServerURL)/Parking/GetParkingSections.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                completion(.failure(EntityErrors.databaseFailure))
                return
            }
            let data = ("[" + response.value!.dropLast() + "]").data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Array<[String:Any]> {
                    dbParkSections = [ParkSection]()
                    for json in jsonArray {
                        let imagePoint = ParkSectionImagePoint(x: Int(json["iOSPointImage.x"] as! String)!, y: Int(json["iOSPointImage.y"] as! String)!)
                        dbParkSections.append(ParkSection(name: json["name"] as! String, totalSpots: Int(json["nrParkingSpots"] as! String)!, freeSpots: 0, rows: self.getNumbers(json["nrRows"] as! String), spots: [ParkSpot](), imagePoint: imagePoint, rID: json["sectionID"] as! String))
                    }
                    completion(.success(()))
                } else {
                    print("unknown error")
                    completion(.failure(EntityErrors.unknownError))
                }
            } catch let error as NSError {
                print(error)

                completion(.failure(EntityErrors.errorWithJson))
            }
        }
    }
    
    func getParkSpots(_ section: String, completion: @escaping(Result<Void, Error>) -> Void) {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":section]
        
        Alamofire.Session.default.request("https://\(roadoutServerURL)/Parking/GetSectionInf.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                completion(.failure(EntityErrors.databaseFailure))
                return
            }
            let data = ("[" + response.value!.dropLast() + "]").data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Array<[String:Any]> {
                    dbParkSpots = [ParkSpot]()
                    for json in jsonArray {
                        dbParkSpots.append(ParkSpot(state: Int(json["state"] as! String)!, number: Int(json["number"] as! String)!, rHash: "u82f0bc6m303-f80-h70-p0", rID: json["id"] as! String))
                    }
                    dbParkSpots.sort { $0.number < $1.number }
                    completion(.success(()))
                } else {
                    print("unknown error")
                    completion(.failure(EntityErrors.unknownError))
                }
            } catch let error as NSError {
                print(error)

                completion(.failure(EntityErrors.errorWithJson))
            }
        }
    }
    
    func getNumbers(_ strArray: String) -> [Int] {
        let stringRecordedArr = strArray.components(separatedBy: ",")
        return stringRecordedArr.map { Int($0)!}
    }
    
    func getFreeParkSpots(_ location: String, _ index: Int, completion: @escaping(Result<Void, Error>) -> Void) {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":location]
        
        Alamofire.Session.default.request("https://\(roadoutServerURL)/Parking/GetFreeParkingSpots.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                completion(.failure(EntityErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    if jsonArray["status"] as! String == "Success" {
                        parkLocations[index].freeSpots = Int(jsonArray["result"] as! String)!
                        completion(.success(()))
                    }
                }
            } catch let error as NSError {
                print(error)

                completion(.failure(EntityErrors.errorWithJson))
            }
        }
    }
    
    func decodeSpotID(_ spotID: String) -> [String] {
        var details = [String]()
        details = spotID.components(separatedBy: ".")
        details.remove(at: 0)
        details[0] = details[0].camelCaseToWords()
        return details
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
