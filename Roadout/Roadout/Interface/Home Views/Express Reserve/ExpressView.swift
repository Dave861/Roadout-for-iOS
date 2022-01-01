//
//  ExpressView.swift
//  Roadout
//
//  Created by David Retegan on 07.11.2021.
//

import UIKit

class ExpressView: UIView {
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var chargeLbl: UILabel!
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeExpressViewID, object: nil)
    }
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func sliderChangedValue(_ sender: Any) {
        let roundedValue = round(slider.value/1.0)*1.0
        slider.value = roundedValue
        chargeLbl.text = "\(Int(slider.value)) Minutes - \(Int(slider.value)) RON"
        chargeLbl.set(textColor: UIColor(named: "Dark Orange")!, range: chargeLbl.range(after: " - "))
    }
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var spotSectionLbl: UILabel!
    
    @IBOutlet weak var applePayBtn: UIButton!
    @IBOutlet weak var mainCardBtn: UIButton!
    
    @IBAction func paidApplePay(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        timerSeconds = Int(slider.value*60)
        ReservationManager.sharedInstance.saveReservationDate(Date().addingTimeInterval(TimeInterval(timerSeconds)))
        ReservationManager.sharedInstance.saveActiveReservation(true)
        
        if UserPrefsUtils.sharedInstance.reservationNotificationsEnabled() {
            NotificationHelper.sharedInstance.scheduleReservationNotification()
        }
        NotificationCenter.default.post(name: .showPaidBarID, object: nil)
    }
    
    @IBAction func payMainCard(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        timerSeconds = Int(slider.value*60)
        ReservationManager.sharedInstance.saveReservationDate(Date().addingTimeInterval(TimeInterval(timerSeconds)))
        ReservationManager.sharedInstance.saveActiveReservation(true)
        
        if UserPrefsUtils.sharedInstance.reservationNotificationsEnabled() {
            NotificationHelper.sharedInstance.scheduleReservationNotification()
        }
        NotificationCenter.default.post(name: .showPaidBarID, object: nil)
    }
    
    let applePayTitle = NSAttributedString(string: " Apple Pay", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .regular)])
    var mainCardTitle = NSAttributedString(string: "Pay with \(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        backBtn.setTitle("", for: .normal)
        
        applePayBtn.layer.cornerRadius = 12.0
        applePayBtn.setAttributedTitle(applePayTitle, for: .normal)
        mainCardTitle = NSAttributedString(string: "Pay with \(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        mainCardBtn.layer.cornerRadius = 12.0
        mainCardBtn.setAttributedTitle(mainCardTitle, for: .normal)
        
        chargeLbl.set(textColor: UIColor(named: "ExpressFocus")!, range: chargeLbl.range(after: " - "))
        
        locationLbl.text = selectedLocation
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Express", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }

}
