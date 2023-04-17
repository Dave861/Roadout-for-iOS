//
//  SettingsViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//
import UIKit
import MessageUI

class SettingsViewController: UIViewController {
    
    var cellTypes = ["UserSettingCell", "SpacerCell", "UpCell", "SettingCell", "SettingCell", "DownCell", "SpacerCell", "UpCell", "DownCell", "SpacerCell", "UpCell", "SettingCell", "SettingCell", "DownCell", "SpacerCell", "ButtonCell", "SpacerCell", "TextCell"]
    var cellColors = ["", "", "Redish", "Dark Orange", "Second Orange", "Dark Yellow", "", "Icons", "GoldBrown", "", "Greyish", "Brownish", "ExpressFocus", "Main Yellow"]
    var cellIcons = ["", "", "bell.fill", "creditcard.fill", "arrow.triangle.branch", "scroll.fill", "", "car.fill", "book.fill", "", "ant.fill", "newspaper.fill", "signature", "globe"]
    var cellSettings = ["", "", "Notifications".localized(), "Payment Methods".localized(), "Default Directions App".localized(), "Reservation History".localized(), "", "Roadout for Car".localized(), "User Guide".localized(), "", "Report a Bug".localized(), "Privacy Policy & Terms of Use".localized(), "Acknowledgements".localized(), "About Roadout".localized()]
    var cellVCs = ["AccountVC", "", "NotificationsVC", "PaymentVC", "DirectionsVC", "HistoryVC", "", "CarVC", "GuideVC", "", "ReportVC", "LegalVC", "AckVC", "AboutVC"]
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View Configuration -
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadName), name: .reloadUserNameID, object: nil)
    }
    
    @objc func reloadName() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObs()
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        Task {
            do {
                try await UserManager.sharedInstance.getUserNameAsync(id)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let err {
                print(err)
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake && UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.shakeToReport") {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
        }
    }
    
    //MARK: - Logic Functions -

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.view.tintColor = UIColor.Roadout.greyish
            mail.setToRecipients(["roadout.ro@gmail.com"])
            mail.setSubject("Roadout for iOS - Report".localized())
            mail.setMessageBody("Please describe your issue and steps to reproduce it. If you have any screenshots please attach them - Roadout Team".localized(), isHTML: false)

            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Error".localized(), message: "This device cannot send emails, please check in settings your set email addresses, or report your bug at roadout.ro@gmail.com".localized(), preferredStyle: .alert)
            alert.view.tintColor = UIColor.Roadout.greyish
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func signOutAllData() {
        UserDefaults.roadout!.set(false, forKey: "ro.roadout.Roadout.isUserSigned")
        UserDefaults.roadout!.removeObject(forKey: "ro.roadout.Roadout.userID")
        
        UserDefaults.roadout!.set(true, forKey: "ro.roadout.Roadout.shakeToReport")
        
        UserDefaults.roadout!.set(false, forKey: "ro.roadout.Roadout.shownTip1")
        UserDefaults.roadout!.set(false, forKey: "ro.roadout.Roadout.shownTip2")
        UserDefaults.roadout!.set(false, forKey: "ro.roadout.Roadout.shownTip3")
        UserDefaults.roadout!.set(false, forKey: "ro.roadout.Roadout.shownTip4")
        UserDefaults.roadout!.set(false, forKey: "ro.roadout.Roadout.shownTip5")
        UserDefaults.roadout!.set(false, forKey: "ro.roadout.Roadout.shownTip6")
        UserDefaults.roadout!.set(false, forKey: "ro.roadout.Roadout.shownTip7")
        
        UserDefaults.roadout!.removeObject(forKey: "ro.roadout.Roadout.futureReservations")
        UserDefaults.roadout!.set([String](), forKey: "ro.roadout.paymentMethods")
        UserDefaults.roadout!.removeObject(forKey: "ro.roadout.Roadout.favouriteLocationIDs")
        UserDefaults.roadout!.set("", forKey: "ro.roadout.Roadout.userLicensePlate")
        userLicensePlate = ""
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
            let sb = UIStoryboard(name: "Settings", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: cellVCs[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        } else if cellTypes[indexPath.row] == "ButtonCell" {
            let alert = UIAlertController(title: "Sign Out".localized(), message: "Are you sure you want to sign out?".localized(), preferredStyle: .alert)
            alert.view.tintColor = UIColor.Roadout.darkOrange
            let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
            let signOutAction = UIAlertAction(title: "Sign Out".localized(), style: .destructive) { action in
                self.signOutAllData()
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
            } else {
                let sb = UIStoryboard(name: "Settings", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: cellVCs[indexPath.row])
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if cellTypes[indexPath.row] == "UpCell" || cellTypes[indexPath.row] == "SettingCell" || cellTypes[indexPath.row] == "DownCell" || cellTypes[indexPath.row] == "UserSettingCell" {
            switch cellTypes[indexPath.row] {
                case "UserSettingCell":
                    let cell = tableView.cellForRow(at: indexPath) as! UserSettingsCell
                    cell.card.backgroundColor = UIColor(named: "Highlight Secondary Detail")
                case "UpCell":
                    let cell = tableView.cellForRow(at: indexPath) as! UpCornerCell
                    cell.card.backgroundColor = UIColor(named: "Highlight Secondary Detail")
                case "SettingCell":
                    let cell = tableView.cellForRow(at: indexPath) as! SettingCell
                    cell.card.backgroundColor = UIColor(named: "Highlight Secondary Detail")
                case "DownCell":
                    let cell = tableView.cellForRow(at: indexPath) as! DownCornerCell
                    cell.card.backgroundColor = UIColor(named: "Highlight Secondary Detail")
                default:
                    break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if cellTypes[indexPath.row] == "UpCell" || cellTypes[indexPath.row] == "SettingCell" || cellTypes[indexPath.row] == "DownCell" || cellTypes[indexPath.row] == "UserSettingCell" {
            switch cellTypes[indexPath.row] {
                case "UserSettingCell":
                    let cell = tableView.cellForRow(at: indexPath) as! UserSettingsCell
                    cell.card.backgroundColor = UIColor(named: "Secondary Detail")
                case "UpCell":
                    let cell = tableView.cellForRow(at: indexPath) as! UpCornerCell
                    cell.card.backgroundColor = UIColor(named: "Secondary Detail")
                case "SettingCell":
                    let cell = tableView.cellForRow(at: indexPath) as! SettingCell
                    cell.card.backgroundColor = UIColor(named: "Secondary Detail")
                case "DownCell":
                    let cell = tableView.cellForRow(at: indexPath) as! DownCornerCell
                    cell.card.backgroundColor = UIColor(named: "Secondary Detail")
                default:
                    break
            }
        }
    }
}
