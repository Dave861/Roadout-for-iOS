//
//  CancelledView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit

class CancelledView: UIView {
    
    let buttonTitle = NSAttributedString(string: "Done".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Redish")!])
    
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBAction func doneTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .returnToSearchBarID, object: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 12.0
        doneBtn.setAttributedTitle(buttonTitle, for: .normal)
        timerSeconds = 0
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Bars", bundle: nil).instantiate(withOwner: nil, options: nil)[3] as! UIView
    }

}
