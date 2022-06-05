//
//  ReservationManager.swift
//  RWUI WatchKit Extension
//
//  Created by David Retegan on 23.05.2022.
//

import Foundation
import Alamofire

class ReservationManager {
    
    static let sharedInstance = ReservationManager()
    
    enum ReservationErrors: Error {
        case databaseFailure
        case errorWithJson
        case networkError
        case unknownError
        case spotAlreadyTaken
    }
    
    var callResult: String!
    
    //-1 for not assigned, 0 is active, 1 is unlocked, 2 is cancelled, 3 is not active
    var isReservationActive = -1
    
    var reservationEndDate = Date()
    
    func checkForReservation(_ date: Date, userID: String, completion: @escaping(Result<Void, Error>) -> Void) {
        let _headers: HTTPHeaders = ["Content-Type":"application/json"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let convertedDate = dateFormatter.string(from: date)
        let params: Parameters = ["date": convertedDate, "userID": userID]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/CheckEndDate.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                completion(.failure(ReservationErrors.databaseFailure))
                self.isReservationActive = 2
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    self.callResult = (jsonArray["status"] as! String)
                    if self.callResult == "Success" {
                        if jsonArray["message"] as! String == "active" {
                            self.isReservationActive = 0
                            let formattedEndDate = jsonArray["endDate"] as! String
                            let convertedEndDate = dateFormatter.date(from: formattedEndDate)
                            self.reservationEndDate = convertedEndDate!
                        } else if jsonArray["message"] as! String == "not active" {
                            self.isReservationActive = 3
                        } else if jsonArray["message"] as! String == "cancelled" {
                            self.isReservationActive = 2
                        } else if jsonArray["message"] as! String == "unlocked" {
                            self.isReservationActive = 1
                        } else {
                            self.isReservationActive = -1
                        }
                        completion(.success(()))
                    } else {
                        print(jsonArray["status"]!)
                        completion(.failure(ReservationErrors.unknownError))
                        self.isReservationActive = -1
                    }
                }
            } catch let error as NSError {
                print(error)
                completion(.failure(ReservationErrors.errorWithJson))
                self.isReservationActive = -1
            }
        }
    }
    
    func unlockReservation(_ userID: String, date: Date, completion: @escaping(Result<Void, Error>) -> Void) {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let convertedDate = dateFormatter.string(from: date)
        let params : Parameters = ["userID": userID, "date": convertedDate]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/UnlockReservation.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                completion(.failure(ReservationErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    self.callResult = (jsonArray["status"] as! String)
                    if self.callResult == "Success" {
                        //Send message to iPhone
                        self.isReservationActive = 1
                        completion(.success(()))
                    } else {
                        print(jsonArray["status"]!)
                        completion(.failure(ReservationErrors.unknownError))
                    }
                }
            } catch let error as NSError {
                print(error)
                completion(.failure(ReservationErrors.errorWithJson))
            }
        }
    }
    
    
    
}
