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
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.shownTip7") == false {
            moreBtn.tooltip(TutorialView7.instanceFromNib(), orientation: Tooltip.Orientation.top, configuration: { configuration in
                configuration.backgroundColor = UIColor(named: "Card Background")!
                configuration.shadowConfiguration.shadowOpacity = 0.2
                configuration.shadowConfiguration.shadowColor = UIColor.black.cgColor
                configuration.shadowConfiguration.shadowOffset = .zero
                
                return configuration
            })
            UserDefaults.roadout!.set(true, forKey: "ro.roadout.Roadout.shownTip7")
        }
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
