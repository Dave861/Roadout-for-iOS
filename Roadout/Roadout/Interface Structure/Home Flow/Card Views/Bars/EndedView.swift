//
//  EndedView.swift
//  Roadout
//
//  Created by David Retegan on 28.03.2023.
//

import UIKit

class EndedView: UIView {
    
    let buttonTitle = NSAttributedString(string: "Done".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor.Roadout.icons])
    
    @IBOutlet weak var doneBtn: UXButton!
    
    @IBAction func doneTapped(_ sender: Any) {
        let rateAlert = UIAlertController(title: "Rate".localized(), message: "Would you like to rate your experience?".localized(), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes".localized(), style: .cancel) { _ in
            NotificationCenter.default.post(name: .showRateReservationID, object: nil)
         }
        let noAction = UIAlertAction(title: "No".localized(), style: .default) { _ in
            rateAlert.dismiss(animated: true, completion: nil)
         }
        rateAlert.addAction(noAction)
        rateAlert.addAction(yesAction)
        rateAlert.view.tintColor = UIColor.Roadout.mainYellow
         
        self.parentViewController().present(rateAlert, animated: true, completion: nil)
        NotificationCenter.default.post(name: .returnToSearchBarID, object: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 17.0
        doneBtn.setAttributedTitle(buttonTitle, for: .normal)
        doneBtn.layer.cornerRadius = 14.0
        reservationTime = 0
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Bars", bundle: nil).instantiate(withOwner: nil, options: nil)[3] as! UIView
    }

}
