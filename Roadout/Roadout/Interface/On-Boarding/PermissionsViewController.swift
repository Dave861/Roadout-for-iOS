//
//  PermissionsViewController.swift
//  Roadout
//
//  Created by David Retegan on 25.10.2021.
//

import UIKit
import CoreLocation
import UserNotifications

class PermissionsViewController: UIViewController {

    let permissionsIcons = [UIImage(systemName: "bell.fill"), UIImage(systemName: "map")]
    let permissionsColors = [UIColor(named: "Dark Orange"), UIColor(named: "Greyish")]
    let permissionsTitles = ["Notifications", "Location"]
    let permissionsTexts = ["Roadout needs permission to send notifications in order to give you status updates for your reservations and reminders about our promotions. You can control which notifications you get in notification settings.", "Roadout needs access to your location in order to be able to show you parking spots near you and allow you to make reservations. We do not share your location with third parties and do not use it to serve you ads.",]
    
    let continueTitle = NSAttributedString(string: "Continue", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let skipTitle = NSAttributedString(
        string: "Maybe Later",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Dark Orange")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
    )
    
    let UserDefaultsSuite = UserDefaults.init(suiteName: "group.ro.roadout.Roadout")!
    
    let center = UNUserNotificationCenter.current()
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var permissionsTableView: UITableView!
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBAction func nextTapped(_ sender: Any) {
        manageNotifications()
        manageLocation()
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        print("Skipped")
        UserDefaultsSuite.set(false, forKey: "ro.roadout.reservationNotificationsEnabled")
        UserDefaultsSuite.set(false, forKey: "ro.roadout.reminderNotificationsEnabled")
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.layer.cornerRadius = 13.0
        nextBtn.setAttributedTitle(continueTitle, for: .normal)
        skipBtn.setAttributedTitle(skipTitle, for: .normal)
        permissionsTableView.delegate = self
        permissionsTableView.dataSource = self
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }
    
    func manageNotifications() {
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                print("We good")
            } else {
                self.askNotificationPermission()
            }
        }
    }
    
    func askNotificationPermission() {
        if #available(iOS 15.0, *) {
            center.requestAuthorization(options: [.alert, .sound, .timeSensitive]) { granted, error in
                if granted {
                    print("Granted")
                    self.UserDefaultsSuite.set(true, forKey: "ro.roadout.reservationNotificationsEnabled")
                    self.UserDefaultsSuite.set(true, forKey: "ro.roadout.reminderNotificationsEnabled")
                } else {
                    print("Bad Luck")
                    self.UserDefaultsSuite.set(false, forKey: "ro.roadout.reservationNotificationsEnabled")
                    self.UserDefaultsSuite.set(false, forKey: "ro.roadout.reminderNotificationsEnabled")
                }
            }
        } else {
            center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted {
                    print("Granted")
                    self.UserDefaultsSuite.set(true, forKey: "ro.roadout.reservationNotificationsEnabled")
                    self.UserDefaultsSuite.set(true, forKey: "ro.roadout.reminderNotificationsEnabled")
                } else {
                    print("Bad Luck")
                    self.UserDefaultsSuite.set(false, forKey: "ro.roadout.reservationNotificationsEnabled")
                    self.UserDefaultsSuite.set(false, forKey: "ro.roadout.reminderNotificationsEnabled")
                }
            }
        }
    }
    
    func manageLocation() {
        if #available(iOS 14.0, *) {
            if locationManager!.authorizationStatus != .authorizedWhenInUse && locationManager!.authorizationStatus != .authorizedAlways {
                locationManager?.requestWhenInUseAuthorization()
            }
        } else {
            locationManager?.requestWhenInUseAuthorization()
        }
    }

}
extension PermissionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PermissionCell") as! PermissionCell
        cell.titleLabel.text = permissionsTitles[indexPath.row]
        cell.infoLabel.text = permissionsTexts[indexPath.row]
        cell.iconImage.image = permissionsIcons[indexPath.row]
        cell.iconImage.tintColor = permissionsColors[indexPath.row]
        
        return cell
    }
    
    
}
extension PermissionsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("YESS")
                }
            }
        }
    }
}
