//
//  VerifyMailViewController.swift
//  Roadout
//
//  Created by David Retegan on 08.01.2022.
//

import UIKit
import CHIOTPField
import CoreLocation
import UserNotifications

class VerifyMailViewController: UIViewController {
    
    let center = UNUserNotificationCenter.current()
    var locationManager: CLLocationManager?
    
    var permissionCounter = 0

    @IBOutlet weak var codeField: AnyObject?
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func verifyTapped(_ sender: Any) {
        if let codeField = codeField as? CHIOTPFieldOne {
            if Int(codeField.text!) == AuthManager.sharedInstance.verifyCode && Date().addingTimeInterval(300) < AuthManager.sharedInstance.dateToken {
                let name = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.UserName")!
                let email = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.UserMail")!
                let password = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.UserPassword")!
                AuthManager.sharedInstance.sendSignUpData(name, email, password) { result in
                    switch result {
                    case .success():
                        if AuthManager.sharedInstance.userID != nil {
                            UserDefaults.roadout!.set(true, forKey: "ro.roadout.Roadout.isUserSigned")
                            UserDefaults.roadout!.set(AuthManager.sharedInstance.userID, forKey: "ro.roadout.Roadout.userID")
                            self.manageScreens()
                            let email = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.UserMail")!
                            AuthManager.sharedInstance.deleteBadData(email)
                            UserDefaults.roadout!.removeObject(forKey: "ro.roadout.Roadout.UserName")
                            UserDefaults.roadout!.removeObject(forKey: "ro.roadout.Roadout.UserMail")
                            UserDefaults.roadout!.removeObject(forKey: "ro.roadout.Roadout.UserPassword")
                        } else {
                            let alert = UIAlertController(title: "Error".localized(), message: "There was an unknown error, please try again".localized(), preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                            alert.addAction(okAction)
                            alert.view.tintColor = UIColor(named: "Redish")
                            self.present(alert, animated: true, completion: nil)
                        }
                    case .failure(let err):
                        print(err)
                        self.manageServerSideErrors()
                    }
                }
            } else {
                let alert = UIAlertController(title: "Error".localized(), message: "Code is not valid or expired. Please check your email.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "ExpressFocus")!
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        let email = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.UserMail")!
        AuthManager.sharedInstance.deleteBadData(email)
        self.dismiss(animated: true, completion: nil)
    }
    
    let continueTitle = NSAttributedString(string: "Verify".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let skipTitle = NSAttributedString(
        string: "Cancel".localized(),
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "ExpressFocus")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
    )
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10.0
        cancelBtn.layer.cornerRadius = 13.0
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        cancelBtn.setAttributedTitle(skipTitle, for: .normal)
        locationManager = CLLocationManager()
    }
    
    func manageScreens() {
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
                if #available(iOS 14.0, *) {
                    if self.locationManager!.authorizationStatus == .authorizedWhenInUse || self.locationManager!.authorizationStatus == .authorizedAlways {
                        DispatchQueue.main.async {
                            let sb = UIStoryboard(name: "Home", bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
                            self.view.window?.rootViewController = vc
                            self.view.window?.makeKeyAndVisible()
                        }
                    } else {
                        DispatchQueue.main.async {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PermissionsVC") as! PermissionsViewController
                            self.present(vc, animated: false, completion: nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PermissionsVC") as! PermissionsViewController
                        self.present(vc, animated: false, completion: nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "PermissionsVC") as! PermissionsViewController
                    self.present(vc, animated: false, completion: nil)
                }
            }
        }
    }
    
    func manageServerSideErrors() {
        switch AuthManager.sharedInstance.callResult {
            case "error":
            let alert = UIAlertController(title: "Error".localized(), message: "User already exists, sign in or use another email.".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "network error":
            let alert = UIAlertController(title: "Network Error".localized(), message: "Please check you network connection.".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "database error":
            let alert = UIAlertController(title: "Internal Error".localized(), message: "There was an internal problem, please wait and try again a little later.".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "unknown error":
            let alert = UIAlertController(title: "Unknown Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "error with json":
            let alert = UIAlertController(title: "JSON Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            default:
                fatalError()
        }
    }
    
}
