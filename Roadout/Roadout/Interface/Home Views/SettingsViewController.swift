//
//  SettingsViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {
    
    let cellTypes = ["UserSettingCell", "SpacerCell", "UpCell", "SettingCell", "SettingCell", "SettingCell", "DownCell", "SpacerCell", "UpCell", "DownCell", "SpacerCell", "UpCell", "SettingCell", "DownCell", "SpacerCell", "ButtonCell", "SpacerCell", "TextCell"]
    let cellColors = ["", "", "Redish", "Dark Orange", "Second Orange", "Icons", "Dark Yellow", "", "Main Yellow", "Icons", "", "Greyish", "Brownish", "Main Yellow"]
    let cellIcons = ["", "", "bell.fill", "creditcard.fill", "arrow.triangle.branch", "clock.fill", "book.closed.fill", "", "envelope.open.fill", "rosette", "", "ant.fill", "newspaper.fill", "globe"]
    let cellSettings = ["", "", "Notifications", "Payment Methods", "Default Directions App", "Reminders", "Reservation History", "", "Invite Friends", "Prizes", "", "Report a Bug", "Privacy Policy & Terms of Use", "About Roadout"]

    let cellVCs = ["", "", "NotificationsVC", "PaymentVC", "DirectionsVC", "RemindersVC", "HistoryVC", "", "InviteVC", "PrizesVC", "", "ReportVC", "LegalVC", "AboutVC"]
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.setTitle("", for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.view.tintColor = UIColor(named: "Greyish")
            mail.setToRecipients(["roadout.ro@gmail.com"])
            mail.setSubject("Bug Report")
            mail.setMessageBody("Roadout for iOS: Please describe your issue and steps to reproduce it. If you have any screenshots please attach them - Roadout Team", isHTML: false)

            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "This device cannot send email, please check in settings your set email addresses, or report your bug at roadout.ro@gmail.com", preferredStyle: .alert)
            alert.view.tintColor = UIColor(named: "Greyish")
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cellTypes[indexPath.row] == "UserSettingCell" {
            print("cool")
        } else if cellTypes[indexPath.row] == "ButtonCell" {
            let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
            alert.view.tintColor = UIColor(named: "Dark Orange")
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { action in
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
                self.view.window?.rootViewController = vc
                self.view.window?.makeKeyAndVisible()
            }
            alert.addAction(signOutAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else if cellTypes[indexPath.row] != "SpacerCell" &&  cellTypes[indexPath.row] != "TextCell" {
            if cellVCs[indexPath.row] == "ReportVC" {
                sendEmail()
            } else if cellVCs[indexPath.row] == "AboutVC" {
                if let url = URL(string: "https://www.roadout.ro") {
                    UIApplication.shared.open(url)
                }
            } else {
                let sb = UIStoryboard(name: "Settings", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: cellVCs[indexPath.row])
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
