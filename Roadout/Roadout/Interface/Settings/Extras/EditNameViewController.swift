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
    
    @IBOutlet weak var nameLbl: UILabel!
    
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
        guard userNamelField.text != "" else { return }
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        UserManager.sharedInstance.updateName(id, userNamelField.text ?? "Name")
    }
    
    @objc func manageServerResponse() {
        switch UserManager.sharedInstance.callResult {
            case "Success":
                let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
                UserManager.sharedInstance.getUserName(id)
                nameLbl.text = UserManager.sharedInstance.userName
                let alert = UIAlertController(title: "Success", message: "Your name was successfully changed!", preferredStyle: UIAlertController.Style.alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default) { action in
                    UIView.animate(withDuration: 0.1) {
                        self.blurButton.alpha = 0
                    } completion: { done in
                        self.dismiss(animated: true, completion: nil)
                    }
                    NotificationCenter.default.post(name: .reloadUserNameID, object: nil)
                }
                alertAction.setValue(UIColor(named: "Main Yellow")!, forKey: "titleTextColor")
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
            case "error":
                let alert = UIAlertController(title: "Error", message: "There was an error with changing your name. Please try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "network error":
                let alert = UIAlertController(title: "Network Error", message: "Please check you network connection.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "database error":
                let alert = UIAlertController(title: "Internal Error", message: "There was an internal problem, please wait and try again a little later.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "unknown error":
                let alert = UIAlertController(title: "Unknown Error", message: "There was an error with the server respone, please screenshot this and send a bug report.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            case "error with json":
                let alert = UIAlertController(title: "JSON Error", message: "There was an error with the server respone, please screenshot this and send a bug report.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.view.tintColor = UIColor(named: "Redish")
                self.present(alert, animated: true, completion: nil)
            default:
                fatalError()
        }
    }
    
    let savedTitle = NSAttributedString(string: "Save", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    func addObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(manageServerResponse), name: .manageServerSideUpdateNameID, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObs()
        
        cardView.layer.cornerRadius = 16.0
        
        saved.layer.cornerRadius = 12
        saved.setAttributedTitle(savedTitle, for: .normal)
        
        userNamelField.layer.cornerRadius = 12.0
        userNamelField.attributedPlaceholder = NSAttributedString(
            string: "New Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Main Yellow")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        UserManager.sharedInstance.getUserName(id)
        nameLbl.text = UserManager.sharedInstance.userName
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.blurButton.alpha = 1
        }
    }

}
