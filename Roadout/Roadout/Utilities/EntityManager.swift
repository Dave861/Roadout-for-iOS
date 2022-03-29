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
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
            guard response.value != nil else {
                //self.callResult = "database error"
                //completion(.failure(AuthErrors.databaseFailure))
                return
            }
            let data = ("[" + response.value! + "]").data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    //if self.callResult == "Success" {
                        
                       // completion(.success(()))
                    //}
                } else {
                    print("unknown error")

                    //  completion(.failure(AuthErrors.unknownError))
                }
            } catch let error as NSError {
                print(error)

//                completion(.failure(AuthErrors.errorWithJson))
            }
        }
    }
    
    func getSections(in: ParkLocation) {
        
    }
    
    func getSpotsInLocation(in: ParkLocation) {
        
    }
    
    func getSpots(in: ParkSection) {
        
    }
    
}
