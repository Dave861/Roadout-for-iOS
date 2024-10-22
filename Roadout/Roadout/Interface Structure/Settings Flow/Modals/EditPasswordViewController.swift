//
//  EditPasswordViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit

class EditPasswordViewController: UIViewController {

    let savedTitle = NSAttributedString(string: "Save".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    let forgotTitle = NSAttributedString(string: "Forgot Password?".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    private var errorCounter = 0
    private var initialCenter: CGPoint = .zero

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var saveBtn: UXButton!
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
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func cancelTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
          self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if validateFields() {
            let id = UserDefaults.roadout!.object(forKey: "eu.roadout.Roadout.userID") as! String
            Task {
                do {
                    try await UserManager.sharedInstance.updatePasswordAsync(id, oldPswField.text!, newPswField.text!)
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Success".localized(), message: "Your password is now changed".localized(), preferredStyle: UIAlertController.Style.alert)
                        let alertAction = UIAlertAction(title: "OK".localized(), style: .default) { action in
                            UIView.animate(withDuration: 0.1) {
                                self.blurEffect.alpha = 0
                            } completion: { done in
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                        alertAction.setValue(UIColor.Roadout.brownish, forKey: "titleTextColor")
                        alert.addAction(alertAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                } catch let err {
                    self.manageServerSideErrors(err)
                }
            }
            
        } else {
            let alert = UIAlertController(title: "Error".localized(), message: "Please check all text fields".localized(), preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alertAction.setValue(UIColor.Roadout.redish, forKey: "titleTextColor")
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
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
        alert.view.tintColor = UIColor.Roadout.brownish
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

        saveBtn.layer.cornerRadius = 12
        saveBtn.setAttributedTitle(savedTitle, for: .normal)
        
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
        
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
        forgotBtn.setAttributedTitle(forgotTitle, for: .normal)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cardPanned))
        panRecognizer.delegate = self
        cardView.addGestureRecognizer(panRecognizer)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.alpha = 0.7
        } completion: { _ in
            self.oldPswField.becomeFirstResponder()
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
        let pswRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{6,}$"

        let pswPred = NSPredicate(format:"SELF MATCHES %@", pswRegEx)
        return pswPred.evaluate(with: newPswField.text)
    }
    
    func isValidReenter() -> Bool {
        return newPswField.text == confPswField.text
    }
    
    func manageServerSideErrors(_ error: Error) {
        switch error {
            case UserManager.UserDBErrors.wrongPassword:
                let alert = UIAlertController(title: "Verification Error".localized(), message: "Old password is incorrect.".localized(), preferredStyle: .alert)
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
                let alert = UIAlertController(title: "Network Error".localized(), message: "Please check you network connection".localized(), preferredStyle: .alert)
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
extension EditPasswordViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !saveBtn.bounds.contains(touch.location(in: saveBtn))
    }
}
