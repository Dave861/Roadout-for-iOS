//
//  ReservationManager.swift
//  Roadout
//
//  Created by David Retegan on 25.12.2021.
//

import Foundation
import Alamofire

var timerSeconds = 0 //Used to help with notifications
var showUnlockedBar = false

class ReservationManager {
    
    static let sharedInstance = ReservationManager()
    
    var reservationTimer: Timer!
    
    enum ReservationErrors: Error {
        case databaseFailure
        case errorWithJson
        case networkError
        case unknownError
        case spotAlreadyTaken
    }
    
    var callResult: String!
    var isReservationActive = 2 //2 for not assigned, 1 is false, 0 is true
    var reservationEndDate = Date()
    var delayWasMade = false
  
    
    func makeReservation(_ date: Date, time: Int, spotID: String, payment: Int, userID: String, completion: @escaping(Result<Void, Error>) -> Void) {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let convertedDate = dateFormatter.string(from: date)
        let params : Parameters = ["date": convertedDate, "time": "\(time)", "spotID": spotID, "payment": "\(payment)", "userID": userID]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/InsertReservation.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                completion(.failure(ReservationErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    self.callResult = (jsonArray["status"] as! String)
                    if self.callResult == "Success" {
                        if UserPrefsUtils.sharedInstance.reservationNotificationsEnabled() {
                            NotificationHelper.sharedInstance.scheduleReservationNotification()
                        }
                        self.reservationEndDate = date.addingTimeInterval(TimeInterval(time*60))
                        NotificationCenter.default.post(name: .showPaidBarID, object: nil)
                        self.reservationTimer = Timer(fireAt: date.addingTimeInterval(TimeInterval(time*60)), interval: 0, target: self, selector: #selector(self.endReservation), userInfo: nil, repeats: false)
                        DispatchQueue.main.async {
                            RunLoop.main.add(self.reservationTimer, forMode: .common)
                        }
                        completion(.success(()))
                    } else {
                        print(jsonArray["status"]!)
                        completion(.failure(ReservationErrors.spotAlreadyTaken))
                    }
                }
            } catch let error as NSError {
                print(error)

                completion(.failure(ReservationErrors.errorWithJson))
            }
        }
    }
    
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
                            if self.reservationTimer == nil || self.reservationTimer.isValid == false {
                                let formattedEndDate = jsonArray["endDate"] as! String
                                let convertedEndDate = dateFormatter.date(from: formattedEndDate)
                                self.reservationEndDate = convertedEndDate!
                                self.reservationTimer = Timer(fireAt: convertedEndDate!, interval: 0, target: self, selector: #selector(self.endReservation), userInfo: nil, repeats: false)
                                DispatchQueue.main.async {
                                    RunLoop.main.add(self.reservationTimer, forMode: .common)
                                }
                                NotificationCenter.default.post(name: .updateReservationTimeLabelID, object: nil)
                            }
                        } else if jsonArray["message"] as! String == "not active" {
                            self.isReservationActive = 1
                        } else if jsonArray["message"] as! String == "canceled" {
                            self.isReservationActive = 1
                        } else if jsonArray["message"] as! String == "unlocked" {
                            self.isReservationActive = 1
                        } else {
                            self.isReservationActive = 2
                        }
                        completion(.success(()))
                    } else {
                        print(jsonArray["status"]!)
                        completion(.failure(ReservationErrors.unknownError))
                        self.isReservationActive = 2
                    }
                }
            } catch let error as NSError {
                print(error)
                completion(.failure(ReservationErrors.errorWithJson))
                self.isReservationActive = 2
            }
        }
    }
    
    func delayReservation(_ date: Date, minutes: Int, userID: String, completion: @escaping(Result<Void, Error>) -> Void) {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let convertedDate = dateFormatter.string(from: date)
        let params : Parameters = ["date": convertedDate, "minutes":"\(minutes)", "userID": userID]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/DelayReservation.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                completion(.failure(ReservationErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    self.callResult = (jsonArray["status"] as! String)
                    if self.callResult == "Success" {
                        if self.reservationTimer != nil {
                            self.reservationTimer.invalidate()
                        }
                        let oldEndDate = jsonArray["endDate"] as! String
                        let convertedOldEndDate = dateFormatter.date(from: oldEndDate)!
                        let newEndDate = convertedOldEndDate.addingTimeInterval(TimeInterval(minutes*60))
                        print(newEndDate)
                        self.reservationEndDate = newEndDate
                        self.reservationTimer = Timer(fireAt: newEndDate, interval: 0, target: self, selector: #selector(self.endReservation), userInfo: nil, repeats: false)
                        DispatchQueue.main.async {
                            RunLoop.main.add(self.reservationTimer, forMode: .common)
                        }
                        timerSeconds = Int(newEndDate.timeIntervalSinceNow)
                        NotificationHelper.sharedInstance.cancelReservationNotification()
                        if UserPrefsUtils.sharedInstance.reservationNotificationsEnabled() {
                            NotificationHelper.sharedInstance.scheduleReservationNotification()
                        }
                        NotificationCenter.default.post(name: .showPaidBarID, object: nil)
                        NotificationCenter.default.post(name: .updateReservationTimeLabelID, object: nil)
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
    
    func unlockReservation() {
        //Do this on success
        if self.reservationTimer != nil {
            self.reservationTimer.invalidate()
        }
        NotificationHelper.sharedInstance.cancelReservationNotification()
        NotificationCenter.default.post(name: .showUnlockedBarID, object: nil)
    }
    
    func cancelReservation(_ userID: String, completion: @escaping(Result<Void, Error>) -> Void) {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["userID": userID]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/CancelReservation.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                completion(.failure(ReservationErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    self.callResult = (jsonArray["status"] as! String)
                    if self.callResult == "Success" {
                        if self.reservationTimer != nil {
                            self.reservationTimer.invalidate()
                        }
                        NotificationHelper.sharedInstance.cancelReservationNotification()
                        NotificationCenter.default.post(name: .showCancelledBarID, object: nil)
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
    
    func checkReservationWasDelayed(_ userID: String, completion: @escaping(Result<Void, Error>) -> Void) {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["userID": userID]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/CheckDelay.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                completion(.failure(ReservationErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    self.callResult = (jsonArray["status"] as! String)
                    if self.callResult == "Success" {
                        if jsonArray["message"] as! String == "Delay was not made" {
                            self.delayWasMade = false
                        } else {
                            self.delayWasMade = true
                        }
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
    
    @objc func endReservation() {
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        ReservationManager.sharedInstance.checkForReservation(Date(), userID: id) { result in
            switch result {
                case .success():
                    if ReservationManager.sharedInstance.isReservationActive == 1 {
                        NotificationCenter.default.post(name: .showUnlockedBarID, object: nil)
                        showUnlockedBar = true
                    }
                case .failure(let err):
                    print(err)
            }
        }
    }
    
}
