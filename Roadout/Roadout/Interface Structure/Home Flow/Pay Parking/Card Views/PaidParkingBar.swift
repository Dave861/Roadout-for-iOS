//
//  PaidParkingBar.swift
//  Roadout
//
//  Created by David Retegan on 20.07.2022.
//

import UIKit

class PaidParkingBar: UIView {

    let buttonTitle = NSAttributedString(string: "Done".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Cash Yellow")!])
    
    @IBOutlet weak var optionsBtn: UIButton!
    
    @IBAction func optionsTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .returnToSearchBarID, object: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 17.0
        optionsBtn.setAttributedTitle(buttonTitle, for: .normal)
        optionsBtn.layer.cornerRadius = 15.0
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Pay", bundle: nil).instantiate(withOwner: nil, options: nil)[2] as! UIView
    }
}
