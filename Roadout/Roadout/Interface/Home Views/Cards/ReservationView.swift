//
//  ReservationView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit

class ReservationView: UIView {
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeReservationCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var timerLbl: UILabel!
        
    @IBOutlet weak var unlockBtn: UIButton!
    @IBOutlet weak var directionsBtn: UIButton!
    @IBOutlet weak var delayBtn: UIButton!
    @IBOutlet weak var cancelBrn: UIButton!
    
    @IBAction func unlockTapped(_ sender: Any) {
        /*let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let alert = UIAlertController(title: "Unlock".localized(), message: "This cannot be undone, you are about to unlock the spot and end the reservation. Are you sure?".localized(), preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "Brownish")
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        let proceedAction = UIAlertAction(title: "Yes".localized(), style: .destructive) { action in
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            NotificationHelper.sharedInstance.cancelReservationNotification()
            NotificationCenter.default.post(name: .showUnlockedBarID, object: nil)
        }
        alert.addAction(proceedAction)
        alert.addAction(cancelAction)
        self.parentViewController().present(alert, animated: true, completion: nil)*/
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .addUnlockCardID, object: nil)
    }
    
    @IBAction func directionsTapped(_ sender: Any) {
        var link: String
        switch UserPrefsUtils.sharedInstance.returnPrefferedMapsApp() {
        case "Google Maps":
            link = "https://www.google.com/maps/search/?api=1&query=46.565645,32.65565"
        case "Waze":
            link = "https://www.waze.com/ul?ll=46.565645%2C-32.65565&navigate=yes&zoom=15"
        default:
            link = "http://maps.apple.com/?ll=46.565645,32.65565&q=Parking%20Location"
        }
        guard UIApplication.shared.canOpenURL(URL(string: link)!) else { return }
        UIApplication.shared.open(URL(string: link)!)
    }
    
    @IBAction func delayTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .addDelayCardID, object: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let alert = UIAlertController(title: "Cancel".localized(), message: "Are you sure you want to cancel your reservation? You will only get money back for the unused minutes.".localized(), preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "Redish")
        let cancelAction = UIAlertAction(title: "No".localized(), style: .cancel, handler: nil)
        let proceedAction = UIAlertAction(title: "Yes".localized(), style: .destructive) { action in
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            NotificationHelper.sharedInstance.cancelReservationNotification()
            NotificationCenter.default.post(name: .showCancelledBarID, object: nil)
        }
        alert.addAction(proceedAction)
        alert.addAction(cancelAction)
        self.parentViewController().present(alert, animated: true, completion: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        backBtn.setTitle("", for: .normal)
        
        unlockBtn.setTitle("", for: .normal)
        directionsBtn.setTitle("", for: .normal)
        delayBtn.setTitle("", for: .normal)
        cancelBrn.setTitle("", for: .normal)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedDate = dateFormatter.string(from: ReservationManager.sharedInstance.getReservationDate())
        self.timerLbl.text = "Reserved for ".localized() + formattedDate
        self.timerLbl.set(textColor: UIColor.label, range: timerLbl.range(before: formattedDate))
    }

    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[5] as! UIView
    }

    
    
}

