//
//  RoadoutWidgets.swift
//  Roadout
//
//  Created by David Retegan on 22.10.2022.
//

import Foundation
import SwiftUI

@main
struct RoadoutWidgets: WidgetBundle {
    
    var body: some Widget {
        returnWidgets()
    }
   
    func returnWidgets() -> some Widget {
        if #available(iOS 16.0, *) {
            return WidgetBundleBuilder.buildBlock(RoadoutLockWidget(), RoadoutWidget())
        } else {
            return RoadoutWidget()
        }
    }
}
