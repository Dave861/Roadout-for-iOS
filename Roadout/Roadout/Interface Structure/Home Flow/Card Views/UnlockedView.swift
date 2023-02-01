//
//  UnlockedView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit

class UnlockedView: UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var payBtn: UXButton!
    @IBOutlet weak var payView: UIView!
    @IBOutlet weak var payLbl: UILabel!
    
    @IBOutlet weak var markLbl: UILabel!
    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var markBtn: UXButton!
    
    @IBAction func payTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        isPayFlow = false
        selectedPayLocation = getLocationWith(name: EntityManager.sharedInstance.decodeSpotID(selectedSpot.rID)[0])
        NotificationCenter.default.post(name: .addPayDurationCardID, object: nil)
    }
    
    @IBAction func markTapped(_ sender: Any) {
        //Make sure spot hash is ok
        UserDefaults.roadout!.setValue(selectedSpot.rHash, forKey: "ro.roadout.Roadout.carParkHash")
        carParkHash = selectedSpot.rHash
        NotificationCenter.default.post(name: .refreshMarkedSpotID, object: nil)
        
        markLbl.text = "Marked".localized()
        markBtn.isEnabled = false
        let alert = UIAlertController(title: "Spot Marked".localized(), message: "Your car location has been marked, you can return later and find it in Roadout".localized(), preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "DevBrown")!
        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel)
        alert.addAction(okAction)
        self.parentViewController().present(alert, animated: true)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        //API call for continuity when app is opened again (to prevent showing unlocked view and mark reservation as done)
        Task {
            do {
                try await ReservationManager.sharedInstance.checkForReservationAsync(date: Date(), userID: id)
            } catch let err {
                print(err)
            }
        }
        let rateAlert = UIAlertController(title: "Rate".localized(), message: "Would you like to rate your experience?".localized(), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes".localized(), style: .cancel) { _ in
            NotificationCenter.default.post(name: .showRateReservationID, object: nil)
         }
        let noAction = UIAlertAction(title: "No".localized(), style: .default) { _ in
            rateAlert.dismiss(animated: true, completion: nil)
         }
        rateAlert.addAction(noAction)
        rateAlert.addAction(yesAction)
        rateAlert.view.tintColor = UIColor(named: "Main Yellow")
         
        self.parentViewController().present(rateAlert, animated: true, completion: nil)
        NotificationCenter.default.post(name: .returnToSearchBarID, object: nil)
    }
    
    func styleActionButtons() {
        payBtn.setTitle("", for: .normal)
        markBtn.setTitle("", for: .normal)
        
        payBtn.layer.cornerRadius = 9
        markBtn.layer.cornerRadius = 9
        
        payLbl.text = "Pay Parking".localized()
        if carParkHash == "roadout_carpark_clear" {
            markLbl.text = "Mark Spot".localized()
        } else {
            markLbl.text = "Marked".localized()
        }
    }
    
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        titleLbl.text = "Unlocked".localized()
        descriptionLbl.text = "Spot is now unlocked, pay parking right from here or mark the spot to find your car later.".localized()
                
        timerSeconds = 0
        
        styleActionButtons()
        doneBtn.layer.cornerRadius = doneBtn.frame.height/2
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[8] as! UIView
    }
    
    
    func getLocationWith(name: String) -> ParkLocation {
        var location: ParkLocation!
        
        for parkLocation in parkLocations {
            if parkLocation.name == name {
                location = parkLocation
                break
            }
        }
        
        return location
    }

}
