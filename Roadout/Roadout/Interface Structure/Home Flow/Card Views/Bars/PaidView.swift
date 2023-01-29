//
//  PaidView.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit

class PaidView: UIView {
    
    let buttonTitle = NSAttributedString(string: "See Reservation".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Dark Orange")!])
    
    @IBOutlet weak var seeBtn: UXButton!
    
    @IBAction func seeTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .showActiveBarID, object: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 17.0
        seeBtn.setAttributedTitle(buttonTitle, for: .normal)
        seeBtn.layer.cornerRadius = 14.0
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Bars", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
