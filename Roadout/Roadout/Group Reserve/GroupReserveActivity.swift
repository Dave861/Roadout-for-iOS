//
//  GroupReserveActivity.swift
//  Roadout
//
//  Created by David Retegan on 19.12.2021.
//

import Foundation
import GroupActivities

@available(iOS 15, *)
struct GroupReserveActivity: GroupActivity {
    
    static let activityIdentifier = "ro.roadout.Roadout.GroupReserve"
    
    let parkingLocation: ParkLocation
    
    var metadata: GroupActivityMetadata {
        get {
            var metadata = GroupActivityMetadata()
            metadata.title = "Group Reserve"
            metadata.type = .generic
            
            return metadata
        }
    }
    
}

@available(iOS 15, *)
struct SharePlayMessage: Hashable, Codable {
    let location: ParkLocation
    let people: Int
}
