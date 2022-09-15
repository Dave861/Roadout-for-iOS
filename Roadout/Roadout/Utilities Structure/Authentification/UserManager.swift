//
//  UserManager.swift
//  Roadout
//
//  Created by David Retegan on 06.01.2022.
//

import Foundation
import Network
import CryptoKit
import Alamofire

class UserManager {
        
    static let sharedInstance = UserManager()
    
    var callResult = "network error"
    
    //Which screen handles with alerts when user forgets password
    var forgotResumeScreen = "Sign In"
    
    var resetCode = 0
    var dateToken = Date.yesterday
    var userEmail = ""
    
    //MARK: -User Data-
    var userName = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.UserName") ?? "roadout_user_name"
    
    enum UserDBErrors: Error {
        case databaseFailure
        case userExistsFailure
        case errorWithJson
        case networkError
        case unknownError
        case userDoesNotExist
    }
    
    
    func updateName(_ id: String, _ name: String, completion: @escaping(Result<Void, Error>) -> Void) {
        
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":id,"name":name]
        
        Alamofire.Session.default.request("http://roadout-reteganda.pitunnel.com/Authentification/UpdateName.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                self.callResult = "database error"
                completion(.failure(UserDBErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    self.callResult = jsonArray["status"] as! String
                    if self.callResult == "Success" {
                        completion(.success(()))
                    } else {
                        completion(.failure(UserDBErrors.userDoesNotExist))
                    }
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    completion(.failure(UserDBErrors.unknownError))
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                completion(.failure(UserDBErrors.errorWithJson))
            }
        }
        
    }
    
    func updatePassword( _ id: String, _ oldPsw: String, _ newPsw: String, completion: @escaping(Result<Void, Error>) -> Void) {
        
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let hashedOldPswd = MD5(string: oldPsw)
        let hashedNewPswd = MD5(string: newPsw)
        let params : Parameters = ["id":id,"oldPsw":hashedOldPswd,"newPsw":hashedNewPswd]
    
        Alamofire.Session.default.request("http://roadout-reteganda.pitunnel.com/Authentification/UpdatePassword.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                self.callResult = "database error"
                completion(.failure(UserDBErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    self.callResult = jsonArray["status"] as! String
                    if self.callResult == "Success" {
                        completion(.success(()))
                    } else {
                        completion(.failure(UserDBErrors.userDoesNotExist))
                    }
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    completion(.failure(UserDBErrors.unknownError))
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                completion(.failure(UserDBErrors.errorWithJson))
            }
        }
        
    }
    
    func deleteAccount(_ email: String, _ password: String, completion: @escaping(Result<Void, Error>) -> Void) {
        
        let hashedPswd = MD5(string: password)
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["email":email,"password":hashedPswd]
        
        Alamofire.Session.default.request("http://roadout-reteganda.pitunnel.com/Authentification/DeleteAccount.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                self.callResult = "database error"
                completion(.failure(UserDBErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    self.callResult = jsonArray["status"] as! String
                    if self.callResult == "Success" {
                        completion(.success(()))
                    } else {
                        completion(.failure(UserDBErrors.userDoesNotExist))
                    }
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    completion(.failure(UserDBErrors.unknownError))
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                completion(.failure(UserDBErrors.errorWithJson))
            }
        }
    }
    
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    func getUserName(_ id: String, completion: @escaping(Result<Void, Error>) -> Void) {
        
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":id]
        
        Alamofire.Session.default.request("http://roadout-reteganda.pitunnel.com/Authentification/GetUserData.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                self.callResult = "database error"
                completion(.failure(UserDBErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    self.callResult = jsonArray["status"] as! String
                    if self.callResult == "Success" {
                        self.userName = jsonArray["name"] as! String
                        self.userEmail = jsonArray["email"] as! String
                        UserDefaults.roadout!.set(self.userEmail, forKey: "ro.roadout.Roadout.UserMail")
                        UserDefaults.roadout!.set(self.userName, forKey: "ro.roadout.Roadout.UserName")
                        completion(.success(()))
                    } else {
                        completion(.failure(UserDBErrors.userDoesNotExist))
                    }
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    completion(.failure(UserDBErrors.unknownError))
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                completion(.failure(UserDBErrors.errorWithJson))
                
            }
        }
    }
    
    func sendForgotData(_ email: String, completion: @escaping(Result<Void, Error>) -> Void) {
        
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["email":email]
        
        Alamofire.Session.default.request("http://roadout-reteganda.pitunnel.com/Authentification/ForgotPassword.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                self.callResult = "database error"
                completion(.failure(UserDBErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    self.callResult = jsonArray["status"] as! String
                    if self.callResult == "Success" {
                        let code = jsonArray["accessCode"] as! String
                        let token = jsonArray["token"] as! String
                        let formatter = DateFormatter()
                        let dateFormat = "yyyy-MM-dd HH:mm:ss"
                        formatter.dateFormat = dateFormat
                        self.resetCode = Int(code)!
                        self.dateToken = formatter.date(from: token) ?? Date.yesterday
                        completion(.success(()))
                    } else {
                        completion(.failure(UserDBErrors.unknownError))
                    }
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    completion(.failure(UserDBErrors.unknownError))
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                completion(.failure(UserDBErrors.errorWithJson))
            }
        }
        
    }
    
    func resetPassword(_ password: String, completion: @escaping(Result<Void, Error>) -> Void) {
        
        var email = UserManager.sharedInstance.userEmail
        if email == "" {
            email = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.UserMail") ?? "roadout_impossible."
        }
        print(email)
        print(password)
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let hashedPswd = MD5(string: password)
        let params : Parameters = ["email":email,"psw":hashedPswd]
        
        Alamofire.Session.default.request("http://roadout-reteganda.pitunnel.com/Authentification/ResetPassword.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                self.callResult = "database error"
                completion(.failure(UserDBErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    self.callResult = jsonArray["status"] as! String
                    if self.callResult == "Success" {
                        completion(.success(()))
                    } else {
                        completion(.failure(UserDBErrors.unknownError))
                    }
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    completion(.failure(UserDBErrors.unknownError))
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                completion(.failure(UserDBErrors.errorWithJson))
            }
        }
    }
    
}
