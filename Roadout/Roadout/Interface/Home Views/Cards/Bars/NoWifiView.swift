//
//  NoWifiView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit

class NoWifiView: UIView {
    
    let buttonTitle = NSAttributedString(string: "Wifi Settings".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Greyish")!])

    @IBOutlet weak var settingsBtn: UIButton!
    
    @IBAction func settingsTapped(_ sender: Any) {
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 17.0
        settingsBtn.setAttributedTitle(buttonTitle, for: .normal)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Bars", bundle: nil).instantiate(withOwner: nil, options: nil)[4] as! UIView
    }

}
