//
//  ReserveView.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit

class ReserveView: UIView {
    
    let removeReserveCardID = "ro.roadout.Roadout.removeReserveCardID"
    let addPayCardID = "ro.roadout.Roadout.addPayCardID"

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: Notification.Name(removeReserveCardID), object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        timerSeconds = Int(minuteSlider.value*60)
        NotificationCenter.default.post(name: Notification.Name(addPayCardID), object: nil)
        
    }
    
    @IBOutlet weak var coordonatesLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var minuteSlider: UISlider!
    @IBAction func slided(_ sender: Any) {
        let roundedValue = round(minuteSlider.value/1.0)*1.0
        minuteSlider.value = roundedValue
        totalLbl.text = "\(Int(minuteSlider.value)) Minutes - \(Int(minuteSlider.value)) RON"
        totalLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: totalLbl.range(after: " - "))
    }
    
    @IBOutlet weak var totalLbl: UILabel!
    
    let continueTitle = NSAttributedString(string: "Continue", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        continueBtn.layer.cornerRadius = 12.0
        backBtn.setTitle("", for: .normal)
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        
        totalLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: totalLbl.range(after: " - "))
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[3] as! UIView
    }

}
