//
//  IntentHandler.swift
//  RoadoutWidgetIntentHandler
//
//  Created by David Retegan on 18.04.2022.
//

import Intents

class IntentHandler: INExtension, ConfigurationIntentHandling {
    
    func provideLocation1OptionsCollection(for intent: ConfigurationIntent, searchTerm: String?) async throws -> INObjectCollection<WidgetParkLocation> {
        do {
            try await EntityManager.sharedInstance.saveParkLocationsAsync("Cluj")
            let widgetParkLocations = dbParkLocations.map { (parkLocation) -> WidgetParkLocation in
                let widgetParkLocation = WidgetParkLocation(identifier: parkLocation.rID, display: parkLocation.name)
                widgetParkLocation.freeSpots = parkLocation.freeSpots as NSNumber
                widgetParkLocation.rID = parkLocation.rID
                widgetParkLocation.locationName = parkLocation.name
                widgetParkLocation.totalSpots = parkLocation.totalSpots as NSNumber
                widgetParkLocation.occupancyColor = self.makeAccentColor(parkLocation: parkLocation)
                return widgetParkLocation
            }
            let collection = INObjectCollection(items: widgetParkLocations)
            return collection
        } catch let err {
            throw err
        }
    }
    
    func provideLocation2OptionsCollection(for intent: ConfigurationIntent, searchTerm: String?) async throws -> INObjectCollection<WidgetParkLocation> {
        do {
            try await EntityManager.sharedInstance.saveParkLocationsAsync("Cluj")
            let widgetParkLocations = dbParkLocations.map { (parkLocation) -> WidgetParkLocation in
                let widgetParkLocation = WidgetParkLocation(identifier: parkLocation.rID, display: parkLocation.name)
                widgetParkLocation.freeSpots = parkLocation.freeSpots as NSNumber
                widgetParkLocation.rID = parkLocation.rID
                widgetParkLocation.locationName = parkLocation.name
                widgetParkLocation.totalSpots = parkLocation.totalSpots as NSNumber
                widgetParkLocation.occupancyColor = self.makeAccentColor(parkLocation: parkLocation)
                return widgetParkLocation
            }
            let collection = INObjectCollection(items: widgetParkLocations)
            return collection
        } catch let err {
            throw err
        }
    }
    
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    func makeAccentColor(parkLocation: ParkLocation) -> String {
        let percentage = 100-(Double(parkLocation.freeSpots)/Double(parkLocation.totalSpots))*100
        if percentage >= 90 {
            return "Kinda Red"
        } else if percentage >= 80 {
            return "Dark Orange"
        } else if percentage >= 60 {
            return "Second Orange"
        } else if percentage >= 50 {
            return "Icons"
        } else {
            return "Main Yellow"
        }
    }
    
}
