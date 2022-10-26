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
    
    var callResult = "network error"
    
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
            getUserName(UserDefaults.roadout.string(forKey: "ro.roadout.Roadout.userID")!) { result in
                switch result {
                case .success():
                    print("User Name retrieved succesfully")
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    func getUserName(_ id: String, completion: @escaping(Result<Void, Error>) -> Void) {
        
        let _headers : HTTPHeaders = ["Content-Type":"application/json"]
        let params : Parameters = ["id":id]
        
        Alamofire.Session.default.request("https://\(roadoutServerURL)/Authentification/GetUserData.php", method: .post, parameters: params, encoding: JSONEncoding.default, headers: _headers).responseString { response in
            guard response.value != nil else {
                self.callResult = "database error"
                completion(.failure(UserDBErrors.databaseFailure))
                return
            }
            let data = response.value!.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                    self.callResult = jsonArray["status"] as! String
                    if self.callResult == "Success" {
                        self.userName = jsonArray["name"] as! String
                        UserDefaults.roadout.set(self.userName, forKey: "ro.roadout.Roadout.UserName")
                        completion(.success(()))
                    } else {
                        UserDefaults.roadout.removeObject(forKey: "ro.roadout.Roadout.UserName")
                        completion(.failure(UserDBErrors.userDoesNotExist))
                    }
                } else {
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

