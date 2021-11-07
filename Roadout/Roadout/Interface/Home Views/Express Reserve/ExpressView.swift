//
//  ExpressView.swift
//  Roadout
//
//  Created by David Retegan on 07.11.2021.
//

import UIKit

class ExpressView: UIView {
    
    let removeExpressViewID = "ro.roadout.Roadout.removeExpressViewID"
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var chargeLbl: UILabel!
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: Notification.Name(removeExpressViewID), object: nil)
    }
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func sliderChangedValue(_ sender: Any) {
        let roundedValue = round(slider.value/1.0)*1.0
        slider.value = roundedValue
        chargeLbl.text = "Charge - \(Int(slider.value)) RON"
        chargeLbl.set(textColor: UIColor(named: "Dark Orange")!, range: chargeLbl.range(after: " - "))
    }
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var spotSectionLbl: UILabel!
    
    @IBOutlet weak var applePayBtn: UIButton!
    @IBOutlet weak var mainCardBtn: UIButton!
    @IBOutlet weak var differentPaymentBtn: UIButton!
    
    @IBAction func paidApplePay(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
    }
    
    @IBAction func payMainCard(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
    }
    
    @IBAction func selectDifferentPayment(_ sender: Any) {
    }
    
    
    let applePayTitle = NSAttributedString(string: "Pay with Apple Pay", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
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
        
        chargeLbl.set(textColor: UIColor(named: "Dark Orange")!, range: chargeLbl.range(after: " - "))
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Express", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }

}
