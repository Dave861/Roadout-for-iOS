//
//  PayView.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit

class PayView: UIView {
    
    let removePayCardID = "ro.roadout.Roadout.removePayCardID"
    let showPaidBarID = "ro.roadout.Roadout.showPaidBarID"
    let removePayDelayCardID = "ro.roadout.Roadout.removePayDelayCardID"
    let showFindCardID = "ro.roadout.Roadout.showFindCardID"
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if returnToDelay {
            returnToDelay = false
            NotificationCenter.default.post(name: Notification.Name(removePayDelayCardID), object: nil)
        } else if returnToFind {
            returnToFind = false
            NotificationCenter.default.post(name: Notification.Name(showFindCardID), object: nil)
        } else {
            NotificationCenter.default.post(name: Notification.Name(removePayCardID), object: nil)
        }
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var applePayBtn: UIButton!
    @IBOutlet weak var mainCardBtn: UIButton!
    @IBOutlet weak var differentPaymentBtn: UIButton!
    
    @IBAction func paidApplePay(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if returnToFind {
            returnToFind = false
        }
        
        if returnToDelay {
            returnToDelay = false
            timerSeconds += delaySeconds
            ReservationManager.sharedInstance.manageDelay()
        }
        
        ReservationManager.sharedInstance.saveReservationDate(Date().addingTimeInterval(TimeInterval(timerSeconds)))
        ReservationManager.sharedInstance.saveActiveReservation(true)
        
        if UserPrefsUtils.sharedInstance.reservationNotificationsEnabled() {
            NotificationHelper.sharedInstance.scheduleReservationNotification()
        }
        NotificationCenter.default.post(name: Notification.Name(showPaidBarID), object: nil)
    }
    
    @IBAction func payMainCard(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if returnToFind {
            returnToFind = false
        }
        
        if returnToDelay {
            returnToDelay = false
            timerSeconds += delaySeconds
            ReservationManager.sharedInstance.manageDelay()
        }
        
        ReservationManager.sharedInstance.saveReservationDate(Date().addingTimeInterval(TimeInterval(timerSeconds)))
        ReservationManager.sharedInstance.saveActiveReservation(true)
        
        if UserPrefsUtils.sharedInstance.reservationNotificationsEnabled() {
            NotificationHelper.sharedInstance.scheduleReservationNotification()
        }
        NotificationCenter.default.post(name: Notification.Name(showPaidBarID), object: nil)
    }
    
    @IBAction func selectDifferentPayment(_ sender: Any) {
        let sb = UIStoryboard(name: "Settings", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentViewController
        self.parentViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    
    let applePayTitle = NSAttributedString(string: " Apple Pay", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .regular)])
    var mainCardTitle = NSAttributedString(string: "Pay with \(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let diffPaymentTitle = NSAttributedString(string: "Different Payment Method", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        backBtn.setTitle("", for: .normal)
        
        applePayBtn.layer.cornerRadius = 12.0
        applePayBtn.setAttributedTitle(applePayTitle, for: .normal)
        mainCardTitle = NSAttributedString(string: "Pay with \(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        mainCardBtn.layer.cornerRadius = 12.0
        mainCardBtn.setAttributedTitle(mainCardTitle, for: .normal)
        differentPaymentBtn.layer.cornerRadius = 12.0
        differentPaymentBtn.setAttributedTitle(diffPaymentTitle, for: .normal)
        
        priceLbl.set(textColor: UIColor(named: "Dark Orange")!, range: priceLbl.range(after: " - "))
        
        if returnToDelay {
            titleLbl.text = "Pay Delay"
        } else {
            titleLbl.text = "Pay Spot"
        }
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[4] as! UIView
    }

    func reloadMainCard() {
        print("HERE")
        mainCardTitle = NSAttributedString(string: "Pay with \(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        mainCardBtn.setAttributedTitle(mainCardTitle, for: .normal)
    }
    
    
}
