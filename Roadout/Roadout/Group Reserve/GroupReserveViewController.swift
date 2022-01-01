//
//  GroupReserveViewController.swift
//  Roadout
//
//  Created by David Retegan on 19.12.2021.
//

import UIKit
import SwiftUI
import GroupActivities

@available(iOS 15, *)
class GroupReserveViewController: UIViewController {
        
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var locationCard: UIView!
    @IBOutlet weak var changeLocationBtn: UIButton!
    
    @IBOutlet weak var hostingView: UIView!
    
         
    @available (iOS 15.0, *)
    var menuItems: [UIAction] {
        return [
            UIAction(title: "End Session", image: UIImage(systemName: "xmark.circle"), attributes: .destructive, handler: { (_) in
                SharePlayManager.sharedInstance.endSession()
                self.dismiss(animated: true, completion: nil)
            }),
            
            UIAction(title: "Leave Session", image: UIImage(systemName: "arrow.down.right.and.arrow.up.left"), handler: { (_) in
                SharePlayManager.sharedInstance.leaveSession()
                self.dismiss(animated: true, completion: nil)
            }),
        ]
    }
    @available (iOS 15.0, *)
    var dismissMenu: UIMenu {
        return UIMenu(title: "What would you like to do?", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    func addObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .groupMessageReceivedID, object: nil)
    }
    
    @objc func updateUI() {
        DispatchQueue.main.async {
            self.locationLbl.text = SharePlayManager.sharedInstance.selectedLocation.name
        }
       
    }
    
    func addHostedView() {
        let host = UIHostingController(rootView: GroupSpotsView())
        guard let hostView = host.view else { return }
        hostView.translatesAutoresizingMaskIntoConstraints = false
        self.hostingView.addSubview(hostView)
        NSLayoutConstraint.activate([
            hostView.centerXAnchor.constraint(equalTo: self.hostingView.centerXAnchor),
            hostView.centerYAnchor.constraint(equalTo: self.hostingView.centerYAnchor),
            
            hostView.widthAnchor.constraint(equalTo: self.hostingView.widthAnchor),
            hostView.heightAnchor.constraint(equalTo: self.hostingView.heightAnchor),
            
            hostView.bottomAnchor.constraint(equalTo: self.hostingView.bottomAnchor),
            hostView.topAnchor.constraint(equalTo: self.hostingView.topAnchor),
            hostView.leftAnchor.constraint(equalTo: self.hostingView.leftAnchor),
            hostView.rightAnchor.constraint(equalTo: self.hostingView.rightAnchor)
        ])
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObs()
        doneBtn.menu = dismissMenu
        doneBtn.showsMenuAsPrimaryAction = true
        locationLbl.text = SharePlayManager.sharedInstance.selectedLocation.name
        
        changeLocationBtn.menu = makeLocationsMenu()
        changeLocationBtn.showsMenuAsPrimaryAction = true
        doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        locationCard.layer.cornerRadius = 12.0
        
        addHostedView()
    }
    
    func makeLocationsMenu() -> UIMenu {
        var locationMenuItems = [UIAction]()
        for location in parkLocations {
            locationMenuItems.append(UIAction(title: location.name, image: nil, handler: { (_) in
                SharePlayManager.sharedInstance.sendMessage(location)
            }))
        }
        let locationsMenu = UIMenu(title: "Pick location", image: nil, identifier: nil, options: [], children: locationMenuItems)
        return locationsMenu
    }

}
