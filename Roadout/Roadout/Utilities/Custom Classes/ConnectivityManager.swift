//
//  ConnectivityManager.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import Foundation

class ConnectionManager {
    
static let sharedInstance = ConnectionManager()
private var reachability : Reachability!

func observeReachability(){
    self.reachability = try! Reachability()
    NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
    do {
        try self.reachability.startNotifier()
    }
    catch(let error) {
        print("Error occured while starting reachability notifications : \(error.localizedDescription)")
    }
}

@objc func reachabilityChanged(note: Notification) {
    let reachability = note.object as! Reachability
    switch reachability.connection {
    case .cellular:
        print("Network available via Cellular Data.")
        NotificationCenter.default.post(name: .removeNoWifiBarID, object: nil)
        break
    case .wifi:
        print("Network available via WiFi.")
        NotificationCenter.default.post(name: .removeNoWifiBarID, object: nil)
        break
    case .unavailable:
        print("Network available via WiFi.")
        NotificationCenter.default.post(name: .showNoWifiBarID, object: nil)
        break
    }
  }
}
