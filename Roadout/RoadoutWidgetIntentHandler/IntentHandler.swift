//
//  IntentHandler.swift
//  RoadoutWidgetIntentHandler
//
//  Created by David Retegan on 18.04.2022.
//

import Intents

class IntentHandler: INExtension, ConfigurationIntentHandling {
    
    func provideLocation1OptionsCollection(for intent: ConfigurationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<WidgetParkLocation>?, Error?) -> Void) {
        
        EntityManager.sharedInstance.getParkLocations("Cluj") { result in
            switch result {
                case .success():
                    let widgetParkLocations = dbParkLocations.map { (parkLocation) -> WidgetParkLocation in
                        let widgetParkLocation = WidgetParkLocation(identifier: parkLocation.rID, display: parkLocation.name)
                        widgetParkLocation.freeSpots = parkLocation.freeSpots as NSNumber
                        widgetParkLocation.rID = parkLocation.rID
                        widgetParkLocation.locationName = parkLocation.name
                        widgetParkLocation.totalSpots = parkLocation.totalSpots as NSNumber
                        widgetParkLocation.coords = "\(Double(round(1000 * parkLocation.latitude) / 1000)), \(Double(round(1000 * parkLocation.longitude) / 1000))"
                        return widgetParkLocation
                    }
                    let collection = INObjectCollection(items: widgetParkLocations)
                    completion(collection, nil)
                case .failure(let err):
                    completion(nil, err)
            }
        }
        
    }
    
    func provideLocation2OptionsCollection(for intent: ConfigurationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<WidgetParkLocation>?, Error?) -> Void) {
        
        EntityManager.sharedInstance.getParkLocations("Cluj") { result in
            switch result {
                case .success():
                    let widgetParkLocations = dbParkLocations.map { (parkLocation) -> WidgetParkLocation in
                        let widgetParkLocation = WidgetParkLocation(identifier: parkLocation.rID, display: parkLocation.name)
                        widgetParkLocation.freeSpots = parkLocation.freeSpots as NSNumber
                        widgetParkLocation.rID = parkLocation.rID
                        widgetParkLocation.locationName = parkLocation.name
                        widgetParkLocation.totalSpots = parkLocation.totalSpots as NSNumber
                        widgetParkLocation.coords = "\(Double(round(1000 * parkLocation.latitude) / 1000)), \(Double(round(1000 * parkLocation.longitude) / 1000))"
                        return widgetParkLocation
                    }
                    let collection = INObjectCollection(items: widgetParkLocations)
                    completion(collection, nil)
                case .failure(let err):
                    completion(nil, err)
            }
        }
        
    }
    
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
