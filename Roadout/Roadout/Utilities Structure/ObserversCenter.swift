//
//  ObserversCenter.swift
//  Roadout
//
//  Created by David Retegan on 01.01.2022.
//

import Foundation

extension Notification.Name {
    
    //HOME VIEWS
    static let addToolsCardID = Notification.Name("eu.roadout.Roadout.addToolsCardID")
    static let removeToolsCardID = Notification.Name("eu.roadout.Roadout.removeToolsCardID")
    static let addResultCardID = Notification.Name("eu.roadout.Roadout.addResultCardID")
    static let removeResultCardID = Notification.Name("eu.roadout.Roadout.removeResultCardID")
    static let addSectionCardID = Notification.Name("eu.roadout.Roadout.addSectionCardID")
    static let removeSectionCardID = Notification.Name("eu.roadout.Roadout.removeSectionCardID")
    static let addSpotCardID = Notification.Name("eu.roadout.Roadout.addSpotCardID")
    static let removeSpotCardID = Notification.Name("eu.roadout.Roadout.removeSpotCardID")
    static let addTimeCardID = Notification.Name("eu.roadout.Roadout.addTimeCardID")
    static let removeTimeCardID = Notification.Name("eu.roadout.Roadout.removeTimeCardID")
    static let addPayCardID = Notification.Name("eu.roadout.Roadout.addPayCardID")
    static let removePayCardID = Notification.Name("eu.roadout.Roadout.removePayCardID")
    static let addReservationCardID = Notification.Name("eu.roadout.Roadout.addReservationCardID")
    static let removeReservationCardID = Notification.Name("eu.roadout.Roadout.removeReservationCardID")
    static let addDelayCardID = Notification.Name("eu.roadout.Roadout.addDelayCardID")
    static let removeDelayCardID = Notification.Name("eu.roadout.Roadout.removeDelayCardID")
    static let addPayDelayCardID = Notification.Name("eu.roadout.Roadout.addPayDelayCardID")
    static let removePayDelayCardID = Notification.Name("eu.roadout.Roadout.removePayDelayCardID")
    static let addUnlockCardID = Notification.Name("eu.roadout.Roadout.addUnlockCardID")
    static let removeUnlockCardID = Notification.Name("eu.roadout.Roadout.removeUnlockCardID")
    static let showActiveBarID = Notification.Name("eu.roadout.Roadout.showActiveBarID")
    static let showUnlockedViewID = Notification.Name("eu.roadout.Roadout.showUnlockedViewID")
    static let showCancelledBarID = Notification.Name("eu.roadout.Roadout.showCancelledBarID")
    static let showNoWifiBarID = Notification.Name("eu.roadout.Roadout.showNoWifiBarID")
    static let removeNoWifiBarID = Notification.Name("eu.roadout.Roadout.removeNoWifiBarID")
    static let returnToSearchBarID = Notification.Name("eu.roadout.Roadout.returnToSearchBarID")
    static let returnFromReservationID = Notification.Name("eu.roadout.Roadout.returnFromReservationID")
    static let returnToSearchBarWithErrorID = Notification.Name("eu.roadout.Roadout.returnToSearchBarWithErrorID")
    static let showFindCardID = Notification.Name("eu.roadout.Roadout.showFindCardID")
    
    //SETTINGS
    static let refreshCardsID = Notification.Name("eu.roadout.Roadout.refreshCards")
    static let refreshCardsMenuID = Notification.Name("eu.roadout.Roadout.refreshCardsMenu")
    
    //OTHERS
    static let reloadUserNameID = Notification.Name("eu.roadout.Roadout.reloadUserNameID")
    static let reloadLicensePlateID = Notification.Name("eu.roadout.Roadout.reloadLicensePlateID")
    static let updateLocationID = Notification.Name("eu.roadout.Roadout.updateLocationID")
    static let addMarkersID = Notification.Name("eu.roadout.Roadout.addMarkersID")
    static let updateReservationTimeLabelID = Notification.Name("eu.roadout.Roadout.updateReservationTimeLabelID")
    static let showRateReservationID = Notification.Name("eu.roadout.Roadout.showRateReservationAlertID")
    static let showExpressLaneFreeSpotID = Notification.Name("eu.roadout.Roadout.showExpressLaneFreeSpotID")
    static let reloadExpressLocationsID = Notification.Name("eu.roadout.Roadout.reloadExpressLocationsID")
    static let reloadFutureReservationsID = Notification.Name("eu.roadout.Roadout.reloadFutureReservationsID")
    static let addSpotMarkerID = Notification.Name("eu.roadout.Roadout.addSpotMarkerID")
    static let removeSpotMarkerID = Notification.Name("eu.roadout.Roadout.removeSpotMarkerID")
    
    //BLUETOOTH
    static let btBarrierUp = Notification.Name("eu.roadout.Roadout.btBarrierUp")
    static let btBarrierDown = Notification.Name("eu.roadout.Roadout.btBarrierDown")
}
