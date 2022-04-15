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
        
        Alamofire.Session.default.request("https://www.roadout.ro/Parking/GetParkingLots.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                completion(.failure(EntityErrors.databaseFailure))
                return
            }
            let data = ("[" + response.value!.dropLast() + "]").data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Array<[String:Any]> {
                    dbParkLocations = [ParkLocation]()
                    for json in jsonArray {
                        dbParkLocations.append(ParkLocation(name: json["name"] as! String, rID: json["id"] as! String, latitude: Double(json["lat"] as! String)!, longitude: Double(json["lng"] as! String)!, totalSpots: Int(json["nrParkingSpots"] as! String)!, freeSpots: Int(json["freeParkingSpots"] as! String)!, sections: [ParkSection](), sectionImage: json["id"] as! String + ".Section"))
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
        
        Alamofire.Session.default.request("https://www.roadout.ro/Parking/GetParkingSections.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                completion(.failure(EntityErrors.databaseFailure))
                return
            }
            let data = ("[" + response.value!.dropLast() + "]").data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Array<[String:Any]> {
                    dbParkSections = [ParkSection]()
                    for json in jsonArray {
                        dbParkSections.append(ParkSection(name: json["name"] as! String, totalSpots: Int(json["nrParkingSpots"] as! String)!, freeSpots: 0, rows: self.getNumbers(json["nrRows"] as! String), spots: [ParkSpot](), rID: json["sectionID"] as! String))
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
        
        Alamofire.Session.default.request("https://www.roadout.ro/Parking/GetSectionInf.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            print("TRYING")
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
            guard response.value != nil else {
                completion(.failure(EntityErrors.databaseFailure))
                return
            }
            let data = ("[" + response.value!.dropLast() + "]").data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Array<[String:Any]> {
                    dbParkSpots = [ParkSpot]()
                    for json in jsonArray {
                        dbParkSpots.append(ParkSpot(state: Int(json["state"] as! String)!, number: Int(json["number"] as! String)!, rID: json["id"] as! String))
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
    
}
