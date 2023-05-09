//
//  UnlockedView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit
import GeohashKit

class UnlockedView: UXView {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var payBtn: UXButton!
    @IBOutlet weak var navigateBtn: UXButton!
    
    //MARK: - Actions -
    
    @IBAction func payTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    @IBAction func navigateTapped(_ sender: Any) {
        let hashComponents = selectedSpot.rHash.components(separatedBy: "-") //[hash, fNR, hNR, pNR]
        let lat = Geohash(geohash: hashComponents[0])!.coordinates.latitude
        let long = Geohash(geohash: hashComponents[0])!.coordinates.longitude
        
        self.openDirectionsToCoords(lat: lat, long: long)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        let id = UserDefaults.roadout!.object(forKey: "eu.roadout.Roadout.userID") as! String
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
        rateAlert.view.tintColor = UIColor.Roadout.mainYellow
         
        self.parentViewController().present(rateAlert, animated: true, completion: nil)
        NotificationCenter.default.post(name: .returnToSearchBarID, object: nil)
    }
    
    //MARK: - Swipe Gesture Configuration -
    
    override func viewSwipedBack() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        let id = UserDefaults.roadout!.object(forKey: "eu.roadout.Roadout.userID") as! String
        //API call for continuity when app is opened again (to prevent showing unlocked view and mark reservation as done in db)
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
        rateAlert.view.tintColor = UIColor.Roadout.mainYellow
         
        self.parentViewController().present(rateAlert, animated: true, completion: nil)
        NotificationCenter.default.post(name: .returnToSearchBarID, object: nil)
    }
    
    override func excludePansFrom(touch: UITouch) -> Bool {
        return !payBtn.bounds.contains(touch.location(in: payBtn)) && !navigateBtn.bounds.contains(touch.location(in: navigateBtn)) && !doneBtn.bounds.contains(touch.location(in: doneBtn))
    }
    
    func styleActionButtons() {
        payBtn.layer.cornerRadius = 12
        navigateBtn.layer.cornerRadius = 12
        
        payBtn.setAttributedTitle(NSAttributedString(string: "Pay Parking".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium)]), for: .normal)
        navigateBtn.setAttributedTitle(NSAttributedString(string: "Navigate".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium)]), for: .normal)
        
        if #available(iOS 15.0, *) {
            payBtn.configuration?.imagePlacement = .top
            navigateBtn.configuration?.imagePlacement = .top
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK: - View Configuration -
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if UserDefaults.roadout!.bool(forKey: "eu.roadout.Roadout.shownTip6") == false {
            doneBtn.tooltip(TutorialView6.instanceFromNib(), orientation: Tooltip.Orientation.top, configuration: { configuration in
                configuration.backgroundColor = UIColor(named: "Card Background")!
                configuration.shadowConfiguration.shadowOpacity = 0.2
                configuration.shadowConfiguration.shadowColor = UIColor.black.cgColor
                configuration.shadowConfiguration.shadowOffset = .zero
                
                return configuration
            })
            UserDefaults.roadout!.set(true, forKey: "eu.roadout.Roadout.shownTip6")
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        reservationTime = 0
        
        styleActionButtons()
        doneBtn.layer.cornerRadius = doneBtn.frame.height/2
        
        self.accentColor = UIColor.Roadout.brownish
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[8] as! UIView
    }

    
    func openDirectionsToCoords(lat: Double, long: Double) {
        var link: String
        switch UserPrefsUtils.sharedInstance.returnPrefferedMapsApp() {
        case "Google Maps":
            link = "https://www.google.com/maps/search/?api=1&query=\(lat),\(long)"
        case "Waze":
            link = "https://www.waze.com/ul?ll=\(lat)%2C-\(long)&navigate=yes&zoom=15"
        default:
            link = "https://maps.apple.com/?ll=\(lat),\(long)&q=Roadout%20Location"
        }
        guard UIApplication.shared.canOpenURL(URL(string: link)!) else { return }
        UIApplication.shared.open(URL(string: link)!)
    }

}
