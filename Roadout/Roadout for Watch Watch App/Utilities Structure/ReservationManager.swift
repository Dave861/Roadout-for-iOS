//
//  ReservationManager.swift
//  Roadout for Watch Watch App
//
//  Created by David Retegan on 23.10.2022.
//

import Foundation
import Alamofire

var roadoutServerURL = "9a112b87d5a3b6a1.p50.rt3.io"

struct ParkingReservationData: Identifiable {
    public var id: Int
    
    public var rID: String
    public var reservationStatus: Int
    public var reservationEndDate: Date
}

class ReservationManager: ObservableObject {
    
    @Published var reservationData = ParkingReservationData(id: 0, rID: "", reservationStatus: -5, reservationEndDate: Date())
    
    var callResult: String!
    
    //-1 for not assigned, 0 is active, 1 is unlocked, 2 is cancelled, 3 is not active
    var isReservationActive = -1

    init() {
        if UserDefaults.roadout.string(forKey: "ro.roadout.Roadout.userID") != nil {
            getReservationData(Date(), userID: UserDefaults.roadout.string(forKey: "ro.roadout.Roadout.userID")!) { result in
                switch result {
                case .success():
                    self.reservationData.reservationStatus = self.isReservationActive
                case .failure(let err):
                    print(err)
                    self.reservationData.reservationStatus = -1
                }
                print(self.reservationData.reservationStatus)
            }
        }
    }
    
    enum ReservationErrors: Error {
        case databaseFailure
        case errorWithJson
        case networkError
        case unknownError
        case spotAlreadyTaken
    }
    
    func getReservationData(_ date: Date, userID: String, completion: @escaping(Result<Void, Error>) -> Void) {
        let _headers: HTTPHeaders = ["Content-Type":"application/json"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let convertedDate = dateFormatter.string(from: date)
        let params: Parameters = ["date": convertedDate, "userID": userID]
        
        Alamofire.Session.default.request("https://\(roadoutServerURL)/Authentification/CheckEndDate.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                self.isReservationActive = -1
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    self.callResult = (jsonArray["status"] as! String)
                    if self.callResult == "Success" {
                        //Could get to server successfully
                        if jsonArray["message"] as! String == "active" {
                            //There is an active reservation
                            self.reservationData.rID = jsonArray["spotID"] as? String ?? ""
                            let formattedEndDate = jsonArray["endDate"] as! String
                            let convertedEndDate = dateFormatter.date(from: formattedEndDate)
                            self.reservationData.reservationEndDate = convertedEndDate ?? Date()
                            
                            self.isReservationActive = 0
                        } else if jsonArray["message"] as! String == "not active" {
                            //There isn't an active reservation
                            self.isReservationActive = 3
                        } else if jsonArray["message"] as! String == "cancelled" {
                            //Most recent reservation was cancelled
                            self.isReservationActive = 2
                        } else if jsonArray["message"] as! String == "unlocked" {
                            //Most recent reservation was unlocked
                            self.reservationData.rID = jsonArray["spotID"] as? String ?? ""
                            let formattedEndDate = jsonArray["endDate"] as! String
                            let convertedEndDate = dateFormatter.date(from: formattedEndDate)
                            self.reservationData.reservationEndDate = convertedEndDate ?? Date()
                            
                            self.isReservationActive = 1
                        } else {
                            //Error retrieving
                            self.isReservationActive = -1
                        }
                        completion(.success(()))
                    } else {
                        print(jsonArray["status"]!)
                        self.isReservationActive = -1
                        completion(.failure(ReservationErrors.unknownError))
                    }
                }
            } catch let error as NSError {
                print(error)
                self.isReservationActive = -1
                completion(.failure(ReservationErrors.errorWithJson))
            }
        }
    }

    func unlockReservation() {
        
    }
    
}
