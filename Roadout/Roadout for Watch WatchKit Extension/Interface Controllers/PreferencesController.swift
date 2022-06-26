//
//  PreferencesController.swift
//  RWUI WatchKit Extension
//
//  Created by David Retegan on 22.05.2022.
//

import WatchKit
import Foundation

class PreferencesController: WKInterfaceController {

    @IBOutlet weak var nameLbl: WKInterfaceLabel!
    @IBOutlet weak var signOutGroup: WKInterfaceGroup!
    @IBOutlet weak var userGroup: WKInterfaceGroup!
    
    @IBAction func signOutTapped() {
        UserDefaults.roadout!.set(nil, forKey: "ro.roadout.RoadoutWatch.UserID")
        WKInterfaceController.reloadRootPageControllers(withNames: ["LinkRoadoutWKI"], contexts: nil, orientation: .vertical, pageIndex: 0)
    }
    
    override func awake(withContext context: Any?) {
        self.signOutGroup.setCornerRadius(20)
        self.userGroup.setCornerRadius(15.8)
        guard let id = UserDefaults.roadout!.string(forKey: "ro.roadout.RoadoutWatch.UserID") else {
            self.nameLbl.setText("Loading Name")
            return
        }
        self.nameLbl.setText(UserDefaults.roadout!.string(forKey: "ro.roadout.RoadoutWatch.UserName") ?? "Loading Name")
        UserManager.sharedInstance.getUserName(id) { result in
            switch result {
            case .success():
                self.nameLbl.setText(UserManager.sharedInstance.userName)
            case .failure(let error):
                print(error)
                self.nameLbl.setText(UserDefaults.roadout!.string(forKey: "ro.roadout.RoadoutWatch.UserName") ?? "Loading Name")
            }
        }
    }
    
    override func didAppear() {
        self.nameLbl.setText(UserDefaults.roadout!.string(forKey: "ro.roadout.RoadoutWatch.UserName") ?? "Loading Name")
    }
}
