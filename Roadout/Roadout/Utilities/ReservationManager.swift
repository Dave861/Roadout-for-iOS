//
//  ReservationManager.swift
//  Roadout
//
//  Created by David Retegan on 25.12.2021.
//

import Foundation

class ReservationManager {
    
    static let sharedInstance = ReservationManager()
    
    let showUnlockedBarID = "ro.roadout.Roadout.showUnlockedBarID"
    
    let UserDefaultsSuite = UserDefaults.init(suiteName: "group.ro.roadout.Roadout")!
    
    var reservationDate: Date!
    
    func getReservationDate() -> Date {
        reservationDate = UserDefaultsSuite.object(forKey: "ro.roadout.Roadout.reservationDate") as? Date ?? Date()
        
        if reservationDate < Date() {
            saveActiveReservation(false)
        }
        
        return reservationDate
    }
    
    func saveReservationDate(_ date: Date) {
        UserDefaultsSuite.set(date, forKey: "ro.roadout.Roadout.reservationDate")
    }
    
    func checkActiveReservation() -> Bool {
        return UserDefaultsSuite.bool(forKey: "ro.roadout.Roadout.reservationExists")
    }
    
    func saveActiveReservation(_ value: Bool) {
        UserDefaultsSuite.set(value, forKey: "ro.roadout.Roadout.reservationExists")
        if value == true {
            let timer = Timer(fireAt: getReservationDate(), interval: 0, target: self, selector: #selector(finishReservation), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    @objc func finishReservation() {
        if UserDefaultsSuite.bool(forKey: "ro.roadout.Roadout.reservationDelayed") == false {
            if checkActiveReservation() {
                saveActiveReservation(false)
                saveReservationDate(Date())
                NotificationCenter.default.post(name: Notification.Name(showUnlockedBarID), object: nil)
            }
        } else {
            UserDefaultsSuite.set(false, forKey: "ro.roadout.Roadout.reservationDelayed")
        }
    }
    
    func manageDelay() {
        UserDefaultsSuite.set(true, forKey: "ro.roadout.Roadout.reservationDelayed")
    }
    
}
