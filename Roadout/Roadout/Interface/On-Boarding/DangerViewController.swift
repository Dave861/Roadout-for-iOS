//
//  DangerViewController.swift
//  Roadout
//
//  Created by David Retegan on 23.04.2022.
//

import UIKit
import IOSSecuritySuite

class DangerViewController: UIViewController {
    
    let titles = ["Jailbreak".localized(), "Reverse Engineering".localized(), "Proxy".localized()]
    let descriptions = ["Your device may be jailbroken or has been tampered with.".localized(), "You may have tried to reverse engineer our app or see the source code.".localized(), "You or someone else on your network may have tried to proxy our API calls.".localized()]

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var jailbreakLbl: UILabel!
    @IBOutlet weak var reverseEngLbl: UILabel!
    @IBOutlet weak var proxyLbl: UILabel!
    
    @IBOutlet weak var jailbreakDescriptionLbl: UILabel!
    @IBOutlet weak var reverseEngDescriptionLbl: UILabel!
    @IBOutlet weak var proxyDescriptionLbl: UILabel!
    
    @IBOutlet weak var questionBtn: UIButton!
    @IBAction func questionTapped(_ sender: Any) {
        if IOSSecuritySuite.amIJailbroken() {
            self.showAlert(title: "Jailbreak".localized(), message: "If your device is jailbroken you can look online for guides on how to remove the jailbreak or unwanted device tweaks. Reopen the app after that.".localized())
        }
        if IOSSecuritySuite.amIReverseEngineered() {
            self.showAlert(title: "Reverse Engineering".localized(), message: "Stop trying to reverse engineer the app, force quit and reopen.".localized())
        }
        if IOSSecuritySuite.amIProxied() {
            self.showAlert(title: "Proxy".localized(), message: "Try changing Wi-Fi networks or look into the router settings to see what is tampering with the app, then restart.".localized())
        }
        if !IOSSecuritySuite.amIJailbroken() && !IOSSecuritySuite.amIReverseEngineered() && !IOSSecuritySuite.amIProxied() {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    let questionTitle = NSAttributedString(string: "What can I do?".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "Threat Detected".localized()
        questionBtn.layer.cornerRadius = 13.0
        descriptionLbl.text = "Please STOP, Roadout has detected one of the following threats".localized()
        descriptionLbl.set(textColor: UIColor(named: "Redish")!, range: descriptionLbl.range(after: " ", before: ","))
        descriptionLbl.set(font: .systemFont(ofSize: 17.0, weight: .medium), range: descriptionLbl.range(after: " ", before: ","))
        questionBtn.setAttributedTitle(questionTitle, for: .normal)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "Redish")!
        let action = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
