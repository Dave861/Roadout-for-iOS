//
//  AuthManager.swift
//  Roadout
//
//  Created by David Retegan on 28.12.2021.
//

import Foundation
import Network
import CryptoKit
import Alamofire

class AuthManager {
    
    var callResult = "network error"
    var userID: String!
    
    var verifyCode = 0
    var dateToken = Date.yesterday
    
    static let sharedInstance = AuthManager()
    
    func sendRegisterData(_ email: String) {
        
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["email":email]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/VerifyEmail.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
            guard response.value != nil else {
                self.callResult = "database error"
                NotificationCenter.default.post(name: .manageServerSideRegisterID, object: nil)
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
                        self.verifyCode = Int(code)!
                        self.dateToken = formatter.date(from: token) ?? Date.yesterday
                        NotificationCenter.default.post(name: .manageServerSideRegisterID, object: nil)
                    } else {
                        if jsonArray["message"] as! String == "User already exists" {
                            self.callResult = "user exists"
                        }
                        NotificationCenter.default.post(name: .manageServerSideRegisterID, object: nil)
                    }
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    NotificationCenter.default.post(name: .manageServerSideRegisterID, object: nil)
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                NotificationCenter.default.post(name: .manageServerSideRegisterID, object: nil)
            }
        }
                
    }
    
    func deleteBadData(_ email: String) {
        
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["email":email]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/DeleteDataVerifyEmail.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
        }
    }
    
    func sendSignUpData(_ name: String, _ email: String, _ password: String) {
        
        let hashedPswd = MD5(string: password)
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["name":name,"email":email,"password":hashedPswd]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/userRegister.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
            guard response.value != nil else {
                self.callResult = "database error"
                NotificationCenter.default.post(name: .manageServerSideSignUpID, object: nil)
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    self.userID = String(jsonArray["id"] as! Int)
                    self.callResult = jsonArray["status"] as! String
                    NotificationCenter.default.post(name: .manageServerSideSignUpID, object: nil)
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    NotificationCenter.default.post(name: .manageServerSideSignUpID, object: nil)
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                NotificationCenter.default.post(name: .manageServerSideSignUpID, object: nil)
            }
        }
    }
    
    func sendSignInData(_ email: String, _ password: String) {
        
        let hashedPswd = MD5(string: password)
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["email":email,"password":hashedPswd]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/userLogin.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
            guard response.value != nil else {
                self.callResult = "database error"
                NotificationCenter.default.post(name: .manageServerSideSignInID, object: nil)
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    self.userID = jsonArray["id"] as? String
                    self.callResult = jsonArray["status"] as! String
                    NotificationCenter.default.post(name: .manageServerSideSignInID, object: nil)
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    NotificationCenter.default.post(name: .manageServerSideSignInID, object: nil)
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                NotificationCenter.default.post(name: .manageServerSideSignInID, object: nil)
            }
        }
    }
    
    func checkIfUserExists(with id: String) {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":id]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/IdExists.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
            guard response.value != nil else {
                print("database error")
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    if jsonArray["status"] as! String == "Success" && jsonArray["message"] as! String == "False" {
                        NotificationCenter.default.post(name: .userNotFoundID, object: nil)
                    } else if jsonArray["message"] as! String == "True" {
                        print("User exists")
                    }
                } else {
                    print("unknown error")
                }
            } catch let error as NSError {
                print(error.debugDescription)
                print("error with json")
            }
        }
    }
    
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    
}
