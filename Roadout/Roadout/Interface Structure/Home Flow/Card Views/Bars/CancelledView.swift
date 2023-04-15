//
//  CancelledView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit

class CancelledView: UIView {
    
    let buttonTitle = NSAttributedString(string: "Done".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor.Roadout.redish])
    
    @IBOutlet weak var doneBtn: UXButton!
    
    @IBAction func doneTapped(_ sender: Any) {
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        //API call for continuity when app is opened again (to prevent showing unlocked view and mark reservation as done)
        Task {
            do {
                try await ReservationManager.sharedInstance.checkForReservationAsync(date: Date(), userID: id)
            } catch let err {
                print(err)
            }
        }
        NotificationCenter.default.post(name: .returnToSearchBarID, object: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 17.0
        doneBtn.setAttributedTitle(buttonTitle, for: .normal)
        doneBtn.layer.cornerRadius = 14.0
        reservationTime = 0
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Bars", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }

}
