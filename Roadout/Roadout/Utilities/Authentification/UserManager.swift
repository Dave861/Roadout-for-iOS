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
    
    
}
