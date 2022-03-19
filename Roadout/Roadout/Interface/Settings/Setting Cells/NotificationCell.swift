//
//  NotificationCell.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    let UserDefaultsSuite = UserDefaults.init(suiteName: "group.ro.roadout.Roadout")!
        
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var enabledSwitch: UISwitch!
    
    @IBAction func switched(_ sender: UISwitch) {
        if titleLbl.text == "Reservation Status Notifications".localized() {
            UserDefaultsSuite.set(sender.isOn, forKey: "ro.roadout.reservationNotificationsEnabled")
        } else {
            UserDefaultsSuite.set(sender.isOn, forKey: "ro.roadout.reminderNotificationsEnabled")
        }
    }
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var explanationLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 16.0

    }
    
    override func didMoveToSuperview() {
        if titleLbl.text == "Reservation Status Notifications".localized() {
            enabledSwitch.isOn = UserPrefsUtils.sharedInstance.reservationNotificationsEnabled()
        } else {
            enabledSwitch.isOn = UserPrefsUtils.sharedInstance.reminderNotificationsEnabled()
        }
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
