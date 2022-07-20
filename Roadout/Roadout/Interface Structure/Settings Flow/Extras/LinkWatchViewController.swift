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
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
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
            statusLbl.text = "Connecting...".localized()
            
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
    
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    func addShadowToCardView() {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 20.0
        cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
        cardView.layer.shouldRasterize = true
        cardView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 20.0
        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addShadowToCardView()

        connectBtn.layer.cornerRadius = 12
        connectBtn.setAttributedTitle(connectTitle, for: .normal)
        activityIndicator.isHidden = true
        
        checkWatchSession()
        manageObs()
    
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
        
        statusLbl.text = "Tap to connect".localized()
        titleLbl.text = "Link Apple Watch".localized()
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.alpha = 0.7
        }
    }
    
    func checkWatchSession() {
        if !WCSession.isSupported() {
            self.connectBtn.alpha = 0.75
            self.connectBtn.isEnabled = false
            self.activityIndicator.isHidden = false
            self.statusLbl.text = "No Apple Watch found".localized()
        }
    }
    
    @objc func dismissAfterSuccess() {
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            self.activityIndicator.stopAnimating()
            self.statusLbl.text = "Success".localized()
            UIView.animate(withDuration: 0.1) {
              self.blurEffect.alpha = 0
            } completion: { done in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

