//
//  UnlockView.swift
//  Roadout
//
//  Created by David Retegan on 20.03.2022.
//

import UIKit

class UnlockView: UIView {

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeUnlockCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var slidingBtn: SlidingButton!
    @IBOutlet weak var explainerLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        
        slidingBtn.reset()
        slidingBtn.delegate = self
        
        explainerLbl.text = "Unlocking the spot cannot be undone. Once unlocked anyone can park on the spot, make sure you are at the spot before unlocking it.".localized()
        titleLbl.text = "Unlock Spot".localized()
        
        explainerLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: explainerLbl.range(string: "Unlocking ".localized()))
        explainerLbl.set(font: .systemFont(ofSize: 16.0, weight: .medium), range: explainerLbl.range(string: "Unlocking ".localized()))
        explainerLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: explainerLbl.range(string: " cannot".localized()))
        explainerLbl.set(font: .systemFont(ofSize: 16.0, weight: .medium), range: explainerLbl.range(string: " cannot".localized()))
        explainerLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: explainerLbl.range(string: " anyone".localized()))
        explainerLbl.set(font: .systemFont(ofSize: 16.0, weight: .medium), range: explainerLbl.range(string: " anyone".localized()))
        explainerLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: explainerLbl.range(string: "before ".localized()))
        explainerLbl.set(font: .systemFont(ofSize: 16.0, weight: .medium), range: explainerLbl.range(string: "before ".localized()))
        
       
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[7] as! UIView
    }

}
extension UnlockView: SlideButtonDelegate {
    func buttonStatus(status: String, sender: SlidingButton) {
        print(status)
        if status == "Unlocked" {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            NotificationHelper.sharedInstance.cancelReservationNotification()
            NotificationCenter.default.post(name: .showUnlockedBarID, object: nil)
        }
    }
}
