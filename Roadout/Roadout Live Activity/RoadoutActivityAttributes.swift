//
//  RoadoutActivityAttributes.swift
//  Roadout
//
//  Created by David Retegan on 31.12.2022.
//

import Foundation
import ActivityKit

struct RoadoutReservationAttributes: ActivityAttributes {
    
    public typealias RoadoutReservationStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var endTime: ClosedRange<Date>
    }
    
    var parkSpotID: String
}
