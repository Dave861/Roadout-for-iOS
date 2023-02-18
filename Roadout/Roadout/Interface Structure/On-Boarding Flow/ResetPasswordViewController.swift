//
//  ResetPasswordViewController.swift
//  Roadout
//
//  Created by David Retegan on 08.01.2022.
//

import UIKit
import CHIOTPField

class ResetPasswordViewController: UIViewController {
    
    let continueTitle = NSAttributedString(string: "Reset".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let checkTitle = NSAttributedString(string: "Check".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let skipTitle = NSAttributedString(
        string: "Cancel".localized(),
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
    )
    
    @IBOutlet weak var explainLbl: UILabel!
    
    @IBOutlet weak var codeField: AnyObject?
    @IBOutlet weak var checkBtn: UXButton!
    @IBAction func checkTapped(_ sender: Any) {
        if let codeField = codeField as? CHIOTPFieldOne {
            if Int(codeField.text!) == UserManager.sharedInstance.token && Date() < UserManager.sharedInstance.dateToken {
                passwordField.alpha = 1
                confirmPasswordField.alpha = 1
                passwordField.isEnabled = true
                confirmPasswordField.isEnabled = true
                resetBtn.isEnabled = true
                
                checkBtn.isEnabled = false
                codeField.alpha = 0
                codeField.isEnabled = false
                
                checkBtn.isHidden = true
                resetBtn.isHidden = false
                self.view.layoutIfNeeded()
            } else {
                let alert = UIAlertController(title: "Error".localized(), message: "Code is not valid or expired. Please check your email.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor.label
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var passwordField: PaddedTextField!
    @IBOutlet weak var confirmPasswordField: PaddedTextField!
    
    @IBOutlet weak var resetBtn: UXButton!
    @IBOutlet weak var cancelBtn: UXButton!
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func resetTapped(_ sender: Any) {
        if !isValidPassword(passwordField.text ?? "") {
            let alert = UIAlertController(title: "Error".localized(), message: "Please enter a password with minimum 6 characters, one capital letter and one number".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor.label
            self.present(alert, animated: true, completion: nil)
        } else if !isValidReenter() {
            let alert = UIAlertController(title: "Error".localized(), message: "Passwords do not match".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor.label
            self.present(alert, animated: true, completion: nil)
        } else {
            Task {
                do {
                    try await UserManager.sharedInstance.resetPasswordAsync(passwordField.text!)
                    DispatchQueue.main.async {
                        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                } catch let err {
                    self.manageServerSideErrors(err)
                }
            }
        }
    }
        
    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        passwordField.alpha = 0
        confirmPasswordField.alpha = 0
        passwordField.isEnabled = false
        confirmPasswordField.isEnabled = false
        passwordField.layer.cornerRadius = 12.0
        confirmPasswordField.layer.cornerRadius = 12.0
        
        passwordField.attributedPlaceholder = NSAttributedString(
            string: "Password".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        confirmPasswordField.attributedPlaceholder = NSAttributedString(
            string: "Confirm Password".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        resetBtn.isEnabled = false
        resetBtn.isHidden = true
        
        if let codeField = codeField as? CHIOTPFieldOne {
            codeField.keyboardAppearance = .default
            codeField.keyboardType = .numberPad
        }
        checkBtn.layer.cornerRadius = 13.0
        resetBtn.layer.cornerRadius = 13.0
        cancelBtn.layer.cornerRadius = 13.0
        resetBtn.setAttributedTitle(continueTitle, for: .normal)
        cancelBtn.setAttributedTitle(skipTitle, for: .normal)
        checkBtn.setAttributedTitle(checkTitle, for: .normal)
    }
    
    //MARK: - Validation Functions -
    
    func isValidPassword(_ password: String) -> Bool {
        let pswRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{6,}$"

        let pswPred = NSPredicate(format:"SELF MATCHES %@", pswRegEx)
        return pswPred.evaluate(with: password)
    }
    
    func isValidReenter() -> Bool {
        return passwordField.text == confirmPasswordField.text
    }
    
    func manageServerSideErrors(_ error: Error) {
        switch error {
            case UserManager.UserDBErrors.networkError:
                let alert = UIAlertController(title: "Network Error".localized(), message: "Please check you network connection.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                    self.present(alert, animated: true, completion: nil)
            case UserManager.UserDBErrors.databaseFailure:
                let alert = UIAlertController(title: "Internal Error".localized(), message: "There was an internal problem, please wait and try again a little later.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                    self.present(alert, animated: true, completion: nil)
            case UserManager.UserDBErrors.unknownError:
                let alert = UIAlertController(title: "Unknown Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                    self.present(alert, animated: true, completion: nil)
            case UserManager.UserDBErrors.errorWithJson:
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
