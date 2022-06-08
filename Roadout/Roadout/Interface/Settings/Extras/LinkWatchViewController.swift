//
//  LinkWatchViewController.swift
//  Roadout
//
//  Created by David Retegan on 28.05.2022.
//

import UIKit
import WatchConnectivity

class LinkWatchViewController: UIViewController {
        
    let connectTitle = NSAttributedString(string: "Connect".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
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
    
    @IBOutlet weak var connectBtn: UIButton!
    
    @IBAction func connectTapped(_ sender: Any) {
        if WCSession.default.isReachable {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            statusLbl.text = "Connecting..."
            
            let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
            let userName = UserManager.sharedInstance.userName
            let dataToSend: [String : Any] = ["userID" : id, "userName" : userName]
            WCSession.default.sendMessage(dataToSend, replyHandler: nil) { err in
                print(err)
            }
            
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLbl: UILabel!
    
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissAfterSuccess), name: .dismissWatchConnectCardID, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 19.0
        connectBtn.layer.cornerRadius = 12
        connectBtn.setAttributedTitle(connectTitle, for: .normal)
        activityIndicator.isHidden = true
        
        checkWatchSession()
        manageObs()
    
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.alpha = 1
        }
    }
    
    func checkWatchSession() {
        if !WCSession.isSupported() {
            self.connectBtn.alpha = 0.75
            self.connectBtn.isEnabled = false
            self.activityIndicator.isHidden = false
            self.statusLbl.text = "No Apple Watch found"
        }
    }
    
    @objc func dismissAfterSuccess() {
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            self.activityIndicator.stopAnimating()
            self.statusLbl.text = "Success"
            UIView.animate(withDuration: 0.1) {
              self.blurEffect.alpha = 0
            } completion: { done in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

