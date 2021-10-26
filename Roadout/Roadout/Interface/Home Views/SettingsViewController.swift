//
//  SettingsViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let cellTypes = ["UserSettingCell", "SpacerCell", "UpCell", "SettingCell", "SettingCell", "SettingCell", "DownCell", "SpacerCell", "UpCell", "DownCell", "SpacerCell", "UpCell", "SettingCell", "DownCell", "SpacerCell", "ButtonCell", "SpacerCell", "TextCell"]
    let cellColors = ["", "", "Redish", "Dark Orange", "Second Orange", "Icons", "Dark Yellow", "", "Main Yellow", "Icons", "", "Greyish", "Brownish", "Main Yellow"]
    let cellIcons = ["", "", "bell.fill", "creditcard.fill", "arrow.triangle.branch", "clock.fill", "book.closed.fill", "", "envelope.open.fill", "rosette", "", "ant.fill", "newspaper.fill", "globe"]
    let cellSettings = ["", "", "Notifications", "Payment Methods", "Default Directions App", "Reminders", "Reservation History", "", "Invite Friends", "Prizes", "", "Report a Bug", "Privacy Policy & Terms of Use", "About Roadout"]

    @IBAction func backTapped(_ sender: Any) {
        self.dismissDetail()
    }
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @objc func backSegue() {
        self.dismissDetail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.setTitle("", for: .normal)
        let swipeLeft = UISwipeGestureRecognizer()
        swipeLeft.addTarget(self, action: #selector(backSegue) )
        swipeLeft.direction = .right
        self.view.addGestureRecognizer(swipeLeft)
        tableView.delegate = self
        tableView.dataSource = self
    }
    



}
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellTypes[indexPath.row] {
        case "UserSettingCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserSettingCell") as! UserSettingsCell
            return cell
        case "UpCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpCell") as! UpCornerCell
            cell.icon.backgroundColor = UIColor(named: cellColors[indexPath.row])
            cell.settingLbl.text = cellSettings[indexPath.row]
            cell.iconImage.image = UIImage(systemName: cellIcons[indexPath.row])
            return cell
        case "DownCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "DownCell") as! DownCornerCell
            cell.icon.backgroundColor = UIColor(named: cellColors[indexPath.row])
            cell.settingLbl.text = cellSettings[indexPath.row]
            cell.iconImage.image = UIImage(systemName: cellIcons[indexPath.row])
            return cell
        case "SettingCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
            cell.icon.backgroundColor = UIColor(named: cellColors[indexPath.row])
            cell.settingLbl.text = cellSettings[indexPath.row]
            cell.iconImage.image = UIImage(systemName: cellIcons[indexPath.row])
            return cell
        case "ButtonCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
            return cell
        case "TextCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! SettingsTextCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpacerCell") as! SpacerCell
            return cell
        }
    }
}
