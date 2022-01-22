//
//  ResetPasswordViewController.swift
//  Roadout
//
//  Created by David Retegan on 08.01.2022.
//

import UIKit
import CHIOTPField

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var explainLbl: UILabel!
    
    @IBOutlet weak var codeField: AnyObject?
    @IBOutlet weak var checkBtn: UIButton!
    @IBAction func checkTapped(_ sender: Any) {
        if let codeField = codeField as? CHIOTPFieldOne {
            print(codeField.text)
            if Int(codeField.text!) == UserManager.sharedInstance.resetCode && Date().addingTimeInterval(300) < UserManager.sharedInstance.dateToken {
                passwordField.alpha = 1
                confirmPasswordField.alpha = 1
                passwordField.isEnabled = true
                confirmPasswordField.isEnabled = true
                resetBtn.isEnabled = true
                resetBtn.alpha = 1
                
                checkBtn.isEnabled = false
                checkBtn.alpha = 0
                codeField.alpha = 0
                codeField.isEnabled = false
            } else {
                let alert = UIAlertController(title: "Error", message: "Code is not valid or expired. Please check your email.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor.label
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var passwordField: PaddedTextField!
    @IBOutlet weak var confirmPasswordField: PaddedTextField!
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func resetTapped(_ sender: Any) {
        if !isValidPassword(passwordField.text ?? "") {
            let alert = UIAlertController(title: "Error", message: "Please enter a password with minimum 8 characters, one capital letter and one number", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor.label
            self.present(alert, animated: true, completion: nil)
        } else if !isValidReenter() {
            let alert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor.label
            self.present(alert, animated: true, completion: nil)
        } else {
            UserManager.sharedInstance.resetPassword(passwordField.text!)
        }
    }
    
    let continueTitle = NSAttributedString(string: "Reset", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let skipTitle = NSAttributedString(
        string: "Cancel",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
    )
    
    func addObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(manageResetPasswordServerSide), name: .manageResetPasswordServerSideID, object: nil)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        addObs()
        
        passwordField.alpha = 0
        confirmPasswordField.alpha = 0
        passwordField.isEnabled = false
        confirmPasswordField.isEnabled = false
        passwordField.layer.cornerRadius = 12.0
        confirmPasswordField.layer.cornerRadius = 12.0
        
        passwordField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        confirmPasswordField.attributedPlaceholder = NSAttributedString(
            string: "Confirm Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Greyish")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        resetBtn.isEnabled = false
        resetBtn.alpha = 0
        
        if let codeField = codeField as? CHIOTPFieldOne {
            codeField.keyboardAppearance = .default
            codeField.keyboardType = .numberPad
        }
        checkBtn.layer.cornerRadius = 10.0
        resetBtn.layer.cornerRadius = 13.0
        resetBtn.setAttributedTitle(continueTitle, for: .normal)
        cancelBtn.setAttributedTitle(skipTitle, for: .normal)
        
    }
    
    
    func isValidPassword(_ password: String) -> Bool {
        let pswRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"

        let pswPred = NSPredicate(format:"SELF MATCHES %@", pswRegEx)
        return pswPred.evaluate(with: password)
    }
    
    func isValidReenter() -> Bool {
        return passwordField.text == confirmPasswordField.text
    }
    
    @objc func manageResetPasswordServerSide() {
        switch UserManager.sharedInstance.callResult {
            case "Success":
                self.dismiss(animated: true, completion: nil)
            case "error":
                let alert = UIAlertController(title: "Error", message: "There was an error. Try force quiting the app and reopening.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "network error":
                let alert = UIAlertController(title: "Network Error", message: "Please check you network connection.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "database error":
                let alert = UIAlertController(title: "Internal Error", message: "There was an internal problem, please wait and try again a little later.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "unknown error":
                let alert = UIAlertController(title: "Unknown Error", message: "There was an error with the server respone, please screenshot this and send a bug report.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "error with json":
                let alert = UIAlertController(title: "JSON Error", message: "There was an error with the server respone, please screenshot this and send a bug report.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            default:
                fatalError()
        }
    }
    
    
    
}
