//
//  UXAlertController.swift
//  Roadout
//
//  Created by David Retegan on 23.10.2022.
//

import Foundation
import UIKit

protocol UXAlertControllerDelegate: AnyObject {
    func primaryActionTapped(_ alert: UXAlertController, alertTag: Int)
    func secondaryActionTapped(_ alert: UXAlertController, alertTag: Int)
}

class UXAlertController: UIViewController {
    
    var alertTag = 0 //Manages multiple alerts in one vc
    
    var alertTitle: String?
    var alertMessage: String?
    var alertImage: String?
    var alertTintColor: UIColor?
    
    var alertPrimaryActionTitle: String?
    var alertSecondaryActionTitle: String?
        
    var isSecondaryActionHidden: Bool?
    
    weak var delegate: UXAlertControllerDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var spacerView: UIView!
    @IBOutlet weak var secondaryButton: UIButton!
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertCardView: UIView!
    
    @IBAction func primaryButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.view.backgroundColor = UIColor.clear
        } completion: { _ in
            self.dismiss(animated: true)
        }
        delegate?.primaryActionTapped(self, alertTag: alertTag)
    }
    
    @IBAction func secondaryButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.view.backgroundColor = UIColor.clear
        } completion: { _ in
            self.dismiss(animated: true)
        }
        delegate?.secondaryActionTapped(self, alertTag: alertTag)
    }
    
        
    init(alertTag: Int, alertTitle: String, alertMessage: String, alertImage: String, alertTintColor: UIColor, alertPrimaryActionTitle: String, isSecondaryActionHidden: Bool, alertSecondaryActionTitle: String) {
        super.init(nibName: "UXAlertController", bundle: nil)
        
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
        
        self.alertTag = alertTag
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.alertImage = alertImage
        self.alertTintColor = alertTintColor
        self.alertPrimaryActionTitle = alertPrimaryActionTitle
        self.isSecondaryActionHidden = isSecondaryActionHidden
        self.alertSecondaryActionTitle = alertSecondaryActionTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUXAlert()
        primaryButton.layer.cornerRadius = primaryButton.frame.height/4
        if UIDevice.current.hasNotch {
            alertCardView.layer.cornerRadius = 36.0
        } else {
            alertCardView.layer.cornerRadius = 15.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor(named: "Blur")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.view.backgroundColor = UIColor.clear
        }
    }
    
    func setUpUXAlert() {
        self.titleLabel.text = alertTitle
        self.messageLabel.text = alertMessage
        self.alertImageView.image = UIImage(named: alertImage ?? "")
        self.alertImageView.tintColor = alertTintColor
        
        self.primaryButton.setAttributedTitle(NSAttributedString(string: self.alertPrimaryActionTitle ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium), NSAttributedString.Key.foregroundColor: self.alertTintColor ?? UIColor.systemYellow]), for: .normal)
        
        if isSecondaryActionHidden ?? false {
            self.secondaryButton.isHidden = true
            self.spacerView.isHidden = false
        } else {
            self.secondaryButton.isHidden = false
            self.spacerView.isHidden = true
            self.secondaryButton.setAttributedTitle(NSAttributedString(string: self.alertSecondaryActionTitle ?? "", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium), NSAttributedString.Key.foregroundColor: self.alertTintColor ?? UIColor.systemYellow]), for: .normal)
        }
                
    }
    
    
    
    
}
