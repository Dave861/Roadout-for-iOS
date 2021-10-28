//
//  NotificationsViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    let titles = ["Reservation Status Notifications", "Reminders Notifications"]
    let explanations = ["Get timely notifications about the remaining time", "Get reminder notfications, set by you inside the app"]

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func seeSettingsTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "App-prefs:Notifications")!)
    }
    
    @IBOutlet weak var seeSettingsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setTitle("", for: .normal)
        seeSettingsBtn.setTitle("", for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
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
