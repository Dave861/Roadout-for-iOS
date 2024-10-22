//
//  DeleteAccountViewController.swift
//  Roadout
//
//  Created by David Retegan on 08.01.2022.
//

import UIKit

class DeleteAccountViewController: UIViewController {

    let deleteTitle = NSAttributedString(string: "Confirm".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    let forgotTitle = NSAttributedString(string: "Forgot Password?".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    private var errorCounter = 0
    private var initialCenter: CGPoint = .zero
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var deleteBtn: UXButton!
    
    @IBOutlet weak var emailField: PaddedTextField!
    @IBOutlet weak var passwordField: PaddedTextField!
    
  
    @IBAction func deleteTapped(_ sender: Any) {
        if isValidEmail(emailField.text ?? "") && passwordField.text != "" {
            Task {
                do {
                    try await UserManager.sharedInstance.deleteAccountAsync(emailField.text!, passwordField.text!)
                    UserDefaults.roadout!.set(false, forKey: "eu.roadout.Roadout.isUserSigned")
                    UserDefaults.roadout!.set("000", forKey: "eu.roadout.Roadout.userID")
                    //Add all other remo
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Success".localized(), message: "User deleted successfully.".localized(), preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: { _ in
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
                            self.view.window?.rootViewController = vc
                            self.view.window?.makeKeyAndVisible()
                        })
                        alert.addAction(okAction)
                        alert.view.tintColor = UIColor.Roadout.redish
                        self.present(alert, animated: true, completion: nil)
                    }
                } catch let err {
                    self.manageServerSideErrors(err)
                }
            }
        } else {
            let alert = UIAlertController(title: "Error".localized(), message: "Please enter a valid email address and password".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor.Roadout.redish
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
   
    
    //MARK: - Forgot Password -
        
    @IBOutlet weak var forgotBtn: UXPlainButton!
    
    @IBAction func forgotTapped(_ sender: Any) {
        let email = UserDefaults.roadout!.string(forKey: "eu.roadout.Roadout.UserMail")!
        let alert = UIAlertController(title: "Forgot Password".localized(), message: "We will send an email with a verification code to ".localized() + "\(email).", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Continue".localized(), style: .default) { _ in
            self.forgotBtn.startPulseAnimation()
            Task {
                do {
                    try await UserManager.sharedInstance.sendForgotDataAsync(email)
                    DispatchQueue.main.async {
                        self.forgotBtn.stopPulseAnimation()
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                } catch let err {
                    self.forgotBtn.stopPulseAnimation()
                    self.manageServerSideErrors(err)
                }
            }
        }
        let noAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        alert.view.tintColor = UIColor.Roadout.redish
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
    
    
    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 20.0
        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addShadowToCardView()

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
        
        forgotBtn.setAttributedTitle(forgotTitle, for: .normal)
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cardPanned))
        panRecognizer.delegate = self
        cardView.addGestureRecognizer(panRecognizer)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.alpha = 0.7
        } completion: { _ in
            self.emailField.becomeFirstResponder()
        }
    }
    
    func addShadowToCardView() {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 20.0
        cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
        cardView.layer.shouldRasterize = true
        cardView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    @objc func cardPanned(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
            case .began:
                initialCenter = cardView.center
            case .changed:
                let translation = recognizer.translation(in: cardView)
                if translation.y > 0 {
                    cardView.center = CGPoint(x: initialCenter.x, y: initialCenter.y + translation.y)
                    let progress = translation.y / (view.bounds.height / 2)
                    blurEffect.alpha = 0.7 - progress * 0.7 // decrease blur opacity as card is panned down
                }
            case .ended:
                let velocity = recognizer.velocity(in: cardView)
                if velocity.y >= 1000 {
                    self.view.endEditing(true)
                    UIView.animate(withDuration: 0.2, animations: {
                        self.blurEffect.alpha = 0
                        self.cardView.frame.origin.y = self.view.frame.maxY
                    }, completion: { done in
                        self.dismiss(animated: false, completion: nil)
                    })
                } else {
                    UIView.animate(withDuration: 0.2) {
                        self.cardView.center = self.initialCenter
                        self.blurEffect.alpha = 0.7
                    }
                }
            default:
                break
        }
    }
    
    //MARK: - Validation Functions -
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func manageServerSideErrors(_ error: Error) {
        switch error {
            case UserManager.UserDBErrors.wrongPassword:
                let alert = UIAlertController(title: "Verification Error".localized(), message: "Incorrect email or password.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: { _ in
                        self.errorCounter += 1
                        if self.errorCounter >= 2 {
                            self.manageForgotView(true)
                        }
                    })
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                    self.present(alert, animated: true, completion: nil)
            case UserManager.UserDBErrors.networkError:
                let alert = UIAlertController(title: "Network Error".localized(), message: "Please check you network connection.".localized(), preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                    self.present(alert, animated: true, completion: nil)
            case UserManager.UserDBErrors.databaseFailure:
                    let alert = UIAlertController(title: "Internal Error".localized(), message: "There was an internal problem, please wait and try again a little later.".localized(), preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                    self.present(alert, animated: true, completion: nil)
            case UserManager.UserDBErrors.unknownError:
                    let alert = UIAlertController(title: "Unknown Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                    self.present(alert, animated: true, completion: nil)
            case UserManager.UserDBErrors.errorWithJson:
                    let alert = UIAlertController(title: "JSON Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                    self.present(alert, animated: true, completion: nil)
            default:
                let alert = UIAlertController(title: "Error".localized(), message: "There was an error when changing your password, please try again.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor.Roadout.redish
                self.present(alert, animated: true, completion: nil)
        }
    }
    
}
extension DeleteAccountViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !deleteBtn.bounds.contains(touch.location(in: deleteBtn))
    }
}
