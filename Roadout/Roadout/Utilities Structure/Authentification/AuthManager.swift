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
    
    var userID: String!
    
    var token = 0
    var dateToken = Date.yesterday
    
    static let sharedInstance = AuthManager()
    
    private init() {}
    
    enum AuthErrors: Error {
        case databaseFailure
        case userExistsFailure
        case errorWithJson
        case networkError
        case unknownError
        case userDoesNotExist
    }
    
    //MARK: - Sign Up Functions -
    
    func sendRegisterDataAsync(_ email: String) async throws {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let timezone = TimeZone.current.secondsFromGMT()/3600
        let params : Parameters = ["email":email, "timezone":timezone, "lang": "en".localized()]
        
        let sendRequest = AF.request("https://\(roadoutServerURL)/Authentification/VerifyEmail.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await sendRequest.serializingString().value
        } catch {
            throw AuthErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String: Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw AuthErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String == "Success" {
            let code = jsonArray["accessCode"] as! String
            let token = jsonArray["token"] as! String
            let formatter = DateFormatter()
            let dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.dateFormat = dateFormat
            self.token = Int(code)!
            self.dateToken = formatter.date(from: token) ?? Date.yesterday
        } else if jsonArray["status"] as! String == "User already exists" {
           throw AuthErrors.userExistsFailure
        } else {
            throw AuthErrors.unknownError
        }
    }
    
    func deleteBadDataAsync(_ email: String) async {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["email":email]
        
        let deleteRequest = AF.request("https://\(roadoutServerURL)/Authentification/DeleteDataVerifyEmail.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        do {
            _ = try await deleteRequest.serializingString().value
        } catch let err {
            print(err)
        }
    }
    
    func sendSignUpDataAsync(_ name: String, _ email: String, _ password: String) async throws {
        let hashedPswd = MD5(string: password)
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["name":name,"email":email,"password":hashedPswd]
        
        let sendRequest = AF.request("https://\(roadoutServerURL)/Authentification/userRegister.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await sendRequest.serializingString().value
        } catch {
            throw AuthErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw AuthErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String == "Success" {
            self.userID = String(jsonArray["id"] as! Int)
        } else {
            throw AuthErrors.userExistsFailure
        }
    }
    
    //MARK: - Sign In Functions -
    
    func sendSignInDataAsync(_ email: String, _ password: String) async throws {
        let hashedPswd = MD5(string: password)
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["email":email,"password":hashedPswd]
        
        let sendRequest = AF.request("https://\(roadoutServerURL)/Authentification/userLogin.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await sendRequest.serializingString().value
        } catch {
            throw AuthErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw AuthErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String == "Success" {
            self.userID = jsonArray["id"] as? String
        } else {
            throw AuthErrors.userDoesNotExist
        }
    }
    
    func checkIfUserExistsAsync(with id: String) async throws {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":id]
        
        let checkRequest = AF.request("https://\(roadoutServerURL)/Authentification/IdExists.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers)
        
        var responseJson: String!
        do {
            responseJson = try await checkRequest.serializingString().value
        } catch {
            throw AuthErrors.databaseFailure
        }
        
        let data = responseJson.data(using: .utf8)!
        var jsonArray: [String:Any]!
        do {
            jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
        } catch {
            throw AuthErrors.errorWithJson
        }
        
        if jsonArray["status"] as! String == "Success" && jsonArray["message"] as! String == "False" {
            throw AuthErrors.userDoesNotExist
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
