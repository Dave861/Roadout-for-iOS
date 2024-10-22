//
//  SettingsViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//
import UIKit

class SettingsViewController: UIViewController {
    
    var cellTypes = ["UserSettingCell", "SpacerCell", "SingleCell", "SpacerCell", "UpCell", "SettingCell", "SettingCell", "DownCell", "SpacerCell", "UpCell", "DownCell", "SpacerCell", "UpCell", "SettingCell", "SettingCell", "DownCell", "SpacerCell", "ButtonCell", "SpacerCell", "TextCell"]
    var cellColors = ["", "", "GoldBrown", "", "Redish", "Dark Orange", "Second Orange", "Dark Yellow", "", "Icons", "Kinda Red", "", "Greyish", "Brownish", "ExpressFocus", "Main Yellow"]
    var cellIcons = ["", "", "engine_combustion", "", "bell.fill", "creditcard.fill", "arrow.triangle.branch", "scroll.fill", "", "car.fill", "magazine.fill", "", "ant.fill", "shield_lefthalf", "signature", "globe"]
    var cellSettings = ["", "", "Roadout VIP", "", "Notifications".localized(), "Payment Methods".localized(), "Default Directions App".localized(), "Parking History".localized(), "", "Roadout for Car".localized(), "User Guide".localized(), "", "Report a Bug".localized(), "Privacy Policy & Terms of Use".localized(), "Acknowledgements".localized(), "About Roadout".localized()]
    var cellVCs = ["AccountVC", "", "VIPVC", "", "NotificationsVC", "PaymentVC", "DirectionsVC", "HistoryVC", "", "CarVC", "GuideVC", "", "ReportBugVC", "LegalVC", "AckVC", "AboutVC"]
    
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
        let id = UserDefaults.roadout!.object(forKey: "eu.roadout.Roadout.userID") as! String
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
        
        if self.tableView.layer.mask == nil {
            let maskLayer: CAGradientLayer = CAGradientLayer()

            maskLayer.locations = [0.0, 0.2, 0.8, 1.0]
            let width = self.tableView.frame.size.width
            let height = self.tableView.frame.size.height
            maskLayer.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: height)
            maskLayer.anchorPoint = CGPoint.zero

            self.tableView.layer.mask = maskLayer
        }

        scrollViewDidScroll(self.tableView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let outerColor = UIColor(white: 1.0, alpha: 0.0).cgColor
        let innerColor = UIColor(white: 1.0, alpha: 1.0).cgColor

        var colors = [CGColor]()

        if scrollView.contentOffset.y + scrollView.contentInset.top <= 0 {
            colors = [innerColor, innerColor, innerColor, innerColor]
        } else if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
            colors = [outerColor, innerColor, innerColor, innerColor]
        } else {
            colors = [outerColor, innerColor, innerColor, outerColor]
        }

        if let mask = scrollView.layer.mask as? CAGradientLayer {
            mask.colors = colors

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            mask.position = CGPoint(x: 0.0, y: scrollView.contentOffset.y)
            CATransaction.commit()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
        }
    }
    
    //MARK: - Logic Functions -
    
    func signOutAllData() {
        UserDefaults.roadout!.set(false, forKey: "eu.roadout.Roadout.isUserSigned")
        UserDefaults.roadout!.removeObject(forKey: "eu.roadout.Roadout.userID")
                
        UserDefaults.roadout!.set(false, forKey: "eu.roadout.Roadout.shownTip1")
        UserDefaults.roadout!.set(false, forKey: "eu.roadout.Roadout.shownTip2")
        UserDefaults.roadout!.set(false, forKey: "eu.roadout.Roadout.shownTip3")
        UserDefaults.roadout!.set(false, forKey: "eu.roadout.Roadout.shownTip4")
        UserDefaults.roadout!.set(false, forKey: "eu.roadout.Roadout.shownTip5")
        UserDefaults.roadout!.set(false, forKey: "eu.roadout.Roadout.shownTip6")
        UserDefaults.roadout!.set(false, forKey: "eu.roadout.Roadout.shownTip7")
        UserDefaults.roadout!.set(false, forKey: "eu.roadout.Roadout.shownTip8")
        UserDefaults.roadout!.set(false, forKey: "eu.roadout.Roadout.shownTip9")
        UserDefaults.roadout!.set(false, forKey: "eu.roadout.Roadout.shownTip10")
        
        UserDefaults.roadout!.removeObject(forKey: "eu.roadout.Roadout.futureReservations")
        UserDefaults.roadout!.set([String](), forKey: "eu.roadout.paymentMethods")
        UserDefaults.roadout!.removeObject(forKey: "eu.roadout.Roadout.favouriteLocationIDs")
        UserDefaults.roadout!.set("", forKey: "eu.roadout.Roadout.userLicensePlate")
        userLicensePlate = ""
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
        case "SingleCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "SingleCell") as! SingleCell
            cell.icon.backgroundColor = UIColor(named: cellColors[indexPath.row])
            cell.settingLbl.text = cellSettings[indexPath.row]
            cell.iconImage.image = UIImage(systemName: cellIcons[indexPath.row]) ?? UIImage(named: cellIcons[indexPath.row])
            return cell
        case "UpCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpCell") as! UpCornerCell
            cell.icon.backgroundColor = UIColor(named: cellColors[indexPath.row])
            cell.settingLbl.text = cellSettings[indexPath.row]
            cell.iconImage.image = UIImage(systemName: cellIcons[indexPath.row]) ?? UIImage(named: cellIcons[indexPath.row])
            return cell
        case "DownCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "DownCell") as! DownCornerCell
            cell.icon.backgroundColor = UIColor(named: cellColors[indexPath.row])
            cell.settingLbl.text = cellSettings[indexPath.row]
            cell.iconImage.image = UIImage(systemName: cellIcons[indexPath.row]) ?? UIImage(named: cellIcons[indexPath.row])
            return cell
        case "SettingCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
            cell.icon.backgroundColor = UIColor(named: cellColors[indexPath.row])
            cell.settingLbl.text = cellSettings[indexPath.row]
            cell.iconImage.image = UIImage(systemName: cellIcons[indexPath.row]) ?? UIImage(named: cellIcons[indexPath.row])
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
            if cellVCs[indexPath.row] == "ReportBugVC" {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: cellVCs[indexPath.row])
                self.present(vc, animated: true)
            } else if cellVCs[indexPath.row] == "VIPVC" {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "VIPInfoVC") as! VIPInfoViewController
                self.present(vc, animated: true)
            } else {
                let sb = UIStoryboard(name: "Settings", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: cellVCs[indexPath.row])
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if cellTypes[indexPath.row] == "UpCell" || cellTypes[indexPath.row] == "SettingCell" || cellTypes[indexPath.row] == "DownCell" || cellTypes[indexPath.row] == "UserSettingCell" || cellTypes[indexPath.row] == "SingleCell" {
            switch cellTypes[indexPath.row] {
                case "UserSettingCell":
                    let cell = tableView.cellForRow(at: indexPath) as! UserSettingsCell
                    cell.card.backgroundColor = UIColor(named: "Highlight Secondary Detail")
                case "SingleCell":
                    let cell = tableView.cellForRow(at: indexPath) as! SingleCell
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
        if cellTypes[indexPath.row] == "UpCell" || cellTypes[indexPath.row] == "SettingCell" || cellTypes[indexPath.row] == "DownCell" || cellTypes[indexPath.row] == "UserSettingCell" || cellTypes[indexPath.row] == "SingleCell" {
            switch cellTypes[indexPath.row] {
                case "UserSettingCell":
                    let cell = tableView.cellForRow(at: indexPath) as! UserSettingsCell
                    cell.card.backgroundColor = UIColor(named: "Secondary Detail")
                case "SingleCell":
                    let cell = tableView.cellForRow(at: indexPath) as! SingleCell
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
