//
//  ActiveView.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit

class ActiveView: UIView {
        
    @IBOutlet weak var timerLbl: UILabel!
    
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBAction func moreTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .addReservationCardID, object: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 12.0
        moreBtn.setTitle("", for: .normal)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.timerLbl.text = dateFormatter.string(from: ReservationManager.sharedInstance.getReservationDate())
    }
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Bars", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }

}
