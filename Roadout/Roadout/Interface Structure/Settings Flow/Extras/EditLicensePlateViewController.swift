//
//  EditLicensePlateViewController.swift
//  Roadout
//
//  Created by David Retegan on 12.11.2022.
//

import UIKit

class EditLicensePlateViewController: UIViewController {
    
    let changeTitle = NSAttributedString(string: "Save".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let removeTitle = NSAttributedString(string: "Remove".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var plateView: UIView!
    @IBOutlet weak var plateText: UILabel!
    
    @IBOutlet weak var changeBtn: UXButton!
    @IBAction func changeTapped(_ sender: Any) {
        if plateField.text != "" {
            do {
                userLicensePlate = try plateField.text?.formatLicensePlate() ?? "NO-PLATE"
                UserDefaults.roadout!.set(userLicensePlate, forKey: "ro.roadout.Roadout.userLicensePlate")
                UIView.animate(withDuration: 0.1) {
                    self.blurEffect.alpha = 0
                } completion: { done in
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: .reloadLicensePlateID, object: nil)
                }
            } catch {
                let alert = UIAlertController(title: "Error".localized(), message: "Please enter a valid license plate".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")!
                self.present(alert, animated: true)
            }
        } else {
            userLicensePlate = "NO-PLATE"
            UserDefaults.roadout!.set(userLicensePlate, forKey: "ro.roadout.Roadout.userLicensePlate")
            UIView.animate(withDuration: 0.1) {
                self.blurEffect.alpha = 0
            } completion: { done in
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .reloadLicensePlateID, object: nil)
            }
        }
    }

    @IBOutlet weak var plateField: PaddedTextField!
    
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
    
    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 20.0
        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addShadowToCardView()

        changeBtn.layer.cornerRadius = 13.0
        if plateField.text == "" {
            changeBtn.setAttributedTitle(removeTitle, for: .normal)
        } else {
            changeBtn.setAttributedTitle(changeTitle, for: .normal)
        }
        
        plateField.layer.cornerRadius = 12.0
        plateField.attributedPlaceholder = NSAttributedString(
            string: "License Plate".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
        
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
        
        plateView.layer.cornerRadius = plateView.frame.height/4
        plateText.text = userLicensePlate
        plateField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.alpha = 0.7
        } completion: { _ in
            self.plateField.becomeFirstResponder()
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
}
extension EditLicensePlateViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == "" && self.changeBtn.titleLabel?.text != "Remove".localized() {
            self.changeBtn.setAttributedTitle(self.removeTitle, for: .normal)
        } else if textField.text != "" && self.changeBtn.titleLabel?.text != "Save".localized() {
            self.changeBtn.setAttributedTitle(self.changeTitle, for: .normal)
        }
    }
}
