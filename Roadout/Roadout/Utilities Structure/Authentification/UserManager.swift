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
        
    var token = 0
    var dateToken = Date.yesterday
    
    //User Data
    var userEmail: String!
    var userName = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.UserName") ?? "Roadout_User_Name"
    
    enum UserDBErrors: Error {
        case databaseFailure
        case userExistsFailure
        case errorWithJson
        case networkError
        case unknownError
        case userDoesNotExist
        case wrongPassword
    }
    
    //MARK: - CRUD Functions -
    
    func updateNameAsync(_ id: String, _ name: String) async throws {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":id,"name":name]
        
        let updateRequest = AF.request("https://\(roadoutServerURL)/Authentification/UpdateName.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await updateRequest.serializingString().value
        } catch {
            throw UserDBErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw UserDBErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String != "Success" {
            throw UserDBErrors.userDoesNotExist
        }
    }
    
    func updatePasswordAsync( _ id: String, _ oldPsw: String, _ newPsw: String) async throws {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let hashedOldPswd = MD5(string: oldPsw)
        let hashedNewPswd = MD5(string: newPsw)
        let params : Parameters = ["id":id,"oldPsw":hashedOldPswd,"newPsw":hashedNewPswd]
        
        let updateRequest = AF.request("https://\(roadoutServerURL)/Authentification/UpdatePassword.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await updateRequest.serializingString().value
        } catch {
            throw UserDBErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw UserDBErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String != "Success" {
            throw UserDBErrors.wrongPassword
        }
    }
    
    func deleteAccountAsync(_ email: String, _ password: String) async throws {
        let hashedPswd = MD5(string: password)
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["email":email,"password":hashedPswd]
        
        let deleteRequest = AF.request("https://\(roadoutServerURL)/Authentification/DeleteAccount.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await deleteRequest.serializingString().value
        } catch {
            throw UserDBErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw UserDBErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String != "Success" {
            throw UserDBErrors.wrongPassword
        }
    }
    
    func getUserNameAsync(_ id: String) async throws {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":id]
        
        let getRequest = AF.request("https://\(roadoutServerURL)/Authentification/GetUserData.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await getRequest.serializingString().value
        } catch {
            throw UserDBErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw UserDBErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String == "Success" {
            self.userName = jsonArray["name"] as! String
            self.userEmail = jsonArray["email"] as! String
            UserDefaults.roadout!.set(self.userEmail, forKey: "ro.roadout.Roadout.UserMail")
            UserDefaults.roadout!.set(self.userName, forKey: "ro.roadout.Roadout.UserName")
        } else {
            throw UserDBErrors.userDoesNotExist
        }
    }
    
    //MARK: - Recovery Functions -
    
    func sendForgotDataAsync(_ email: String) async throws {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let timezone = TimeZone.current.secondsFromGMT()/3600
        let params : Parameters = ["email":email, "timezone":timezone, "lang": "en".localized()]
        
        let sendRequest = AF.request("https://\(roadoutServerURL)/Authentification/ForgotPassword.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await sendRequest.serializingString().value
        } catch {
            throw UserDBErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw UserDBErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String == "Success" {
            let code = jsonArray["accessCode"] as! String
            let token = jsonArray["token"] as! String
            let formatter = DateFormatter()
            let dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.dateFormat = dateFormat
            self.token = Int(code)!
            self.dateToken = formatter.date(from: token) ?? Date.yesterday
        } else {
            throw UserDBErrors.unknownError
        }
    }
    
    func resetPasswordAsync(_ password: String) async throws {
        if userEmail == nil {
            userEmail = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.UserMail") ?? "Roadout_Impossible."
        }
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let hashedPswd = MD5(string: password)
        let params : Parameters = ["email":userEmail,"psw":hashedPswd]
        
        let resetRequest = AF.request("https://\(roadoutServerURL)/Authentification/ResetPassword.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await resetRequest.serializingString().value
        } catch {
            throw UserDBErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw UserDBErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String != "Success" {
            throw UserDBErrors.unknownError
        }
    }
    
    //MARK: - Utility -
    
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
