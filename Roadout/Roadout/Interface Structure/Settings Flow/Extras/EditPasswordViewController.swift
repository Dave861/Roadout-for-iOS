//
//  EditPasswordViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit

class EditPasswordViewController: UIViewController {

    let savedTitle = NSAttributedString(string: "Save".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    var errorCounter = 0
    
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var oldPswField: PaddedTextField!
    @IBOutlet weak var newPswField: PaddedTextField!
    @IBOutlet weak var confPswField: PaddedTextField!
    
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
    
    @IBAction func saveTapped(_ sender: Any) {
        if validateFields() {
            let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
            UserManager.sharedInstance.updatePassword(id, oldPswField.text!, newPswField.text!) { result in
                switch result {
                    case .success():
                    let alert = UIAlertController(title: "Success".localized(), message: "Your password was successfully changed!".localized(), preferredStyle: UIAlertController.Style.alert)
                    let alertAction = UIAlertAction(title: "OK".localized(), style: .default) { action in
                            UIView.animate(withDuration: 0.1) {
                                self.blurEffect.alpha = 0
                            } completion: { done in
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                        alertAction.setValue(UIColor(named: "Brownish")!, forKey: "titleTextColor")
                        alert.addAction(alertAction)
                        self.present(alert, animated: true, completion: nil)
                    case .failure(let err):
                        print(err)
                        self.manageServerSideErrors()
                }
            }
        } else {
            let alert = UIAlertController(title: "Error".localized(), message: "Please check all text fields".localized(), preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alertAction.setValue(UIColor(named: "Redish")!, forKey: "titleTextColor")
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func validateFields() -> Bool {
        if oldPswField.text == "" {
            return false
        }
        if isValidPassword() == false {
            return false
        }
        if isValidReenter() == false {
            return false
        }
        
        return true
    }
    
    func isValidPassword() -> Bool {
        let pswRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"

        let pswPred = NSPredicate(format:"SELF MATCHES %@", pswRegEx)
        return pswPred.evaluate(with: newPswField.text)
    }
    
    func isValidReenter() -> Bool {
        return newPswField.text == confPswField.text
    }
    
     func manageServerSideErrors() {
        switch UserManager.sharedInstance.callResult {
            case "Fail":
            let alert = UIAlertController(title: "Error".localized(), message: "Old password is incorrect.".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: { _ in
                    self.errorCounter += 1
                    if self.errorCounter >= 2 {
                        self.manageForgotView(true)
                    }
                })
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "error":
            let alert = UIAlertController(title: "Error".localized(), message: "There was an error when changing your password, please try again.".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "network error":
            let alert = UIAlertController(title: "Network Error".localized(), message: "Please check you network connection".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "database error":
            let alert = UIAlertController(title: "Internal Error".localized(), message: "There was an internal problem, please wait and try again a little later".localized(), preferredStyle: .alert)
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
        alert.view.tintColor = UIColor(named: "Brownish")!
        UserManager.sharedInstance.forgotResumeScreen = "Edit Password"
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        cardView.layer.cornerRadius = 19.0
        
        save.layer.cornerRadius = 12
        save.setAttributedTitle(savedTitle, for: .normal)
        
        oldPswField.layer.cornerRadius = 12.0
        oldPswField.attributedPlaceholder =
         NSAttributedString(
            string: "Old Password".localized(),
         attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
         )
        newPswField.layer.cornerRadius = 12.0
        newPswField.attributedPlaceholder =
         NSAttributedString(
            string: "New Password".localized(),
         attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
         )
        confPswField.layer.cornerRadius = 12.0
        confPswField.attributedPlaceholder =
         NSAttributedString(
            string: "Confirm Password".localized(),
         attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
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
            self.oldPswField.becomeFirstResponder()
        }
    }
    
    func manageForgotServerSideErrors() {
        if UserManager.sharedInstance.forgotResumeScreen == "Edit Password" {
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