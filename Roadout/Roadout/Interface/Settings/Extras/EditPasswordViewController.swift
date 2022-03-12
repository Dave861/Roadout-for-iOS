//
//  EditPasswordViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit

class EditPasswordViewController: UIViewController {

    let savedTitle = NSAttributedString(string: "Save", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    var errorCounter = 0
    
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurButton: UIButton!
    
    
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var oldPswField: PaddedTextField!
    @IBOutlet weak var newPswField: PaddedTextField!
    @IBOutlet weak var confPswField: PaddedTextField!
    
    @IBAction func dismissTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.blurButton.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
          self.blurButton.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.blurButton.alpha = 1
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if validateFields() {
            let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
            UserManager.sharedInstance.updatePassword(id, oldPswField.text!, newPswField.text!) { result in
                switch result {
                    case .success():
                        let alert = UIAlertController(title: "Success", message: "Your password was successfully changed!", preferredStyle: UIAlertController.Style.alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default) { action in
                            UIView.animate(withDuration: 0.1) {
                                self.blurButton.alpha = 0
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
            let alert = UIAlertController(title: "Error", message: "Please check all text fields", preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
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
                let alert = UIAlertController(title: "Error", message: "Old password is incorrect.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    self.errorCounter += 1
                    if self.errorCounter >= 2 {
                        self.manageForgotView(true)
                    }
                })
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "error":
                let alert = UIAlertController(title: "Error", message: "There was an error when changing your password, please try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "network error":
                let alert = UIAlertController(title: "Network Error", message: "Please check you network connection", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "database error":
                let alert = UIAlertController(title: "Internal Error", message: "There was an internal problem, please wait and try again a little later", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "unknown error":
                let alert = UIAlertController(title: "Unknown Error", message: "There was an error with the server respone, please screenshot this and send a bug report.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "error with json":
                let alert = UIAlertController(title: "JSON Error", message: "There was an error with the server respone, please screenshot this and send a bug report.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
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
        let alert = UIAlertController(title: "Forgot Password", message: "We will send an email with a verification code to: \(email). Do you want to proceed?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Proceed", style: .default) { _ in
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
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
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
        cardView.layer.cornerRadius = 16.0
        
        save.layer.cornerRadius = 12
        save.setAttributedTitle(savedTitle, for: .normal)
        
        oldPswField.layer.cornerRadius = 12.0
        oldPswField.attributedPlaceholder =
         NSAttributedString(
         string: "Old Password",
         attributes:
            [NSAttributedString.Key.foregroundColor: UIColor(named: "Greyish")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
         )
        newPswField.layer.cornerRadius = 12.0
        newPswField.attributedPlaceholder =
         NSAttributedString(
         string: "New Password",
         attributes:
            [NSAttributedString.Key.foregroundColor: UIColor(named: "Brownish")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
         )
        confPswField.layer.cornerRadius = 12.0
        confPswField.attributedPlaceholder =
         NSAttributedString(
         string: "Confirm Password",
         attributes:
            [NSAttributedString.Key.foregroundColor: UIColor(named: "Dark Yellow")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
         )
        
        manageForgotView(false)
        
    }
    
    func manageForgotServerSideErrors() {
        if UserManager.sharedInstance.forgotResumeScreen == "Edit Password" {
            switch UserManager.sharedInstance.callResult {
                case "error":
                    let alert = UIAlertController(title: "Error", message: "No user found with this email address.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                    self.present(alert, animated: true, completion: nil)
                case "network error":
                    let alert = UIAlertController(title: "Network Error", message: "Please check you network connection.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                    self.present(alert, animated: true, completion: nil)
                case "database error":
                    let alert = UIAlertController(title: "Internal Error", message: "There was an internal problem, please wait and try again a little later.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                    self.present(alert, animated: true, completion: nil)
                case "unknown error":
                    let alert = UIAlertController(title: "Unknown Error", message: "There was an error with the server respone, please screenshot this and send a bug report.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                    self.present(alert, animated: true, completion: nil)
                case "error with json":
                    let alert = UIAlertController(title: "JSON Error", message: "There was an error with the server respone, please screenshot this and send a bug report.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                    self.present(alert, animated: true, completion: nil)
                default:
                    fatalError()
            }
        }
    }
    

}
