//
//  ResultView.swift
//  Roadout
//
//  Created by David Retegan on 30.10.2021.
//

import UIKit
import CoreLocation

class ResultView: UXView {
    
    let parkTitle = NSAttributedString(string: "Park".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let reserveTitle = NSAttributedString(string: "Reserve".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    @IBOutlet weak var tipSourceView: UIView!
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var freeSpotsLbl: UILabel!
    
    @IBOutlet weak var distanceIcon: UIImageView!
    @IBOutlet weak var spotsIcon: UIImageView!
    @IBOutlet weak var priceIcon: UIImageView!
    
    @IBOutlet weak var reserveBtn: UXButton!
    @IBAction func reserveTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let homeVC = self.parentViewController() as! HomeViewController
        homeVC.isTipHidden = true
        flowType = .reserve
        Task.detached {
            do {
                try await self.downloadSpots()
            } catch let err {
                print(err)
            }
        }
        NotificationCenter.default.post(name: .addSectionCardID, object: nil)
    }
    
    @IBOutlet weak var payBtn: UXButton!
    @IBAction func payTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let homeVC = self.parentViewController() as! HomeViewController
        homeVC.isTipHidden = true
        flowType = .pay
        //Task determine nearest spot
        NotificationCenter.default.post(name: .addTimeCardID, object: nil)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        let homeVC = self.parentViewController() as! HomeViewController
        homeVC.isTipHidden = true
        NotificationCenter.default.post(name: .removeResultCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: - Swipe Gesture Configuration -
    
    override func viewSwipedBack() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        let homeVC = self.parentViewController() as! HomeViewController
        homeVC.isTipHidden = true
        NotificationCenter.default.post(name: .removeResultCardID, object: nil)
    }
    
    override func excludePansFrom(touch: UITouch) -> Bool {
        return !reserveBtn.bounds.contains(touch.location(in: reserveBtn)) && !payBtn.bounds.contains(touch.location(in: payBtn)) && !backBtn.bounds.contains(touch.location(in: backBtn))
    }
    
    //MARK: - View Confiuration -
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if UserDefaults.roadout!.bool(forKey: "eu.roadout.Roadout.shownTip8") == false {
            tipSourceView.tooltip(TutorialView8.instanceFromNib(), orientation: Tooltip.Orientation.top, configuration: { configuration in
                configuration.backgroundColor = UIColor(named: "Card Background")!
                configuration.shadowConfiguration.shadowOpacity = 0.2
                configuration.shadowConfiguration.shadowColor = UIColor.black.cgColor
                configuration.shadowConfiguration.shadowOffset = .zero
                
                return configuration
            })
            UserDefaults.roadout!.set(true, forKey: "eu.roadout.Roadout.shownTip8")
        }
        if self.superview != nil {
            let homeVC = self.parentViewController() as! HomeViewController
            homeVC.isTipHidden = false
            homeVC.tipText.text = "By continuing you agree to the parking rules."
            homeVC.tipIcon.image = UIImage(systemName: "info.windshield")
            homeVC.tipHighlightedText = "parking rules"
            homeVC.tipDestinationViewID = "ParkingInfoVC"
            homeVC.tipTintColor = UIColor(named: selectedLocation.accentColor)!
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        locationLbl.text = parkLocations[selectedParkLocationIndex].name
        reserveBtn.layer.cornerRadius = 12.0
        payBtn.layer.cornerRadius = 12.0
        
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        
        payBtn.setAttributedTitle(parkTitle, for: .normal)
        payBtn.tintColor = UIColor(named: selectedLocation.accentColor)!
        
        reserveBtn.setAttributedTitle(reserveTitle, for: .normal)
        reserveBtn.backgroundColor = UIColor(named: selectedLocation.accentColor)!
        
        if currentLocationCoord != nil {
            let c1 = CLLocation(latitude: parkLocations[selectedParkLocationIndex].latitude, longitude: parkLocations[selectedParkLocationIndex].longitude)
            let c2 = CLLocation(latitude: currentLocationCoord!.latitude, longitude: currentLocationCoord!.longitude)
            
            let distance = c1.distance(from: c2)
            let distanceKM = Double(distance)/1000.0
            let roundedDist = Double(round(100*distanceKM)/100)
            
            distanceLbl.text = "\(roundedDist) km"
        } else {
            distanceLbl.text = "- km"
        }
        
        freeSpotsLbl.text = "\(parkLocations[selectedParkLocationIndex].freeSpots) " + "free spots".localized()
        
        distanceIcon.tintColor = UIColor(named: selectedLocation.accentColor)!
        spotsIcon.tintColor = UIColor(named: selectedLocation.accentColor)!
        priceIcon.tintColor = UIColor(named: selectedLocation.accentColor)!
        
        self.accentColor = UIColor(named: selectedLocation.accentColor)!
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    //MARK: - Data Preparation -
    
    func downloadSpots() async throws {
        for sI in 0...parkLocations[selectedParkLocationIndex].sections.count-1 {
            parkLocations[selectedParkLocationIndex].sections[sI].spots = [ParkSpot]()
        }
        for sI in 0...parkLocations[selectedParkLocationIndex].sections.count-1 {
            do {
                try await EntityManager.sharedInstance.saveParkSpotsAsync(parkLocations[selectedParkLocationIndex].sections[sI].rID)
                parkLocations[selectedParkLocationIndex].sections[sI].spots = dbParkSpots
            } catch let err {
                throw err
            }
        }
    }
}
