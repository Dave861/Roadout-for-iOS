//
//  ReservationManager.swift
//  Roadout
//
//  Created by David Retegan on 25.12.2021.
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
        
    ///-1 for not assigned, 0 is active, 1 is unlocked, 2 is cancelled, 3 is not active
    var isReservationActive = -1
    var reservationTimer: Timer!
    var reservationEndDate = Date()
    
    private init() {}
  
    //MARK: - Create & Check Functions -
    
    func makeReservationAsync(date: Date, time: Int, spotID: String, payment: Int, userID: String) async throws {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let convertedDate = dateFormatter.string(from: date)
        let params : Parameters = ["date": convertedDate, "time": "\(time)", "spotID": spotID, "payment": "\(payment)", "userID": userID]
        
        let reservationRequest = AF.request("https://\(roadoutServerURL)/Authentification/InsertReservation.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await reservationRequest.serializingString().value
        } catch {
            throw ReservationErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw ReservationErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String == "Success" {
            NotificationHelper.sharedInstance.scheduleReservationNotification()
            NotificationHelper.sharedInstance.scheduleLocationNotification()
            self.reservationEndDate = date.addingTimeInterval(TimeInterval(time*60))
            
            //Remove once we have push notifications
            //Used to update the UI if the app is running while the reservation ends
            self.reservationTimer = Timer(fireAt: date.addingTimeInterval(TimeInterval(time*60)), interval: 0, target: self, selector: #selector(self.endReservation), userInfo: nil, repeats: false)
            DispatchQueue.main.async {
                RunLoop.main.add(self.reservationTimer, forMode: .common)
            }
            self.isReservationActive = 0
        } else {
            throw ReservationErrors.spotAlreadyTaken
        }
    }
    
    func checkForReservationAsync(date: Date, userID: String) async throws {
        suspendSearch = true
        
        let _headers: HTTPHeaders = ["Content-Type":"application/json"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let convertedDate = dateFormatter.string(from: date)
        let params: Parameters = ["date": convertedDate, "userID": userID]
        
        let checkRequest = AF.request("https://\(roadoutServerURL)/Authentification/CheckEndDate.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await checkRequest.serializingString().value
        } catch {
            suspendSearch = false
            throw ReservationErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            suspendSearch = false
            throw ReservationErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String == "Success" {
            if jsonArray["message"] as! String == "active" {
                //There is an active reservation
                selectedSpot.rID = jsonArray["spotID"] as? String ?? "Roadout.Parking.P.1"
                //selectedSpot.rHash = jsonArray["spotHash"] as? String - once it exists
                
                let formattedEndDate = jsonArray["endDate"] as! String
                let convertedEndDate = dateFormatter.date(from: formattedEndDate)
                
                if self.reservationTimer == nil || self.reservationTimer.isValid == false {
                    self.reservationEndDate = convertedEndDate!
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .updateReservationTimeLabelID, object: nil)
                    }
                    //Remove once we have push notifications
                    //Used to update the UI if the app is running while the reservation ends
                    self.reservationTimer = Timer(fireAt: convertedEndDate!, interval: 0, target: self, selector: #selector(self.endReservation), userInfo: nil, repeats: false)
                    DispatchQueue.main.async {
                        RunLoop.main.add(self.reservationTimer, forMode: .common)
                    }
                } else if self.reservationTimer.fireDate != convertedEndDate {
                    self.reservationEndDate = convertedEndDate!
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .updateReservationTimeLabelID, object: nil)
                    }
                    //Remove once we have push notifications
                    //Used to update the UI if the app is running while the reservation ends
                    self.reservationTimer.invalidate()
                    self.reservationTimer = Timer(fireAt: convertedEndDate!, interval: 0, target: self, selector: #selector(self.endReservation), userInfo: nil, repeats: false)
                    DispatchQueue.main.async {
                        RunLoop.main.add(self.reservationTimer, forMode: .common)
                    }

                    //Manage notifications
                    guard convertedEndDate != nil else { return }
                    reservationTime = Int(convertedEndDate!.timeIntervalSinceNow)
                    NotificationHelper.sharedInstance.cancelReservationNotification()
                    NotificationHelper.sharedInstance.scheduleReservationNotification()
                }
                self.isReservationActive = 0
            } else if jsonArray["message"] as! String == "not active" {
                //There isn't an active reservation
                self.isReservationActive = 3
                NotificationHelper.sharedInstance.cancelLocationNotification()
                if #available(iOS 16.1, *) {
                    LiveActivityHelper.sharedInstance.endLiveActivity()
                }
            } else if jsonArray["message"] as! String == "cancelled" {
                //Most recent reservation was cancelled
                if self.reservationTimer != nil {
                    self.reservationTimer.invalidate()
                }
                NotificationHelper.sharedInstance.cancelReservationNotification()
                NotificationHelper.sharedInstance.cancelLocationNotification()
                if #available(iOS 16.1, *) {
                    LiveActivityHelper.sharedInstance.endLiveActivity()
                }
                self.isReservationActive = 2
            } else if jsonArray["message"] as! String == "unlocked" {
                //Most recent reservation was unlocked
                if self.reservationTimer != nil {
                    self.reservationTimer.invalidate()
                }
                NotificationHelper.sharedInstance.cancelReservationNotification()
                NotificationHelper.sharedInstance.cancelLocationNotification()
                if #available(iOS 16.1, *) {
                    LiveActivityHelper.sharedInstance.endLiveActivity()
                }
                self.isReservationActive = 1
            } else {
                //Error retrieving
                NotificationHelper.sharedInstance.cancelLocationNotification()
                if #available(iOS 16.1, *) {
                    LiveActivityHelper.sharedInstance.endLiveActivity()
                }
                self.isReservationActive = -1
            }
        } else {
            self.isReservationActive = -1
            suspendSearch = false
            throw ReservationErrors.unknownError
        }
        suspendSearch = false
    }
    
    //MARK: - Delay Functions -
    
    func delayReservationAsync(date: Date, minutes: Int, userID: String) async throws {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let convertedDate = dateFormatter.string(from: date)
        let params : Parameters = ["date": convertedDate, "minutes":"\(minutes)", "userID": userID]
        
        let delayRequest = AF.request("https://\(roadoutServerURL)/Authentification/DelayReservation.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await delayRequest.serializingString().value
        } catch {
            throw ReservationErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw ReservationErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String == "Success" {
            let oldEndDate = jsonArray["endDate"] as! String
            let convertedOldEndDate = dateFormatter.date(from: oldEndDate)!
            let newEndDate = convertedOldEndDate.addingTimeInterval(TimeInterval(minutes*60))
            self.reservationEndDate = newEndDate
            
            //Remove once we have push notifications
            //Used to update the UI if the app is running while the reservation ends
            if self.reservationTimer != nil {
                self.reservationTimer.invalidate()
            }
            self.reservationTimer = Timer(fireAt: newEndDate, interval: 0, target: self, selector: #selector(self.endReservation), userInfo: nil, repeats: false)
            DispatchQueue.main.async {
                RunLoop.main.add(self.reservationTimer, forMode: .common)
            }
            
            reservationTime = Int(newEndDate.timeIntervalSinceNow)
            NotificationHelper.sharedInstance.cancelReservationNotification()
            NotificationHelper.sharedInstance.scheduleReservationNotification()
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .updateReservationTimeLabelID, object: nil)
            }
        } else {
            throw ReservationErrors.unknownError
        }
    }
    
    func checkReservationWasDelayedAsync(userID: String) async throws -> Bool {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["userID": userID]
        
        let checkRequest = AF.request("https://\(roadoutServerURL)/Authentification/CheckDelay.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await checkRequest.serializingString().value
        } catch {
            throw ReservationErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw ReservationErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String == "Success" {
            if jsonArray["message"] as! String == "Delay was not made" {
                return false
            } else {
                return true
            }
        } else {
            throw ReservationErrors.unknownError
        }
    }
    
    //MARK: - End Functions -
    
    func unlockReservationAsync(userID: String, date: Date) async throws {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let convertedDate = dateFormatter.string(from: date)
        let params : Parameters = ["userID": userID, "date": convertedDate]
        
        let unlockRequest = AF.request("https://\(roadoutServerURL)/Authentification/UnlockReservation.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await unlockRequest.serializingString().value
        } catch {
            throw ReservationErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw ReservationErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String != "Success" {
            throw ReservationErrors.unknownError
        }
        self.isReservationActive = 1
    }
    
    func cancelReservationAsync(userID: String, date: Date) async throws {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let convertedDate = dateFormatter.string(from: date)
        let params : Parameters = ["userID": userID, "date": convertedDate]
        
        let cancelRequest = AF.request("https://\(roadoutServerURL)/Authentification/CancelReservation.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await cancelRequest.serializingString().value
        } catch {
            throw ReservationErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw ReservationErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String != "Success" {
            throw ReservationErrors.unknownError
        }
        self.isReservationActive = 2
    }
    
    @objc func endReservation() {
        let id = UserDefaults.roadout!.object(forKey: "eu.roadout.Roadout.userID") as! String
        NotificationCenter.default.post(name: .btBarrierDown, object: nil)
        Task {
            do {
                try await ReservationManager.sharedInstance.checkForReservationAsync(date: Date(), userID: id)
                if ReservationManager.sharedInstance.isReservationActive == 0 {
                    //active
                    NotificationCenter.default.post(name: .addReservationCardID, object: nil)
                } else if ReservationManager.sharedInstance.isReservationActive == 1 {
                    //unlocked
                    NotificationCenter.default.post(name: .showUnlockedViewID, object: nil)
                    if #available(iOS 16.1, *) {
                        LiveActivityHelper.sharedInstance.endLiveActivity()
                    }
                } else if ReservationManager.sharedInstance.isReservationActive == 2 {
                    //cancelled
                    NotificationCenter.default.post(name: .showCancelledBarID, object: nil)
                    if #available(iOS 16.1, *) {
                        LiveActivityHelper.sharedInstance.endLiveActivity()
                    }
                } else if ReservationManager.sharedInstance.isReservationActive == 3 {
                    //not active
                    NotificationCenter.default.post(name: .returnFromReservationID, object: nil)
                    if #available(iOS 16.1, *) {
                        LiveActivityHelper.sharedInstance.endLiveActivity()
                    }
                } else {
                    //error
                    NotificationCenter.default.post(name: .returnToSearchBarWithErrorID, object: nil)
                    if #available(iOS 16.1, *) {
                        LiveActivityHelper.sharedInstance.endLiveActivity()
                    }
                }
            } catch let err {
                print(err)
            }
        }
    }
}
