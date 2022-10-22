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
    
    enum AuthErrors: Error {
        case databaseFailure
        case userExistsFailure
        case errorWithJson
        case networkError
        case unknownError
        case userDoesNotExist
    }
    
    func sendRegisterData(_ email: String, completion: @escaping(Result<Void, Error>) -> Void) {
        
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["email":email]
        
        Alamofire.Session.default.request("https://\(roadoutServerURL)/Authentification/VerifyEmail.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                self.callResult = "database error"
                completion(.failure(AuthErrors.databaseFailure))
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
                        completion(.success(()))
                    } else {
                        if jsonArray["message"] as! String == "User already exists" {
                            self.callResult = "user exists"
                        }
                        completion(.failure(AuthErrors.userExistsFailure))
                    }
                } else {
                    self.callResult = "unknown error"
                    completion(.failure(AuthErrors.unknownError))
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                completion(.failure(AuthErrors.errorWithJson))
            }
        }
                
    }
    
    func deleteBadData(_ email: String) {
        
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["email":email]
        
        Alamofire.Session.default.request("https://\(roadoutServerURL)/Authentification/DeleteDataVerifyEmail.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            print(response.value ?? "NO RESPONSE - ABORT MISSION SOLDIER")
        }
    }
    
    func sendSignUpData(_ name: String, _ email: String, _ password: String, completion: @escaping(Result<Void, Error>) -> Void) {
        
        let hashedPswd = MD5(string: password)
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["name":name,"email":email,"password":hashedPswd]
        
        Alamofire.Session.default.request("https://\(roadoutServerURL)/Authentification/userRegister.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                self.callResult = "database error"
                completion(.failure(AuthErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    self.userID = String(jsonArray["id"] as! Int)
                    self.callResult = jsonArray["status"] as! String
                    if self.callResult == "Success" {
                        completion(.success(()))
                    } else {
                        completion(.failure(AuthErrors.userExistsFailure))
                    }
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    completion(.failure(AuthErrors.unknownError))
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                completion(.failure(AuthErrors.errorWithJson))
            }
        }
    }
    
    func sendSignInData(_ email: String, _ password: String, completion: @escaping(Result<Void, Error>) -> Void) {
        
        let hashedPswd = MD5(string: password)
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["email":email,"password":hashedPswd]
        
        Alamofire.Session.default.request("https://\(roadoutServerURL)/Authentification/userLogin.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                self.callResult = "database error"
                completion(.failure(AuthErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    self.userID = jsonArray["id"] as? String
                    self.callResult = jsonArray["status"] as! String
                    if self.callResult == "Success" {
                        completion(.success(()))
                    } else {
                        completion(.failure(AuthErrors.userDoesNotExist))
                    }
                } else {
                    print("unknown error")
                    self.callResult = "unknown error"
                    completion(.failure(AuthErrors.unknownError))
                }
            } catch let error as NSError {
                print(error)
                self.callResult = "error with json"
                completion(.failure(AuthErrors.errorWithJson))
            }
        }
    }
    
    func checkIfUserExists(with id: String, completion: @escaping(Result<Void, Error>) -> Void) {
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":id]
        
        Alamofire.Session.default.request("https://\(roadoutServerURL)/Authentification/IdExists.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                completion(.failure(AuthErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    print(jsonArray["status"]!)
                    print(jsonArray["message"]!)
                    if jsonArray["status"] as! String == "Success" && jsonArray["message"] as! String == "False" {
                        completion(.failure(AuthErrors.userDoesNotExist))
                    } else if jsonArray["message"] as! String == "True" {
                        completion(.success(()))
                    }
                } else {
                    completion(.failure(AuthErrors.unknownError))
                }
            } catch let error as NSError {
                print(error.debugDescription)
                completion(.failure(AuthErrors.errorWithJson))
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
