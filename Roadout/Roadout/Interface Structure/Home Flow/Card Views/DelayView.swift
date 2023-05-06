//
//  DelayView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit

class DelayView: UXView {
    
    let continueTitle = NSAttributedString(string: "Continue".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeDelayCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: - Swipe Gesture Configuration -
    
    override func viewSwipedBack() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeDelayCardID, object: nil)
    }
    
    override func excludePansFrom(touch: UITouch) -> Bool {
        return !continueBtn.bounds.contains(touch.location(in: continueBtn)) && !backBtn.bounds.contains(touch.location(in: backBtn))
    }
    
    @IBOutlet weak var continueBtn: UXButton!
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        returnToDelay = true
        NotificationCenter.default.post(name: .addPayDelayCardID, object: nil)
        
    }
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBAction func slided(_ sender: Any) {
        if flowType == .reserve {
            let roundedValue = round(timeSlider.value/1.0)*1.0
            delayTime = Int(roundedValue)*60
            priceLbl.text = "\(Int(timeSlider.value))" + " Minute/s".localized() + " - \(Int(timeSlider.value)) RON"
            priceLbl.set(textColor: UIColor.Roadout.secondOrange, range: priceLbl.range(after: " - "))
            priceLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: priceLbl.range(after: " - "))
        } else {
            let roundedValue = round(timeSlider.value/1.0)*1.0
            parkingDelayTime = Int(roundedValue)
            priceLbl.text = "\(Int(timeSlider.value))" + " Hour/s".localized() + " - \(Int(timeSlider.value)) RON"
            priceLbl.set(textColor: UIColor.Roadout.secondOrange, range: priceLbl.range(after: " - "))
            priceLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: priceLbl.range(after: " - "))
        }
    }
    
    @IBOutlet weak var priceLbl: UILabel!
    
    //MARK: - View Configuration -
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        continueBtn.layer.cornerRadius = 12.0
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        
        priceLbl.set(textColor: UIColor.Roadout.secondOrange, range: priceLbl.range(after: " - "))
        priceLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: priceLbl.range(after: " - "))
        
        setUpFlow()
        
        self.accentColor = UIColor.Roadout.secondOrange
    }
    
    func setUpFlow() {
        if flowType == .reserve {
            timeSlider.minimumValue = 1.0
            timeSlider.maximumValue = 10.0
            timeSlider.minimumValueImage = UIImage(systemName: "1.circle.fill")
            timeSlider.maximumValueImage = UIImage(systemName: "10.circle.fill")
            
            let roundedValue = round(timeSlider.value/1.0)*1.0
            delayTime = Int(roundedValue)*60
            priceLbl.text = "\(Int(timeSlider.value))" + " Minute/s".localized() + " - \(Int(timeSlider.value)) RON"
            priceLbl.set(textColor: UIColor.Roadout.secondOrange, range: priceLbl.range(after: " - "))
            priceLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: priceLbl.range(after: " - "))
        } else if flowType == .pay {
            timeSlider.minimumValue = 1.0
            timeSlider.maximumValue = 4.0
            timeSlider.minimumValueImage = UIImage(systemName: "1.circle.fill")
            timeSlider.maximumValueImage = UIImage(systemName: "4.circle.fill")
            
            let roundedValue = round(timeSlider.value/1.0)*1.0
            parkingDelayTime = Int(roundedValue)
            priceLbl.text = "\(Int(timeSlider.value))" + " Hour/s".localized() + " - \(Int(timeSlider.value)) RON"
            priceLbl.set(textColor: UIColor.Roadout.secondOrange, range: priceLbl.range(after: " - "))
            priceLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: priceLbl.range(after: " - "))
        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[6] as! UIView
    }
}

