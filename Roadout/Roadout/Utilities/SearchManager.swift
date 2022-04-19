//
//  SearchManager.swift
//  Roadout
//
//  Created by David Retegan on 18.02.2022.
//

import Foundation
import GooglePlaces

class SearchManager {
    
    static let sharedInstance = SearchManager()
    
    let client = GMSPlacesClient.shared()
 
    enum PlacesErrors: Error {
        case failedToFind
        case errorLookingUp
        case noDetails
    }
    
    func startSearching(query: String, completion: @escaping(Result<CLLocationCoordinate2D, Error>) -> Void) {
        let filter = GMSAutocompleteFilter()
        filter.country = "ro"
        filter.type = .geocode
        
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { results, err in
            guard let results = results, err == nil else {
                print(String(describing: err?.localizedDescription))
                completion(.failure(PlacesErrors.failedToFind))
                return
            }
            for result in results {
                print(result.attributedFullText)
            }
            guard let firstResult = results.first else {
                completion(.failure(PlacesErrors.failedToFind))
                return
            }
            self.client.lookUpPlaceID(firstResult.placeID) { place, errr in
                if let errr = errr {
                    print("lookup place id query error: \(errr.localizedDescription)")
                    completion(.failure(PlacesErrors.errorLookingUp))
                    return
                }

                guard let place = place else {
                    print("No place details for \(results.first!.placeID)")
                    completion(.failure(PlacesErrors.noDetails))
                    return
                }
                completion(.success(place.coordinate))
            }
        }
    }
    
}
