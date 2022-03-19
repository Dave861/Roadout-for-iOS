//
//  SettingsViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {
    
    var cellTypes = ["UserSettingCell", "SpacerCell", "UpCell", "SettingCell", "SettingCell", "SettingCell", "DownCell", "SpacerCell", "UpCell", "DownCell", "SpacerCell", "UpCell", "SettingCell", "SettingCell", "DownCell", "SpacerCell", "ButtonCell", "SpacerCell", "TextCell"]
    var cellColors = ["", "", "Redish", "Dark Orange", "Second Orange", "Icons", "Dark Yellow", "", "Main Yellow", "Icons", "", "Greyish", "Brownish", "ExpressFocus", "Main Yellow"]
    var cellIcons = ["", "", "bell.fill", "creditcard.fill", "arrow.triangle.branch", "clock.fill", "book.closed.fill", "", "envelope.open.fill", "rosette", "", "ant.fill", "newspaper.fill", "signature" ,"globe"]
    var cellSettings = ["", "", "Notifications".localized(), "Payment Methods".localized(), "Default Directions App".localized(), "Reminders".localized(), "Reservation History".localized(), "", "Invite Friends".localized(), "Prizes".localized(), "", "Report a Bug".localized(), "Privacy Policy & Terms of Use".localized(), "Acknowledgements".localized(), "About Roadout".localized()]

    var cellVCs = ["", "", "NotificationsVC", "PaymentVC", "DirectionsVC", "RemindersVC", "HistoryVC", "", "InviteVC", "PrizesVC", "", "ReportVC", "LegalVC", "AckVC", "AboutVC"]
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    func setDeveloperView(_ id: Int) {
        if id == 16 {
            cellTypes = ["UserSettingCell", "SpacerCell", "UpCell", "SettingCell", "SettingCell", "SettingCell", "DownCell", "SpacerCell", "UpCell", "DownCell", "SpacerCell", "UpCell", "SettingCell", "SettingCell", "SettingCell", "DownCell", "SpacerCell", "ButtonCell", "SpacerCell", "TextCell"]
            cellColors = ["", "", "Redish", "Dark Orange", "Second Orange", "Icons", "Dark Yellow", "", "Main Yellow", "Icons", "", "Greyish", "Brownish", "ExpressFocus", "DevBrown", "Main Yellow"]
            cellIcons = ["", "", "bell.fill", "creditcard.fill", "arrow.triangle.branch", "clock.fill", "book.closed.fill", "", "envelope.open.fill", "rosette", "", "ant.fill", "newspaper.fill", "signature", "screwdriver.fill" ,"globe"]
            cellSettings = ["", "", "Notifications".localized(), "Payment Methods".localized(), "Default Directions App".localized(), "Reminders".localized(), "Reservation History".localized(), "", "Invite Friends".localized(), "Prizes".localized(), "", "Report a Bug".localized(), "Privacy Policy & Terms of Use".localized(), "Acknowledgements".localized(), "Developer".localized(), "About Roadout".localized()]

            cellVCs = ["", "", "NotificationsVC", "PaymentVC", "DirectionsVC", "RemindersVC", "HistoryVC", "", "InviteVC", "PrizesVC", "", "ReportVC", "LegalVC", "AckVC", "DeveloperVC", "AboutVC"]
        } else {
            cellTypes = ["UserSettingCell", "SpacerCell", "UpCell", "SettingCell", "SettingCell", "SettingCell", "DownCell", "SpacerCell", "UpCell", "DownCell", "SpacerCell", "UpCell", "SettingCell", "SettingCell", "DownCell", "SpacerCell", "ButtonCell", "SpacerCell", "TextCell"]
            cellColors = ["", "", "Redish", "Dark Orange", "Second Orange", "Icons", "Dark Yellow", "", "Main Yellow", "Icons", "", "Greyish", "Brownish", "ExpressFocus", "Main Yellow"]
            cellIcons = ["", "", "bell.fill", "creditcard.fill", "arrow.triangle.branch", "clock.fill", "book.closed.fill", "", "envelope.open.fill", "rosette", "", "ant.fill", "newspaper.fill", "signature" ,"globe"]
            cellSettings = ["", "", "Notifications".localized(), "Payment Methods".localized(), "Default Directions App".localized(), "Reminders".localized(), "Reservation History".localized(), "", "Invite Friends".localized(), "Prizes".localized(), "", "Report a Bug".localized(), "Privacy Policy & Terms of Use".localized(), "Acknowledgements".localized(), "About Roadout".localized()]

            cellVCs = ["", "", "NotificationsVC", "PaymentVC", "DirectionsVC", "RemindersVC", "HistoryVC", "", "InviteVC", "PrizesVC", "", "ReportVC", "LegalVC", "AckVC", "AboutVC"]
        }
    }
    
    func addObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadName), name: .reloadUserNameID, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        UserManager.sharedInstance.getUserName(id) { result in
            print(result)
        }
        self.setDeveloperView(Int(id) ?? 0)
        tableView.delegate = self
        tableView.dataSource = self
        addObs()
    }
    
    @objc func reloadName() {
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        UserManager.sharedInstance.getUserName(id) { result in
            print(result)
        }
        tableView.reloadData()
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
            mail.setSubject("Roadout for iOS - Report".localized())
            mail.setMessageBody("Please describe your issue and steps to reproduce it. If you have any screenshots please attach them - Roadout Team".localized(), isHTML: false)

            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Error".localized(), message: "This device cannot send emails, please check in settings your set email addresses, or report your bug at roadout.ro@gmail.com".localized(), preferredStyle: .alert)
            alert.view.tintColor = UIColor(named: "Greyish")
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
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
            cell.nameLbl.text = UserManager.sharedInstance.userName
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
            let alert = UIAlertController(title: "Sign Out".localized(), message: "Are you sure you want to sign out?".localized(), preferredStyle: .alert)
            alert.view.tintColor = UIColor(named: "Dark Orange")
            let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
            let signOutAction = UIAlertAction(title: "Sign Out".localized(), style: .destructive) { action in
                UserDefaults.roadout!.set(false, forKey: "ro.roadout.Roadout.isUserSigned")
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
