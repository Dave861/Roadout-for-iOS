//
//  DelayView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit

class DelayView: UIView {

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeDelayCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        returnToDelay = true
        NotificationCenter.default.post(name: .addPayDelayCardID, object: nil)
        
    }
    
    @IBOutlet weak var minuteSlider: UISlider!
    @IBAction func slided(_ sender: Any) {
        let roundedValue = round(minuteSlider.value/1.0)*1.0
        minuteSlider.value = roundedValue
        delaySeconds = Int(roundedValue)*60
        priceLbl.text = "Charge".localized() + " - \(Int(minuteSlider.value)) RON"
        priceLbl.set(textColor: UIColor(named: "Second Orange")!, range: priceLbl.range(after: " - "))
        priceLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: priceLbl.range(after: " - "))
    }
    
    @IBOutlet weak var priceLbl: UILabel!
    
    let continueTitle = NSAttributedString(string: "Continue".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        continueBtn.layer.cornerRadius = 12.0
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        
        priceLbl.set(textColor: UIColor(named: "Second Orange")!, range: priceLbl.range(after: " - "))
        priceLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: priceLbl.range(after: " - "))
        
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[6] as! UIView
    }
}

