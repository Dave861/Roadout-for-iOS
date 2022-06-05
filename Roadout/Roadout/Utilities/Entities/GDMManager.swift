//
//  GDMManager.swift
//  Roadout
//
//  Created by David Retegan on 22.04.2022.
//

import Foundation
import Alamofire
import CoreLocation

class DistanceManager {
    
    static let sharedInstance = DistanceManager()
    
    enum DistanceErrors: Error {
        case networkError
        case jsonError
        case unknownError
    }
    
    let language = "en".localized()
    
    func getTimeAndDistanceBetween(_ ogCoords: CLLocationCoordinate2D, _ destCoords: CLLocationCoordinate2D, completion: @escaping(Result<String, Error>) -> Void) {
        Alamofire.Session.default.request("https://maps.googleapis.com/maps/api/distancematrix/json?destinations=\(destCoords.latitude),\(destCoords.longitude)&origins=\(ogCoords.latitude),\(ogCoords.longitude)&units=metric&departure_time=now&traffic_model=best_guess&language=\(language)&key=AIzaSyBCwiN3sMkKBigQhrsFfmAENeGEyJjbgcI", method: .get).responseString { response in
            
            guard response.value != nil else {
                completion(.failure(DistanceErrors.networkError))
                return
            }
            
            let data = response.value!.data(using: .utf8)!
            do {
                let resp = try JSONDecoder().decode(GDMResponse.self, from: data)
                print(resp)
                if (resp.status == "OK") {
                    completion(.success(resp.rows[0].elements[0].duration_in_traffic.text))
                } else {
                    completion(.failure(DistanceErrors.unknownError))
                }
            } catch let err {
                print(err)
                completion(.failure(DistanceErrors.jsonError))
            }
            
        }
    }
    
}
