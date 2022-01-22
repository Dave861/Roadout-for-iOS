//
//  SignUpViewController.swift
//  Roadout
//
//  Created by David Retegan on 25.10.2021.
//

import UIKit

class SignUpViewController: UIViewController {

    let signUpTitle = NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurButton: UIButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var nameField: PaddedTextField!
    @IBOutlet weak var emailField: PaddedTextField!
    @IBOutlet weak var passwordField: PaddedTextField!
    @IBOutlet weak var confirmPasswordField: PaddedTextField!
    
  
    @IBAction func signUpTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if !isValidEmail(emailField.text ?? "") {
            let alert = UIAlertController(title: "Error", message: "Please enter a valid email address", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor(named: "Icons")
            self.present(alert, animated: true, completion: nil)
        } else if !isValidPassword(passwordField.text ?? "") {
            let alert = UIAlertController(title: "Error", message: "Please enter a password with minimum 8 characters, one capital letter and one number", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor(named: "Icons")
            self.present(alert, animated: true, completion: nil)
        } else if !isValidReenter() {
            let alert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor(named: "Icons")
            self.present(alert, animated: true, completion: nil)
        } else if !isValidName() {
            let alert = UIAlertController(title: "Error", message: "Please enter a name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor(named: "Icons")
            self.present(alert, animated: true, completion: nil)
        } else {
            UserManager.sharedInstance.userEmail = self.emailField.text!
            UserDefaults.roadout!.set(self.nameField.text!, forKey: "ro.roadout.Roadout.UserName")
            UserDefaults.roadout!.set(self.emailField.text!, forKey: "ro.roadout.Roadout.UserMail")
            UserDefaults.roadout!.set(self.passwordField.text!, forKey: "ro.roadout.Roadout.UserPassword")
            AuthManager.sharedInstance.sendRegisterData(emailField.text!)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObs()
        
        cardView.layer.cornerRadius = 16.0
        signUpBtn.layer.cornerRadius = 13.0
        signUpBtn.setAttributedTitle(signUpTitle, for: .normal)
        
        nameField.layer.cornerRadius = 12.0
        emailField.layer.cornerRadius = 12.0
        passwordField.layer.cornerRadius = 12.0
        confirmPasswordField.layer.cornerRadius = 12.0
        
        nameField.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Greyish")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        emailField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Brownish")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        passwordField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Dark Yellow")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        confirmPasswordField.attributedPlaceholder = NSAttributedString(
            string: "Confirm Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Dark Orange")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        
    }
    
    
    func addObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(manageServerSideResponse), name: .manageServerSideRegisterID, object: nil)
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
    
    func isValidPassword(_ password: String) -> Bool {
        let pswRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"

        let pswPred = NSPredicate(format:"SELF MATCHES %@", pswRegEx)
        return pswPred.evaluate(with: password)
    }
    
    func isValidReenter() -> Bool {
        return passwordField.text == confirmPasswordField.text
    }
    
    func isValidName() -> Bool {
        return nameField.text != ""
    }
    
    
    @objc func manageServerSideResponse() {
        switch AuthManager.sharedInstance.callResult {
            case "Success":
                let vc = storyboard?.instantiateViewController(withIdentifier: "VerifyMailVC") as! VerifyMailViewController
                self.present(vc, animated: true, completion: nil)
            case "error":
                let alert = UIAlertController(title: "Error", message: "There was an error. Try force quiting the app and reopening.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "user exists":
                let alert = UIAlertController(title: "Error", message: "User with this email already exists.", preferredStyle: .alert)
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
