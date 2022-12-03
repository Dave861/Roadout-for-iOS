//
//  UserManager.swift
//  Roadout for Watch Watch App
//
//  Created by David Retegan on 23.10.2022.
//

import Foundation
import Alamofire

class UserManager: ObservableObject {
    
    @Published var userName: String = UserDefaults.roadout.string(forKey: "ro.roadout.Roadout.UserName") ?? "User Name"
        
    enum UserDBErrors: Error {
        case databaseFailure
        case userExistsFailure
        case errorWithJson
        case networkError
        case unknownError
        case userDoesNotExist
    }
    
    init() {
        if UserDefaults.roadout.string(forKey: "ro.roadout.Roadout.userID") != nil {
            let id = UserDefaults.roadout.string(forKey: "ro.roadout.Roadout.userID")!
            Task {
                do {
                    try await getUserNameAsync(id)
                } catch let err {
                    print(err)
                }
            }
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
            UserDefaults.roadout.set(self.userName, forKey: "ro.roadout.Roadout.UserName")
        } else {
            UserDefaults.roadout.removeObject(forKey: "ro.roadout.Roadout.UserName")
            throw UserDBErrors.userDoesNotExist
        }
    }
}

