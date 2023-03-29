//
//  DurationView.swift
//  Roadout
//
//  Created by David Retegan on 20.07.2022.
//

import UIKit

class DurationView: UIView {
    
    let continueTitle = NSAttributedString(string: "Continue".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        if isPayFlow {
            NotificationCenter.default.post(name: .returnToSearchBarID, object: nil)
        } else {
            NotificationCenter.default.post(name: .removePayDurationCardID, object: nil)
        }
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UXButton!
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        paidTime = Int(hourSlider.value)
        NotificationCenter.default.post(name: .addPayParkingCardID, object: nil)
    }
    
    @IBOutlet weak var hourSlider: UISlider!
    @IBAction func slided(_ sender: Any) {
        let roundedValue = round(hourSlider.value/1.0)*1.0
        hourSlider.value = roundedValue
        totalLbl.text = "\(Int(hourSlider.value)) " + "Hours ".localized() + "- \(Int(hourSlider.value)) RON"
        totalLbl.set(textColor: UIColor.Roadout.cashYellow, range: totalLbl.range(after: " - "))
        totalLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: totalLbl.range(after: " - "))
    }
    
    @IBOutlet weak var totalLbl: UILabel!
    
    //MARK: - View Configuration -
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        continueBtn.layer.cornerRadius = 12.0
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        
        
        totalLbl.set(textColor: UIColor.Roadout.cashYellow, range: totalLbl.range(after: " - "))
        totalLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: totalLbl.range(after: " - "))
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Pay", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
