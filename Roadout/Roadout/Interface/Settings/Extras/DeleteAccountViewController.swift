//
//  DeleteAccountViewController.swift
//  Roadout
//
//  Created by David Retegan on 08.01.2022.
//

import UIKit

class DeleteAccountViewController: UIViewController {

    let deleteTitle = NSAttributedString(string: "Confirm", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    var errorCounter = 0
    
    //MARK: -IB Connections-
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurButton: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var emailField: PaddedTextField!
    @IBOutlet weak var passwordField: PaddedTextField!
    
  
    @IBAction func deleteTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if isValidEmail(emailField.text ?? "") && passwordField.text != "" {
           UserManager.sharedInstance.deleteAccount(emailField.text!, passwordField.text!)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter a valid email address and password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor(named: "Redish")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.blurButton.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func dismissTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.blurButton.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: -Forgot password-
        
    @IBOutlet weak var forgotBtn: UIButton!
    
    @IBAction func forgotTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordViewController
        self.present(vc, animated: true, completion: nil)
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
    
    func addObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(manageServerSide), name: .manageServerSideDeleteID, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObs()
        
        cardView.layer.cornerRadius = 16.0
        deleteBtn.layer.cornerRadius = 13.0
        deleteBtn.setAttributedTitle(deleteTitle, for: .normal)
        
        emailField.layer.cornerRadius = 12.0
        passwordField.layer.cornerRadius = 12.0
        
        emailField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Kinda Red")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        passwordField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Redish")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        manageForgotView(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.blurButton.alpha = 1
        }
    }
    
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @objc func manageServerSide() {
        switch UserManager.sharedInstance.callResult {
            case "Success":
                UserDefaults.roadout!.set(false, forKey: "ro.roadout.Roadout.isUserSigned")
                UserDefaults.roadout!.set("000", forKey: "ro.roadout.Roadout.userID")
                let alert = UIAlertController(title: "Success", message: "User deleted successfully.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
                    self.view.window?.rootViewController = vc
                    self.view.window?.makeKeyAndVisible()
                })
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "error":
                let alert = UIAlertController(title: "Verification Error", message: "Wrong email or password.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
                    self.errorCounter += 1
                    if self.errorCounter >= 2 {
                        self.manageForgotView(true)
                    }
                })
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
