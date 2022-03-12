//
//  EntityManager.swift
//  Roadout
//
//  Created by David Retegan on 17.02.2022.
//

import Foundation


class EntityManager {
    
    static let sharedInstance = EntityManager()
    
    func getParkLocations(completion: @escaping(Result<Void, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(()))
        }
    }
    
    func getSections(in: ParkLocation) {
        
    }
    
    func getSpotsInLocation(in: ParkLocation) {
        
    }
    
    func getSpots(in: ParkSection) {
        
    }
    
}
