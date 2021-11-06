//
//  EditPasswordViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit

class EditPasswordViewController: UIViewController {

    let savedTitle = NSAttributedString(string: "Save", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurButton: UIButton!
    
    
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var oldPswField: PaddedTextField!
    @IBOutlet weak var newPswField: PaddedTextField!
    @IBOutlet weak var confPswField: PaddedTextField!
    
    @IBAction func dismissTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.blurButton.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
          self.blurButton.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.blurButton.alpha = 1
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Success", message: "Your password was successfully changed!", preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { action in
        
                UIView.animate(withDuration: 0.1) {
                    self.blurButton.alpha = 0
                } completion: { done in
                    self.dismiss(animated: true, completion: nil)
                }

        }
        alertAction.setValue(UIColor(named: "Brownish")!, forKey: "titleTextColor")
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 13.0
        
        save.layer.cornerRadius = 12
        save.setAttributedTitle(savedTitle, for: .normal)
        
        oldPswField.layer.cornerRadius = 12.0
        oldPswField.attributedPlaceholder =
         NSAttributedString(
         string: "Old Password",
         attributes:
            [NSAttributedString.Key.foregroundColor: UIColor(named: "Greyish")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
         )
        newPswField.layer.cornerRadius = 12.0
        newPswField.attributedPlaceholder =
         NSAttributedString(
         string: "New Password",
         attributes:
            [NSAttributedString.Key.foregroundColor: UIColor(named: "Brownish")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
         )
        confPswField.layer.cornerRadius = 12.0
        confPswField.attributedPlaceholder =
         NSAttributedString(
         string: "Confirm Password",
         attributes:
            [NSAttributedString.Key.foregroundColor: UIColor(named: "Dark Yellow")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
         )
        
        
    }
    

}
