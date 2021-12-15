//
//  EditNameViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit

class EditNameViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurButton: UIButton!
    
    @IBOutlet weak var saved: UIButton!
    @IBOutlet weak var userNamelField: PaddedTextField!
    
    
    @IBAction func dismissTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.blurButton.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
          self.blurButton.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func savedTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Success", message: "Your name was successfully changed!", preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { action in
        
                UIView.animate(withDuration: 0.1) {
                    self.blurButton.alpha = 0
                } completion: { done in
                    self.dismiss(animated: true, completion: nil)
                }

        }
        alertAction.setValue(UIColor(named: "Main Yellow")!, forKey: "titleTextColor")
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    let savedTitle = NSAttributedString(string: "Save", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 16.0
        
        saved.layer.cornerRadius = 12
        saved.setAttributedTitle(savedTitle, for: .normal)
        
        userNamelField.layer.cornerRadius = 12.0
        userNamelField.attributedPlaceholder = NSAttributedString(
            string: "New Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Main Yellow")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.blurButton.alpha = 1
        }
    }

}
