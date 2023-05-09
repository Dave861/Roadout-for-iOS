//
//  NotificationsViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit

class NotificationsViewController: UIViewController {
        
    ///0 is for none, 1 is for normal notifications, 2 is for live activity
    var selectedNotificationTypeIndex = 0

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBOutlet weak var seeSettingsLbl: UILabel!
    
    @IBAction func seeSettingsTapped(_ sender: Any) {
        if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
            UIApplication.shared.open(appSettings)
        }
    }
    
    @IBOutlet weak var seeSettingsBtn: UIButton!
    
    @IBOutlet weak var reservationNotifCard: UIView!
    @IBOutlet weak var reservationTitle: UILabel!
    @IBOutlet weak var reservationDescription: UILabel!
    
    @IBOutlet weak var reservationNoneIcon: UIImageView!
    @IBOutlet weak var reservationNoneLabel: UILabel!
    @IBOutlet weak var reservationNoneBtn: UIButton!
    @IBAction func reservationNoneTapped(_ sender: Any) {
        UserDefaults.roadout!.set(0, forKey: "eu.roadout.reservationNotificationsOption")
        self.setReservationNotifPermissionsUI()
    }
    @IBOutlet weak var reservationNotifIcon: UIImageView!
    @IBOutlet weak var reservationNotifLabel: UILabel!
    @IBOutlet weak var reservationNotifBtn: UIButton!
    @IBAction func reservationNotifTapped(_ sender: Any) {
        UserDefaults.roadout!.set(1, forKey: "eu.roadout.reservationNotificationsOption")
        self.setReservationNotifPermissionsUI()
    }
    @IBOutlet weak var reservationLiveIcon: UIImageView!
    @IBOutlet weak var reservationLiveLabel: UILabel!
    @IBOutlet weak var reservationLiveBtn: UIButton!
    @IBAction func reservationLiveTapped(_ sender: Any) {
        if #available(iOS 16.1, *) {
            UserDefaults.roadout!.set(2, forKey: "eu.roadout.reservationNotificationsOption")
            self.setReservationNotifPermissionsUI()
        } else {
            let alert = UIAlertController(title: "Live Activities".localized(), message: "Live Activities are only available on iOS 16.1 or newer".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor.Roadout.redish
            self.present(alert, animated: true)
        }
    }
    
    @IBOutlet weak var locationNotifCard: UIView!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationDescription: UILabel!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBAction func locationSwitched(_ sender: Any) {
        UserDefaults.roadout!.set(locationSwitch.isOn, forKey: "eu.roadout.locationNotificationsEnabled")
    }
    
    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seeSettingsBtn.setTitle("", for: .normal)
        
        if NotificationHelper.sharedInstance.areNotificationsAllowed ?? true == false {
            self.seeSettingsLbl.text = "Notifications are disabled. See settings".localized()
            self.seeSettingsLbl.set(textColor: UIColor.Roadout.redish, range: self.seeSettingsLbl.range(after: ". "))
            self.seeSettingsLbl.set(font: .systemFont(ofSize: 18.0, weight: .medium), range: self.seeSettingsLbl.range(after: ". "))
        } else {
            self.seeSettingsLbl.text = "Notifications are enabled. See settings".localized()
            self.seeSettingsLbl.set(textColor: UIColor.Roadout.redish, range: self.seeSettingsLbl.range(after: ". "))
            self.seeSettingsLbl.set(font: .systemFont(ofSize: 18.0, weight: .medium), range: self.seeSettingsLbl.range(after: ". "))
        }
        
        self.localizeDescriptions()
        self.setReservationNotifPermissionsUI()
        self.locationSwitch.setOn(UserPrefsUtils.sharedInstance.locationNotificationsEnabled(), animated: false)
        reservationNotifCard.layer.cornerRadius = 16.0
        locationNotifCard.layer.cornerRadius = 16.0
        reservationNoneBtn.setTitle("", for: .normal)
        reservationNotifBtn.setTitle("", for: .normal)
        reservationLiveBtn.setTitle("", for: .normal)
        
        NotificationHelper.sharedInstance.manageNotifications()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
        }
    }
    
    func localizeDescriptions() {
        reservationTitle.text = "Reservation Status Notifications".localized()
        locationTitle.text = "Location Notifications".localized()
        
        reservationDescription.text = "Get timely notifications about the remaining time. Changes will apply to your next reservation".localized()
        locationDescription.text = "Get location based notifications when you arrive at the current reservation".localized()
        
        reservationNoneLabel.text = "None".localized()
        reservationNotifLabel.text = "Notifications".localized()
        reservationLiveLabel.text = "Live Activity".localized()
    }
    
    func setReservationNotifPermissionsUI() {
        selectedNotificationTypeIndex = UserPrefsUtils.sharedInstance.reservationNotificationsEnabled()
        
        switch selectedNotificationTypeIndex {
            case 0:
                self.reservationNoneIcon.image = UIImage(named: "None_Enabled")!
                self.reservationNoneLabel.textColor = UIColor.Roadout.redish
                self.reservationNotifIcon.image = UIImage(named: "Notif_Disabled")!
                self.reservationNotifLabel.textColor = UIColor.systemGray
                self.reservationLiveIcon.image = UIImage(named: "Live_Disabled")!
                self.reservationLiveLabel.textColor = UIColor.systemGray
            case 1:
                self.reservationNoneIcon.image = UIImage(named: "None_Disabled")!
                self.reservationNoneLabel.textColor = UIColor.systemGray
                self.reservationNotifIcon.image = UIImage(named: "Notif_Enabled")!
                self.reservationNotifLabel.textColor = UIColor.Roadout.redish
                self.reservationLiveIcon.image = UIImage(named: "Live_Disabled")!
                self.reservationLiveLabel.textColor = UIColor.systemGray
            case 2:
                self.reservationNoneIcon.image = UIImage(named: "None_Disabled")!
                self.reservationNoneLabel.textColor = UIColor.systemGray
                self.reservationNotifIcon.image = UIImage(named: "Notif_Disabled")!
                self.reservationNotifLabel.textColor = UIColor.systemGray
                self.reservationLiveIcon.image = UIImage(named: "Live_Enabled")!
                self.reservationLiveLabel.textColor = UIColor.Roadout.redish
            default:
                self.reservationNoneIcon.image = UIImage(named: "None_Enabled")!
                self.reservationNoneLabel.textColor = UIColor.Roadout.redish
                self.reservationNotifIcon.image = UIImage(named: "Notif_Disabled")!
                self.reservationNotifLabel.textColor = UIColor.systemGray
                self.reservationLiveIcon.image = UIImage(named: "Live_Disabled")!
                self.reservationLiveLabel.textColor = UIColor.systemGray
        }
    }
}
