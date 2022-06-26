//
//  NotificationsViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    let titles = ["Reservation Status Notifications".localized(), "Reminders Notifications".localized()]
    let explanations = ["Get timely notifications about the remaining time".localized(), "Get reminder notfications, set by you inside the app".localized()]

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var seeSettingsLbl: UILabel!
    
    @IBAction func seeSettingsTapped(_ sender: Any) {
        if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
            UIApplication.shared.open(appSettings)
        }
    }
    
    @IBOutlet weak var seeSettingsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seeSettingsBtn.setTitle("", for: .normal)
        
        if NotificationHelper.sharedInstance.areNotificationsAllowed ?? true == false {
            self.seeSettingsLbl.text = "Notifications are disabled. See settings".localized()
            self.seeSettingsLbl.set(textColor: UIColor(named: "Redish")!, range: self.seeSettingsLbl.range(after: ". "))
            self.seeSettingsLbl.set(font: .systemFont(ofSize: 18.0, weight: .medium), range: self.seeSettingsLbl.range(after: ". "))
        } else {
            self.seeSettingsLbl.text = "Notifications are enabled. See settings".localized()
            self.seeSettingsLbl.set(textColor: UIColor(named: "Redish")!, range: self.seeSettingsLbl.range(after: ". "))
            self.seeSettingsLbl.set(font: .systemFont(ofSize: 18.0, weight: .medium), range: self.seeSettingsLbl.range(after: ". "))
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationHelper.sharedInstance.manageNotifications()
    }
    

}
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        cell.titleLbl.text = titles[indexPath.row]
        cell.explanationLbl.text = explanations[indexPath.row]
        return cell
    }
    
}
