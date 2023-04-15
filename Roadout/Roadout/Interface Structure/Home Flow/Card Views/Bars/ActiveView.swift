//
//  ActiveView.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit

class ActiveView: UIView {
        
    @IBOutlet weak var timerLbl: UILabel!
    
    @IBOutlet weak var moreBtn: UXButton!
    
    @IBAction func moreTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .addReservationCardID, object: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.addObs()
        self.layer.cornerRadius = 17.0
        moreBtn.setTitle("", for: .normal)
        moreBtn.layer.cornerRadius = 14.0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.timerLbl.text = dateFormatter.string(from: ReservationManager.sharedInstance.reservationEndDate)
    }
    
    func addObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimeLbl), name: .updateReservationTimeLabelID, object: nil)
    }
    
    @objc func updateTimeLbl() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.timerLbl.text = dateFormatter.string(from: ReservationManager.sharedInstance.reservationEndDate)
    }
    
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Bars", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
