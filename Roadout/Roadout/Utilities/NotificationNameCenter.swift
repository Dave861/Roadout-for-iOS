//
//  NotificationNameCenter.swift
//  Roadout
//
//  Created by David Retegan on 01.01.2022.
//

import Foundation

extension Notification.Name {
    
    //HOME VIEWS
    static let addResultCardID = Notification.Name("ro.roadout.Roadout.addResultCardID")
    static let removeResultCardID = Notification.Name("ro.roadout.Roadout.removeResultCardID")
    static let addSectionCardID = Notification.Name("ro.roadout.Roadout.addSectionCardID")
    static let removeSectionCardID = Notification.Name("ro.roadout.Roadout.removeSectionCardID")
    static let addSpotCardID = Notification.Name("ro.roadout.Roadout.addSpotCardID")
    static let removeSpotCardID = Notification.Name("ro.roadout.Roadout.removeSpotCardID")
    static let addReserveCardID = Notification.Name("ro.roadout.Roadout.addReserveCardID")
    static let removeReserveCardID = Notification.Name("ro.roadout.Roadout.removeReserveCardID")
    static let addPayCardID = Notification.Name("ro.roadout.Roadout.addPayCardID")
    static let removePayCardID = Notification.Name("ro.roadout.Roadout.removePayCardID")
    static let addReservationCardID = Notification.Name("ro.roadout.Roadout.addReservationCardID")
    static let removeReservationCardID = Notification.Name("ro.roadout.Roadout.removeReservationCardID")
    static let addDelayCardID = Notification.Name("ro.roadout.Roadout.addDelayCardID")
    static let removeDelayCardID = Notification.Name("ro.roadout.Roadout.removeDelayCardID")
    static let addPayDelayCardID = Notification.Name("ro.roadout.Roadout.addPayDelayCardID")
    static let removePayDelayCardID = Notification.Name("ro.roadout.Roadout.removePayDelayCardID")
    static let showPaidBarID = Notification.Name("ro.roadout.Roadout.showPaidBarID")
    static let showActiveBarID = Notification.Name("ro.roadout.Roadout.showActiveBarID")
    static let showUnlockedBarID = Notification.Name("ro.roadout.Roadout.showUnlockedBarID")
    static let showCancelledBarID = Notification.Name("ro.roadout.Roadout.showCancelledBarID")
    static let showNoWifiBarID = Notification.Name("ro.roadout.Roadout.showNoWifiBarID")
    static let removeNoWifiBarID = Notification.Name("ro.roadout.Roadout.removeNoWifiBarID")
    static let returnToSearchBarID = Notification.Name("ro.roadout.Roadout.returnToSearchBarID")
    static let addExpressViewID = Notification.Name("ro.roadout.Roadout.addExpressViewID")
    static let addExpressPickViewID = Notification.Name("ro.roadout.Roadout.removeExpressViewID")
    static let showFindCardID = Notification.Name("ro.roadout.Roadout.showFindCardID")
    static let animateCameraToFoundID = Notification.Name("ro.roadout.Roadout.animateCameraToFoundID")
    
    //SHAREPLAY
    static let groupMessageReceivedID = Notification.Name("ro.roadout.Roadout.groupMessageReceivedID")
    static let groupSessionStartedID = Notification.Name("ro.roadout.Roadout.groupSessionStarted")
    
    //REMINDERS & CARDS
    static let refreshReminderID = Notification.Name("ro.roadout.Roadout.refreshReminder")
    static let refreshCardsID = Notification.Name("ro.roadout.Roadout.refreshCards")
    
    //OTHERS
    static let reloadUserNameID = Notification.Name("ro.roadout.Roadout.reloadUserNameID")
    static let updateLocationID = Notification.Name("ro.roadout.Roadout.updateLocationID")
}
