//
//  ReservationManager.swift
//  Roadout for Watch Watch App
//
//  Created by David Retegan on 23.10.2022.
//

import Foundation
import Alamofire

var roadoutServerURL = "roadout-for-db-2x8o3.ondigitalocean.app"

struct ParkingReservationData: Identifiable {
    public var id: Int
    
    public var rID: String
    public var reservationStatus: Int
    public var reservationEndDate: Date
}

class ReservationManager: ObservableObject {
    
    @Published var reservationData = ParkingReservationData(id: 0, rID: "", reservationStatus: -5, reservationEndDate: Date())
        
    //-1 for not assigned, 0 is active, 1 is unlocked, 2 is cancelled, 3 is not active
    var isReservationActive = -1

    init() {
        if UserDefaults.roadout.string(forKey: "ro.roadout.Roadout.userID") != nil {
            let id = UserDefaults.roadout.string(forKey: "ro.roadout.Roadout.userID")!
            Task {
                do {
                    try await getReservationDataAsync(Date(), userID: id)
                    self.reservationData.reservationStatus = self.isReservationActive
                } catch let err {
                    print(err)
                    self.reservationData.reservationStatus = -1
                }
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
    
    func getReservationDataAsync(_ date: Date, userID: String) async throws {
        let _headers: HTTPHeaders = ["Content-Type":"application/json"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let convertedDate = dateFormatter.string(from: date)
        let params: Parameters = ["date": convertedDate, "userID": userID]
        
        let getRequest = AF.request("https://\(roadoutServerURL)/Authentification/CheckEndDate.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await getRequest.serializingString().value
        } catch {
            self.isReservationActive = -1
            throw ReservationErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            self.isReservationActive = -1
            throw ReservationErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String == "Success" {
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
        } else {
            self.isReservationActive = -1
            throw ReservationErrors.unknownError
        }
    }

    func unlockReservation() {
        
    }
    
}
