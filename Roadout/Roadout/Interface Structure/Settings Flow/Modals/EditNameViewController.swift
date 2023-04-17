//
//  EditNameViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit

class EditNameViewController: UIViewController {
    
    let savedTitle = NSAttributedString(string: "Save".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    private var initialCenter: CGPoint = .zero

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var saveBtn: UXButton!
    @IBOutlet weak var userNameField: PaddedTextField!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @objc func blurTapped() {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
          self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func savedTapped(_ sender: Any) {
        guard userNameField.text != "" else { return }
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        Task {
            do {
                try await UserManager.sharedInstance.updateNameAsync(id, userNameField.text!)
                UserDefaults.roadout!.set(userNameField.text!, forKey: "ro.roadout.Roadout.UserName")
                DispatchQueue.main.async {
                    self.nameLbl.text = UserManager.sharedInstance.userName
                    NotificationCenter.default.post(name: .reloadUserNameID, object: nil)
                    UIView.animate(withDuration: 0.1) {
                        self.blurEffect.alpha = 0
                    } completion: { done in
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } catch let err {
                self.manageServerResponseErrors(err)
            }
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
        
        userNameField.layer.cornerRadius = 12.0
        userNameField.attributedPlaceholder = NSAttributedString(
            string: "New Name".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        Task {
            do {
                try await UserManager.sharedInstance.getUserNameAsync(id)
                DispatchQueue.main.async {
                    self.nameLbl.text = UserManager.sharedInstance.userName
                }
            } catch let err {
                print(err)
            }
        }
        nameLbl.text = UserManager.sharedInstance.userName //if network call fails
        
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
                
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cardPanned))
        panRecognizer.delegate = self
        cardView.addGestureRecognizer(panRecognizer)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.alpha = 0.7
        } completion: { _ in
            self.userNameField.becomeFirstResponder()
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

    func manageServerResponseErrors(_ error: Error) {
        switch error {
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
            let alert = UIAlertController(title: "Error".localized(), message: "There was an error with changing your name. Please try again.".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor.Roadout.redish
            self.present(alert, animated: true, completion: nil)
        }
    }
}
extension EditNameViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !saveBtn.bounds.contains(touch.location(in: saveBtn))
    }
}
