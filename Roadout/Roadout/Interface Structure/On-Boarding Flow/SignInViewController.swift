//
//  SignInViewController.swift
//  Roadout
//
//  Created by David Retegan on 25.10.2021.
//

import UIKit
import CoreLocation
import UserNotifications

class SignInViewController: UIViewController {
    
    let signInTitle = NSAttributedString(string: "Sign In".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    var errorCounter = 0
    
    let center = UNUserNotificationCenter.current()
    var locationManager: CLLocationManager?
    
    let indicatorImage = UIImage.init(systemName: "lines.measurement.horizontal")!.withTintColor(UIColor(named: "Main Yellow")!, renderingMode: .alwaysOriginal)
    var indicatorView: SPIndicatorView!
    
    //MARK: -IB Connections-
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @objc func blurTapped() {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var emailField: PaddedTextField!
    @IBOutlet weak var passwordField: PaddedTextField!
    
  
    @IBAction func signInTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        emailField.text = emailField.text?.replacingOccurrences(of: " ", with: "") //Account for user mistakes
        if isValidEmail(emailField.text ?? "") && passwordField.text != "" {
            self.indicatorView.present(haptic: .none, completion: nil)
            UserManager.sharedInstance.userEmail = self.emailField.text!
            UserDefaults.roadout!.set(self.emailField.text!, forKey: "ro.roadout.Roadout.UserMail")
            Task {
                do {
                    try await AuthManager.sharedInstance.sendSignInDataAsync(emailField.text!, passwordField.text!)
                    UserDefaults.roadout!.set(true, forKey: "ro.roadout.Roadout.isUserSigned")
                    UserDefaults.roadout!.set(AuthManager.sharedInstance.userID, forKey: "ro.roadout.Roadout.userID")
                    DispatchQueue.main.async {
                        self.indicatorView.dismiss()
                        self.manageScreens()
                    }
                } catch let err {
                    self.indicatorView.dismiss()
                    self.manageServerSideErrors(err)
                }
            }
        } else {
            let alert = UIAlertController(title: "Error".localized(), message: "Please enter a valid email address".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor(named: "Icons")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: -Forgot password-
        
    @IBOutlet weak var forgotBtn: UIButton!
    
    @IBAction func forgotTapped(_ sender: Any) {
        guard isValidEmail(emailField.text ?? "") else {
            let alert = UIAlertController(title: "Error".localized(), message: "Please enter a valid email in order to get a verification code to reset your password.".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let alert = UIAlertController(title: "Forgot Password".localized(), message: "We will send an email with a verification code to ".localized() + emailField.text!, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Proceed".localized(), style: .default) { _ in
            Task {
                do {
                    try await UserManager.sharedInstance.sendForgotDataAsync(self.emailField.text!)
                    DispatchQueue.main.async {
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                } catch let err {
                    self.manageServerSideErrors(err)
                }
            }
            UserManager.sharedInstance.userEmail = self.emailField.text!
            UserDefaults.roadout!.set(self.emailField.text!, forKey: "ro.roadout.Roadout.UserMail")
        }
        let noAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        alert.view.tintColor = UIColor(named: "Main Yellow")!
        self.present(alert, animated: true, completion: nil)
    }
    
    func manageForgotView(_ show: Bool) {
        if show {
            forgotBtn.isEnabled = true
            forgotBtn.alpha = 1
            forgotBtn.shake()
        } else {
            forgotBtn.isEnabled = false
            forgotBtn.alpha = 0
        }
    }
    
    //MARK: -View Configuration-
    
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    let forgotTitle = NSAttributedString(string: "Forgot Password?".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    func addShadowToCardView() {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 20.0
        cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
        cardView.layer.shouldRasterize = true
        cardView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 20.0
        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addShadowToCardView()
        
        signInBtn.layer.cornerRadius = 13.0
        signInBtn.setAttributedTitle(signInTitle, for: .normal)
        
        emailField.layer.cornerRadius = 12.0
        passwordField.layer.cornerRadius = 12.0
        
        emailField.attributedPlaceholder = NSAttributedString(
            string: "Email".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        passwordField.attributedPlaceholder = NSAttributedString(
            string: "Password".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        locationManager = CLLocationManager()
        manageForgotView(false)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
        
        indicatorView = SPIndicatorView(title: "Loading...".localized(), message: "Please wait".localized(), preset: .custom(indicatorImage))
        indicatorView.backgroundColor = UIColor(named: "Background")!
        indicatorView.dismissByDrag = false
        
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
        forgotBtn.setAttributedTitle(forgotTitle, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.blurEffect.alpha = 0.7
        } completion: { _ in
            self.emailField.becomeFirstResponder()
        }
    }
    
    func manageScreens() {
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional {
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
        }
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func manageServerSideErrors(_ error: Error) {
        switch error {
            case AuthManager.AuthErrors.userDoesNotExist:
                let alert = UIAlertController(title: "Sign In Error".localized(), message: "Wrong email or password.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: { _ in
                        self.errorCounter += 1
                        if self.errorCounter >= 2 {
                            self.manageForgotView(true)
                        }
                    })
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case AuthManager.AuthErrors.networkError:
                let alert = UIAlertController(title: "Network Error".localized(), message: "Please check you network connection.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                    self.present(alert, animated: true, completion: nil)
            case AuthManager.AuthErrors.databaseFailure:
                let alert = UIAlertController(title: "Internal Error".localized(), message: "There was an internal problem, please wait and try again a little later.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                    self.present(alert, animated: true, completion: nil)
            case AuthManager.AuthErrors.unknownError:
                let alert = UIAlertController(title: "Unknown Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                    self.present(alert, animated: true, completion: nil)
            case AuthManager.AuthErrors.errorWithJson:
                let alert = UIAlertController(title: "JSON Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                    self.present(alert, animated: true, completion: nil)
            default:
                let alert = UIAlertController(title: "Error".localized(), message: "There was an error. Try force quiting the app and reopening.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                    self.present(alert, animated: true, completion: nil)
        }
    }
}
