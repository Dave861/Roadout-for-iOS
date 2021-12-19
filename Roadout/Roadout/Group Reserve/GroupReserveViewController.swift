//
//  GroupReserveViewController.swift
//  Roadout
//
//  Created by David Retegan on 19.12.2021.
//

import UIKit

class GroupReserveViewController: UIViewController {
    
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var locationCard: UIView!
    @IBOutlet weak var changeLocationBtn: UIButton!
     
    @IBOutlet weak var peopleCounterLbl: UILabel!
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("ro.roadout.Roadout.groupMessageReceived"), object: nil)
    }
    
    @objc func updateUI() {
        DispatchQueue.main.async {
            if #available(iOS 15.0, *) {
                self.locationLbl.text = SharePlayManager.sharedInstance.selectedLocation.name
                self.peopleCounterLbl.text = "\(SharePlayManager.sharedInstance.peopleNumber) people"
                if SharePlayManager.sharedInstance.peopleNumber == 1 {
                    self.peopleCounterLbl.text = "\(SharePlayManager.sharedInstance.peopleNumber) person"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObs()
        if #available(iOS 15.0, *) {
            doneBtn.menu = dismissMenu
            doneBtn.showsMenuAsPrimaryAction = true
            
            locationLbl.text = SharePlayManager.sharedInstance.selectedLocation.name
            peopleCounterLbl.text = "\(SharePlayManager.sharedInstance.peopleNumber) people"
            if SharePlayManager.sharedInstance.peopleNumber == 1 {
                peopleCounterLbl.text = "\(SharePlayManager.sharedInstance.peopleNumber) person"
            }
            
            changeLocationBtn.menu = makeLocationsMenu()
            changeLocationBtn.showsMenuAsPrimaryAction = true
        }
        doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        locationCard.layer.cornerRadius = 12.0
    }
    
    @available (iOS 15.0, *)
    func makeLocationsMenu() -> UIMenu {
        var locationMenuItems = [UIAction]()
        for location in parkLocations {
            locationMenuItems.append(UIAction(title: location.name, image: nil, handler: { (_) in
                SharePlayManager.sharedInstance.sendMessage(location, SharePlayManager.sharedInstance.peopleNumber)
            }))
        }
        let locationsMenu = UIMenu(title: "Pick location", image: nil, identifier: nil, options: [], children: locationMenuItems)
        return locationsMenu
    }

}
