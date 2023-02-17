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
    
    func getTimeAndDistanceBetween(_ ogCoords: CLLocationCoordinate2D, _ destCoords: CLLocationCoordinate2D) async throws -> String {
        let getRequest = AF.request("https://maps.googleapis.com/maps/api/distancematrix/json?destinations=\(destCoords.latitude),\(destCoords.longitude)&origins=\(ogCoords.latitude),\(ogCoords.longitude)&units=metric&departure_time=now&traffic_model=best_guess&language=\(language)&key=\(webAPIKey)", method: .get)
        
        var responseJson: String
        do {
            try await responseJson = getRequest.serializingString().value
            print(responseJson)
        } catch {
            throw DistanceErrors.networkError
        }
        
        let data = responseJson.data(using: .utf8)!
        var resp: GDMResponse!
        do {
            resp = try JSONDecoder().decode(GDMResponse.self, from: data)
        } catch {
            throw DistanceErrors.jsonError
        }
        
        if (resp.status == "OK") {
            return resp.rows[0].elements[0].duration_in_traffic.text
        } else {
            throw DistanceErrors.unknownError
        }
    }
    
}
