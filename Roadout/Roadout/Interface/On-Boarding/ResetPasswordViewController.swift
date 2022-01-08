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
        
    }
    
    let continueTitle = NSAttributedString(string: "Reset", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let skipTitle = NSAttributedString(
        string: "Cancel",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
    )
        
    override func viewDidLoad() {
        super.viewDidLoad()
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
    

}
