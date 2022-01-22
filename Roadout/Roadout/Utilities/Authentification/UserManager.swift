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
    var userName = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.UserName") ?? "User Name"
    
    
    func updateName(_ id: String, _ name: String) {
        
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":id,"name":name]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/UpdateName.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
            guard response.value != nil else {
                self.callResult = "database error"
                NotificationCenter.default.post(name: .manageServerSideUpdateNameID, object: nil)
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    self.callResult = jsonArray["status"] as! String
                    NotificationCenter.default.post(name: .manageServerSideUpdateNameID, object: nil)
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    NotificationCenter.default.post(name: .manageServerSideUpdateNameID, object: nil)
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                NotificationCenter.default.post(name: .manageServerSideUpdateNameID, object: nil)
            }
        }
        
    }
    
    func updatePassword( _ id: String, _ oldPsw: String, _ newPsw: String) {
        
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let hashedOldPswd = MD5(string: oldPsw)
        let hashedNewPswd = MD5(string: newPsw)
        let params : Parameters = ["id":id,"oldPsw":hashedOldPswd,"newPsw":hashedNewPswd]
    
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/UpdatePassword.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
            guard response.value != nil else {
                self.callResult = "database error"
                NotificationCenter.default.post(name: .manageServerSideUpdatePswID, object: nil)
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    self.callResult = jsonArray["status"] as! String
                    NotificationCenter.default.post(name: .manageServerSideUpdatePswID, object: nil)
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    NotificationCenter.default.post(name: .manageServerSideUpdatePswID, object: nil)
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                NotificationCenter.default.post(name: .manageServerSideUpdatePswID, object: nil)
            }
        }
        
    }
    
    func deleteAccount(_ email: String, _ password: String) {
        
        let hashedPswd = MD5(string: password)
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["email":email,"password":hashedPswd]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/DeleteAccount.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
            guard response.value != nil else {
                self.callResult = "database error"
                NotificationCenter.default.post(name: .manageServerSideDeleteID, object: nil)
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    self.callResult = jsonArray["status"] as! String
                    NotificationCenter.default.post(name: .manageServerSideDeleteID, object: nil)
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    NotificationCenter.default.post(name: .manageServerSideDeleteID, object: nil)
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                NotificationCenter.default.post(name: .manageServerSideDeleteID, object: nil)
            }
        }
    }
    
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
    
    func getUserName(_ id: String) {
        
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":id]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/GetUserData.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
            guard response.value != nil else {
                self.callResult = "database error"
                
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
                    }
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                
            }
        }
    }
    
    func sendForgotData(_ email: String) {
        
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["email":email]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/ForgotPassword.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
            guard response.value != nil else {
                self.callResult = "database error"
                NotificationCenter.default.post(name: .manageSignInForgotServerSideID, object: nil)
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
                        NotificationCenter.default.post(name: .manageSignInForgotServerSideID, object: nil)
                    } else {
                        NotificationCenter.default.post(name: .manageSignInForgotServerSideID, object: nil)
                    }
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    NotificationCenter.default.post(name: .manageSignInForgotServerSideID, object: nil)
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                NotificationCenter.default.post(name: .manageSignInForgotServerSideID, object: nil)
            }
        }
        
    }
    
    func resetPassword(_ password: String) {
        
        var email = UserManager.sharedInstance.userEmail
        if email == "" {
            email = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.UserMail") ?? "WHAAAAAAAAAT"
        }
        print(email)
        print(password)
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let hashedPswd = MD5(string: password)
        let params : Parameters = ["email":email,"psw":hashedPswd]
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/ResetPassword.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
            guard response.value != nil else {
                self.callResult = "database error"
                NotificationCenter.default.post(name: .manageResetPasswordServerSideID, object: nil)
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    self.callResult = jsonArray["status"] as! String
                    NotificationCenter.default.post(name: .manageResetPasswordServerSideID, object: nil)
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    NotificationCenter.default.post(name: .manageResetPasswordServerSideID, object: nil)
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                NotificationCenter.default.post(name: .manageResetPasswordServerSideID, object: nil)
            }
        }
    }
    
}
