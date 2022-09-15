//
//  UserManager.swift
//  RWUI WatchKit Extension
//
//  Created by David Retegan on 23.05.2022.
//

import Foundation
import Alamofire

class UserManager {
    
    static let sharedInstance = UserManager()
    
    var callResult = "network error"
    
    var userName: String!
        
    enum UserDBErrors: Error {
        case databaseFailure
        case userExistsFailure
        case errorWithJson
        case networkError
        case unknownError
        case userDoesNotExist
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
                        self.userName = jsonArray["name"] as? String
                        UserDefaults.roadout!.set(self.userName, forKey: "ro.roadout.RoadoutWatch.UserName")
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
    
}
