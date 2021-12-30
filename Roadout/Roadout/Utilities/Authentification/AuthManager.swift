//
//  AuthManager.swift
//  Roadout
//
//  Created by David Retegan on 28.12.2021.
//

import Foundation
import Network
import Alamofire

class AuthManager {
    
    var callResult = "network error"
    let manageServerSideSignUpID = "ro.roadout.Roadout.manageServerSideSignUpID"
    let manageServerSideSignInID = "ro.roadout.Roadout.manageServerSideSignInID"
    
    static let sharedInstance = AuthManager()
    
    func sendSignUpData(_ name: String, _ email: String, _ password: String) {
        
        let params = "name=\(name)&email=\(email)&password=\(password)"
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/userRegister.php?\(params)", method: .get, encoding: JSONEncoding.default).responseString { response in
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
            guard response.value != nil else {
                self.callResult = "database error"
                NotificationCenter.default.post(name: Notification.Name(self.manageServerSideSignUpID), object: nil)
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    self.callResult = jsonArray["status"] as! String
                    NotificationCenter.default.post(name: Notification.Name(self.manageServerSideSignUpID), object: nil)
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    NotificationCenter.default.post(name: Notification.Name(self.manageServerSideSignUpID), object: nil)
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                NotificationCenter.default.post(name: Notification.Name(self.manageServerSideSignUpID), object: nil)
            }
        }
    }
    
    func sendSignInData(_ email: String, _ password: String) {
        
        let params = "email=\(email)&password=\(password)"
        
        Alamofire.Session.default.request("https://www.roadout.ro/Authentification/userLogin.php?\(params)", method: .get, encoding: JSONEncoding.default).responseString { response in
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
            guard response.value != nil else {
                self.callResult = "database error"
                NotificationCenter.default.post(name: Notification.Name(self.manageServerSideSignInID), object: nil)
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    self.callResult = jsonArray["status"] as! String
                    NotificationCenter.default.post(name: Notification.Name(self.manageServerSideSignInID), object: nil)
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    NotificationCenter.default.post(name: Notification.Name(self.manageServerSideSignInID), object: nil)
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                NotificationCenter.default.post(name: Notification.Name(self.manageServerSideSignInID), object: nil)
            }
        }
        
    }
    
}
