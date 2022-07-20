//
//  SignUpViewController.swift
//  Roadout
//
//  Created by David Retegan on 25.10.2021.
//

import UIKit
import SPIndicator

class SignUpViewController: UIViewController {

    let signUpTitle = NSAttributedString(string: "Sign Up".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    let indicatorImage = UIImage.init(systemName: "lines.measurement.horizontal")!.withTintColor(UIColor(named: "Dark Yellow")!, renderingMode: .alwaysOriginal)
    var indicatorView: SPIndicatorView!
    
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
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var nameField: PaddedTextField!
    @IBOutlet weak var emailField: PaddedTextField!
    @IBOutlet weak var passwordField: PaddedTextField!
    @IBOutlet weak var confirmPasswordField: PaddedTextField!
    
  
    @IBAction func signUpTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if !isValidEmail(emailField.text ?? "") {
            let alert = UIAlertController(title: "Error".localized(), message: "Please enter a valid email address".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor(named: "Icons")
            self.present(alert, animated: true, completion: nil)
        } else if !isValidPassword(passwordField.text ?? "") {
            let alert = UIAlertController(title: "Error".localized(), message: "Please enter a password with minimum 8 characters, one capital letter and one number".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor(named: "Icons")
            self.present(alert, animated: true, completion: nil)
        } else if !isValidReenter() {
            let alert = UIAlertController(title: "Error".localized(), message: "Passwords do not match".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor(named: "Icons")
            self.present(alert, animated: true, completion: nil)
        } else if !isValidName() {
            let alert = UIAlertController(title: "Error".localized(), message: "Please enter a name".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor(named: "Icons")
            self.present(alert, animated: true, completion: nil)
        } else {
            self.indicatorView.present(haptic: .none, completion: nil)
            UserManager.sharedInstance.userEmail = self.emailField.text!
            UserDefaults.roadout!.set(self.nameField.text!, forKey: "ro.roadout.Roadout.UserName")
            UserDefaults.roadout!.set(self.emailField.text!, forKey: "ro.roadout.Roadout.UserMail")
            UserDefaults.roadout!.set(self.passwordField.text!, forKey: "ro.roadout.Roadout.UserPassword")
            AuthManager.sharedInstance.sendRegisterData(emailField.text!) { result in
                switch result {
                    case .success():
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyMailVC") as! VerifyMailViewController
                        self.present(vc, animated: true, completion: nil)
                    case .failure(let err):
                        print(err)
                        self.manageServerSideError()
                }
                self.indicatorView.dismiss()
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
   
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
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

        signUpBtn.layer.cornerRadius = 13.0
        signUpBtn.setAttributedTitle(signUpTitle, for: .normal)
        
        nameField.layer.cornerRadius = 12.0
        emailField.layer.cornerRadius = 12.0
        passwordField.layer.cornerRadius = 12.0
        confirmPasswordField.layer.cornerRadius = 12.0
        
        nameField.attributedPlaceholder = NSAttributedString(
            string: "Name".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        emailField.attributedPlaceholder = NSAttributedString(
            string: "Email".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        passwordField.attributedPlaceholder = NSAttributedString(
            string: "Password".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        confirmPasswordField.attributedPlaceholder = NSAttributedString(
            string: "Confirm Password".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
        
        indicatorView = SPIndicatorView(title: "Loading...".localized(), message: "Please wait".localized(), preset: .custom(indicatorImage))
        indicatorView.backgroundColor = UIColor(named: "Background")!
        indicatorView.dismissByDrag = false
        
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
    }
    
    
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.blurEffect.alpha = 0.7
        } completion: { _ in
            self.nameField.becomeFirstResponder()
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
    
    
     func manageServerSideError() {
        switch AuthManager.sharedInstance.callResult {
            case "error":
            let alert = UIAlertController(title: "Error".localized(), message: "There was an error. Try force quiting the app and reopening.".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "user exists":
            let alert = UIAlertController(title: "User Error".localized(), message: "User with this email already exists. Try signing in.".localized(), preferredStyle: .alert)
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
