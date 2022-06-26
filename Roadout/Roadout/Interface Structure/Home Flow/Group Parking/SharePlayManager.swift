//
//  SharePlayManager.swift
//  Roadout
//
//  Created by David Retegan on 19.12.2021.
//

import Foundation
import GroupActivities
import UIKit

@available(iOS 15, *)
class SharePlayManager {
    
    static let sharedInstance = SharePlayManager()
    
    var groupSession: GroupSession<GroupReserveActivity>?
    var groupMessenger: GroupSessionMessenger?
    
    var selectedLocation = parkLocations.first!
        
    func activateSession() {
        Task.init(priority: .high) {
            do {
                _ = try await GroupReserveActivity(parkingLocation: parkLocations.first!).activate()
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }
    
    func receiveSessions() {
        Task.init(priority: .high) {
            for await session in GroupReserveActivity.sessions() {
                configureGroupSession(session)
            }
        }
    }
    
    func configureGroupSession(_ groupSession: GroupSession<GroupReserveActivity>?) {
        self.groupSession = groupSession
        
        guard groupSession != nil else { return }
        let messenger = GroupSessionMessenger(session: groupSession!)
        groupMessenger = messenger
        
        Task.detached(priority: .high) {
            for await (message, _) in SharePlayManager.sharedInstance.groupMessenger!.messages(of: SharePlayMessage.self) {
                self.handleMessage(message)
                print(message.location.name)
            }
        }
        NotificationCenter.default.post(name: .groupSessionStartedID, object: nil)
        groupSession?.join()
        sendMessage(selectedLocation)
        NotificationCenter.default.post(name: .groupMessageReceivedID, object: nil)
    }
    
    func sendMessage(_ parkLocation: ParkLocation) {
        if let messenger = SharePlayManager.sharedInstance.groupMessenger {
            let msg = SharePlayMessage(location: parkLocation)
            self.handleMessage(msg)
            Task.init(priority: .high, operation: {
                do {
                    try await messenger.send(msg)
                } catch {
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    func leaveSession() {
        sendMessage(selectedLocation)
        groupMessenger = nil
        if groupSession != nil {
            groupSession?.leave()
            groupSession = nil
            NotificationCenter.default.post(name: .groupMessageReceivedID, object: nil)
        }
    }
    
    func endSession() {
        sendMessage(selectedLocation)
        groupMessenger = nil
        if groupSession != nil {
            groupSession?.end()
            groupSession = nil
            NotificationCenter.default.post(name: .groupMessageReceivedID, object: nil)
        }
    }
    
    func handleMessage(_ message: SharePlayMessage) {
        selectedLocation = message.location
        NotificationCenter.default.post(name: .groupMessageReceivedID, object: nil)
        print(message.location.name)
    }
    
}
