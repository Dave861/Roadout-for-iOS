//
//  ActiveView.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit

class ActiveView: UIView {
    
    var secondsRemaining = 300
    
    @IBOutlet weak var timerLbl: UILabel!
    
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBAction func moreTapped(_ sender: Any) {
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 12.0
        moreBtn.setTitle("", for: .normal)
        let seconds = self.secondsRemaining - (self.secondsRemaining/60)*60
        if seconds < 10 {
            self.timerLbl.text = "\(self.secondsRemaining/60):0\(seconds)"
        } else {
            self.timerLbl.text = "\(self.secondsRemaining/60):\(seconds)"
        }
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                if self.secondsRemaining > 0 {
                    let seconds = self.secondsRemaining - (self.secondsRemaining/60)*60
                    if seconds < 10 {
                        self.timerLbl.text = "\(self.secondsRemaining/60):0\(seconds)"
                    } else {
                        self.timerLbl.text = "\(self.secondsRemaining/60):\(seconds)"
                    }
                    self.secondsRemaining -= 1
                } else {
                    self.timerLbl.text = "00:00"
                    Timer.invalidate()
                }
        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Bars", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }

}
