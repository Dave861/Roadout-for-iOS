//
//  DeleteAccountViewController.swift
//  Roadout
//
//  Created by David Retegan on 08.01.2022.
//

import UIKit

class DeleteAccountViewController: UIViewController {

    let deleteTitle = NSAttributedString(string: "Confirm".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    var errorCounter = 0
    
    //MARK: -IB Connections-
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var emailField: PaddedTextField!
    @IBOutlet weak var passwordField: PaddedTextField!
    
  
    @IBAction func deleteTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if isValidEmail(emailField.text ?? "") && passwordField.text != "" {
           UserManager.sharedInstance.deleteAccount(emailField.text!, passwordField.text!) { result in
               switch result {
                   case .success():
                       UserDefaults.roadout!.set(false, forKey: "ro.roadout.Roadout.isUserSigned")
                       UserDefaults.roadout!.set("000", forKey: "ro.roadout.Roadout.userID")
                   let alert = UIAlertController(title: "Success".localized(), message: "User deleted successfully.".localized(), preferredStyle: .alert)
                   let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: { _ in
                           let sb = UIStoryboard(name: "Main", bundle: nil)
                           let vc = sb.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
                           self.view.window?.rootViewController = vc
                           self.view.window?.makeKeyAndVisible()
                       })
                       alert.addAction(okAction)
                       alert.view.tintColor = UIColor(named: "Redish")
                       self.present(alert, animated: true, completion: nil)
                   case .failure(let err):
                       print(err)
                       self.manageServerSideErrors()
                }
           }
        } else {
            let alert = UIAlertController(title: "Error".localized(), message: "Please enter a valid email address and password".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor(named: "Redish")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func blurTapped() {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
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
        let email = UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.UserMail")!
        let alert = UIAlertController(title: "Forgot Password".localized(), message: "We will send an email with a verification code to: ".localized() + "\(email).", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Proceed".localized(), style: .default) { _ in
            UserManager.sharedInstance.sendForgotData(email) { result in
                switch result {
                    case .success():
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordViewController
                        self.present(vc, animated: true, completion: nil)
                    case .failure(let err):
                        print(err)
                        self.manageForgotServerSideErrors()
                }
            }
        }
        let noAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        alert.view.tintColor = UIColor(named: "Redish")!
        UserManager.sharedInstance.forgotResumeScreen = "Delete Account"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 19.0
        deleteBtn.layer.cornerRadius = 13.0
        deleteBtn.setAttributedTitle(deleteTitle, for: .normal)
        
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
        manageForgotView(false)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.alpha = 1
        } completion: { _ in
            self.emailField.becomeFirstResponder()
        }
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func manageServerSideErrors() {
        switch UserManager.sharedInstance.callResult {
            case "error":
            let alert = UIAlertController(title: "Verification Error".localized(), message: "Wrong email or password.".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: { _ in
                    self.errorCounter += 1
                    if self.errorCounter >= 2 {
                        self.manageForgotView(true)
                    }
                })
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
    
    func manageForgotServerSideErrors() {
        if UserManager.sharedInstance.forgotResumeScreen == "Delete Account" {
            switch UserManager.sharedInstance.callResult {
                case "error":
                let alert = UIAlertController(title: "Error".localized(), message: "No user found with this email address.".localized(), preferredStyle: .alert)
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

}