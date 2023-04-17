//
//  ParkingToolsView.swift
//  Roadout
//
//  Created by David Retegan on 25.02.2023.
//

import UIKit

class ParkingToolsView: UXView {
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeToolsCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: - Swipe Gesture Configuration -
    
    override func viewSwipedBack() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeToolsCardID, object: nil)
    }
    
    override func excludePansFrom(touch: UITouch) -> Bool {
        return !findWayBtn.bounds.contains(touch.location(in: findWayBtn)) && !expressLaneBtn.bounds.contains(touch.location(in: expressLaneBtn)) && !futureReserveBtn.bounds.contains(touch.location(in: futureReserveBtn)) && !payParkingBtn.bounds.contains(touch.location(in: payParkingBtn)) && !backBtn.bounds.contains(touch.location(in: backBtn))
    }
    
    //MARK: - Parking Tools -
    
    @IBOutlet weak var findWayBtn: UXButton!
    @IBOutlet weak var expressLaneBtn: UIButton!
    @IBOutlet weak var futureReserveBtn: UIButton!
    @IBOutlet weak var payParkingBtn: UIButton!
    
    @IBAction func findWayTapped(_ sender: Any) {
        let parentVC = self.parentViewController() as! HomeViewController
        findWayBtn.startPulseAnimation()
        FunctionsManager.sharedInstance.foundSpot = nil
        guard let coord = parentVC.mapView.myLocation?.coordinate else {
            findWayBtn.stopPulseAnimation()
            parentVC.showFindLocationAlert()
            return
        }
        FunctionsManager.sharedInstance.sortLocations(currentLocation: coord)
        Task {
            do {
                let didFindSpot = try await FunctionsManager.sharedInstance.findWay()
                if didFindSpot {
                    DispatchQueue.main.async {
                        parentVC.showFindCard()
                        NotificationCenter.default.post(name: .addSpotMarkerID, object: nil)
                        self.findWayBtn.stopPulseAnimation()
                    }
                } else {
                    DispatchQueue.main.async {
                        parentVC.showFindLocationAlert()
                        self.findWayBtn.stopPulseAnimation()
                    }
                }
            } catch let err {
                print(err)
                DispatchQueue.main.async {
                    parentVC.showFindLocationAlert()
                    self.findWayBtn.stopPulseAnimation()
                }
            }
        }
    }
    
    @IBAction func expressLaneTapped(_ sender: Any) {
        let parentVC = self.parentViewController() as! HomeViewController
        guard let coord = parentVC.mapView.myLocation?.coordinate else {
            let vc = parentVC.storyboard?.instantiateViewController(withIdentifier: "ExpressChooseVC") as! ExpressChooseViewController
            parentVC.present(vc, animated: true)
            return
        }
        currentLocationCoord = coord
        let vc = parentVC.storyboard?.instantiateViewController(withIdentifier: "ExpressChooseVC") as! ExpressChooseViewController
        parentVC.present(vc, animated: true)
    }
    
    @IBAction func futureReserveTapped(_ sender: Any) {
        let parentVC = self.parentViewController() as! HomeViewController
        guard let coord = parentVC.mapView.myLocation?.coordinate else {
            let vc = parentVC.storyboard?.instantiateViewController(withIdentifier: "FutureRoadVC") as! FutureRoadViewController
            parentVC.present(vc, animated: true)
            return
        }
        currentLocationCoord = coord
        let vc = parentVC.storyboard?.instantiateViewController(withIdentifier: "FutureRoadVC") as! FutureRoadViewController
        parentVC.present(vc, animated: true)
    }
    
    @IBAction func payParkingTapped(_ sender: Any) {
        let parentVC = self.parentViewController() as! HomeViewController
        guard let coord = parentVC.mapView.myLocation?.coordinate else {
            
            let alert = UIAlertController(title: "Error".localized(), message: "Roadout can't access your location to show nearby spots, please enable it in Settings.".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor.Roadout.cashYellow
            
            parentVC.present(alert, animated: true)
            
            return
        }
        currentLocationCoord = coord
        let vc = parentVC.storyboard?.instantiateViewController(withIdentifier: "SelectPayVC") as! SelectPayViewController
        parentVC.present(vc, animated: true)
    }
    
    func styleButtons() {
        findWayBtn.layer.cornerRadius = 11
        expressLaneBtn.layer.cornerRadius = 11
        futureReserveBtn.layer.cornerRadius = 11
        payParkingBtn.layer.cornerRadius = 11
        
        findWayBtn.setAttributedTitle(NSAttributedString(string: " Find Way".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
        expressLaneBtn.setAttributedTitle(NSAttributedString(string: " Express Lane".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
        futureReserveBtn.setAttributedTitle(NSAttributedString(string: " Future Road".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
        payParkingBtn.setAttributedTitle(NSAttributedString(string: " Pay Parking".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
    }
    
    //MARK: - View Configuration -
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.shownTip2") == false {
            findWayBtn.tooltip(TutorialView2.instanceFromNib(), orientation: Tooltip.Orientation.top, configuration: { configuration in
                configuration.backgroundColor = UIColor(named: "Card Background")!
                configuration.shadowConfiguration.shadowOpacity = 0.2
                configuration.shadowConfiguration.shadowColor = UIColor.black.cgColor
                configuration.shadowConfiguration.shadowOffset = .zero
                
                return configuration
            })
            UserDefaults.roadout!.set(true, forKey: "ro.roadout.Roadout.shownTip2")
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        
        styleButtons()
        
        self.accentColor = UIColor.Roadout.goldBrown
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[9] as! UIView
    }
}
