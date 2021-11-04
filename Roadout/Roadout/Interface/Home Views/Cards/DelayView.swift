//
//  DelayView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit

var delaySeconds = 300

class DelayView: UIView {

    let removeDelayCardID = "ro.roadout.Roadout.removeDelayCardID"
    let addPayDelayCardID = "ro.roadout.Roadout.addPayDelayCardID"

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: Notification.Name(removeDelayCardID), object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        returnToDelay = true
        NotificationCenter.default.post(name: Notification.Name(addPayDelayCardID), object: nil)
        
    }
    
    @IBOutlet weak var minuteSlider: UISlider!
    @IBAction func slided(_ sender: Any) {
        let roundedValue = round(minuteSlider.value/1.0)*1.0
        minuteSlider.value = roundedValue
        delaySeconds = Int(roundedValue)*60
        priceLbl.text = "Charge - \(Int(minuteSlider.value)) RON"
        priceLbl.set(textColor: UIColor(named: "Dark Orange")!, range: priceLbl.range(after: " - "))
    }
    
    @IBOutlet weak var priceLbl: UILabel!
    
    let continueTitle = NSAttributedString(string: "Continue", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        continueBtn.layer.cornerRadius = 12.0
        backBtn.setTitle("", for: .normal)
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        
        priceLbl.set(textColor: UIColor(named: "Dark Orange")!, range: priceLbl.range(after: " - "))
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[6] as! UIView
    }
}

