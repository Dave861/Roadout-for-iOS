//
//  PaidView.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit

class PaidView: UIView {
    
    let buttonTitle = NSAttributedString(string: "See Reservation",
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Dark Orange")!])
    let showActiveBarID = "ro.codebranch.Roadout.showActiveBarID"
    
    @IBOutlet weak var seeBtn: UIButton!
    
    @IBAction func seeTapped(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(showActiveBarID), object: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 12.0
        seeBtn.setAttributedTitle(buttonTitle, for: .normal)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Bars", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
