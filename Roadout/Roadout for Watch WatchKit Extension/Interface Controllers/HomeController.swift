//
//  InterfaceController.swift
//  RWUI WatchKit Extension
//
//  Created by David Retegan on 22.05.2022.
//

import WatchKit
import Foundation

class HomeController: WKInterfaceController {

    @IBOutlet weak var unlockBtnGroup: WKInterfaceGroup!
    @IBAction func unlockTapped() {
        let unlockAction = WKAlertAction(title: "Unlock", style: .default) {
            ReservationManager.sharedInstance.unlockReservation(UserDefaults.roadout!.string(forKey: "ro.roadout.RoadoutWatch.UserID")!, date: Date()) { result in
                switch result {
                case .success():
                    self.presentController(withName: "UnlockedWKI", context: nil)
                case .failure(let err):
                    let okAction = WKAlertAction(title: "OK", style: .cancel) {}
                    self.presentAlert(withTitle: "Reservation Error", message: "Failed to unlock reservation from Apple Watch. Please try from the iPhone app.", preferredStyle: .alert, actions: [okAction])
                }
            }
        }
        let cancelAction = WKAlertAction(title: "Cancel", style: .cancel) {}
        self.presentAlert(withTitle: "Unlock Spot", message: "Are you sure you want to unlock the spot? This cannot be undone, once unlocked anyone will be able to park on the spot. You may still receive notifications on your iPhone, please ignore them.", preferredStyle: .alert, actions: [unlockAction, cancelAction])
    }
    @IBOutlet weak var timeLbl: WKInterfaceLabel!
    @IBOutlet weak var topTextLbl: WKInterfaceLabel!
    @IBOutlet weak var spacer2: WKInterfaceLabel!
    @IBOutlet weak var spacer1: WKInterfaceGroup!
    @IBOutlet weak var lockIcon: WKInterfaceImage!
    
    
    @IBOutlet weak var placeholderIcon: WKInterfaceImage!
    @IBOutlet weak var placeholderTopText: WKInterfaceLabel!
    @IBOutlet weak var placeholderBottomText: WKInterfaceLabel!
    
    @IBOutlet weak var activeReservationGroup: WKInterfaceGroup!
    @IBOutlet weak var notActiveReservationGroup: WKInterfaceGroup!
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadServerData), name: .reloadServerDataAWID, object: nil)
    }
    
    
    override func awake(withContext context: Any?) {
        self.manageObs()
        self.activeReservationGroup.setCornerRadius(15.8)
        self.notActiveReservationGroup.setCornerRadius(15.8)
        if UserDefaults.roadout!.string(forKey: "ro.roadout.RoadoutWatch.UserID") == nil {
            WKInterfaceController.reloadRootPageControllers(withNames: ["LinkRoadoutWKI"], contexts: nil, orientation: .vertical, pageIndex: 0)
        } else {
            self.reloadServerData()
        }
    }
    
    @objc func reloadServerData() {
        self.placeholderTopText.setText("Loading Reservation")
        self.placeholderIcon.setImage(UIImage(systemName: "scribble"))
        if UserDefaults.roadout!.string(forKey: "ro.roadout.RoadoutWatch.UserID") != nil {
            ReservationManager.sharedInstance.checkForReservation(Date(), userID: UserDefaults.roadout!.string(forKey: "ro.roadout.RoadoutWatch.UserID")!) { result in
                switch result {
                case .success():
                    if ReservationManager.sharedInstance.isReservationActive == 0 {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        self.timeLbl.setText(dateFormatter.string(from: ReservationManager.sharedInstance.reservationEndDate))
                        self.makeReservationViewVisible(visibility: true)
                        self.makePlaceholderViewVisible(visibility: false)
                    } else {
                        self.makeReservationViewVisible(visibility: false)
                        self.placeholderTopText.setText("No Active Reservation")
                        self.placeholderIcon.setImage(UIImage(systemName: "nosign"))
                        self.makePlaceholderViewVisible(visibility: true)
                    }
                case .failure(let err):
                    let okAction = WKAlertAction(title: "OK", style: .cancel) {}
                    self.presentAlert(withTitle: "Roadout Error", message: "Failed to retrieve reservation information.", preferredStyle: .alert, actions: [okAction])
                }
            }
        }
    }
    
    override func willActivate() {
        if UserDefaults.roadout!.string(forKey: "ro.roadout.RoadoutWatch.UserID") == nil {
            WKInterfaceController.reloadRootPageControllers(withNames: ["LinkRoadoutWKI"], contexts: nil, orientation: .vertical, pageIndex: 0)
        }
    }
    
    func makeReservationViewVisible(visibility: Bool) {
        spacer1.setHidden(!visibility)
        lockIcon.setHidden(!visibility)
        topTextLbl.setHidden(!visibility)
        timeLbl.setHidden(!visibility)
        unlockBtnGroup.setHidden(!visibility)
        activeReservationGroup.setHidden(!visibility)
    }
    
    func makePlaceholderViewVisible(visibility: Bool) {
        placeholderIcon.setHidden(!visibility)
        placeholderTopText.setHidden(!visibility)
        placeholderBottomText.setHidden(!visibility)
        notActiveReservationGroup.setHidden(!visibility)
        spacer2.setHidden(!visibility)
    }

}
