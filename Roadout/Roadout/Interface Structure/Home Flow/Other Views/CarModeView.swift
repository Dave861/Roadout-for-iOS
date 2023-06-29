//
//  ParkingToolsView.swift
//  Roadout
//
//  Created by David Retegan on 25.02.2023.
//

import UIKit

class CarModeView: UXView {
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        let homeVC = self.parentViewController() as! HomeViewController
        homeVC.isTipHidden = true
        NotificationCenter.default.post(name: .removeToolsCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: - Swipe Gesture Configuration -
    
    override func viewSwipedBack() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        let homeVC = self.parentViewController() as! HomeViewController
        homeVC.isTipHidden = true
        NotificationCenter.default.post(name: .removeToolsCardID, object: nil)
    }
    
    override func excludePansFrom(touch: UITouch) -> Bool {
        return !parkBtn.bounds.contains(touch.location(in: parkBtn)) && !reserveBtn.bounds.contains(touch.location(in: reserveBtn)) && !backBtn.bounds.contains(touch.location(in: backBtn))
    }
    
    //MARK: - Parking Tools -
    
    @IBOutlet weak var parkBtn: UXButton!
    @IBOutlet weak var reserveBtn: UXButton!
    
    @IBAction func reserveTapped(_ sender: Any) {
        let parentVC = self.parentViewController() as! HomeViewController
        parentVC.isTipHidden = true
        
        reserveBtn.startPulseAnimation()
        FunctionsManager.sharedInstance.foundSpot = nil
        guard let coord = parentVC.mapView.myLocation?.coordinate else {
            reserveBtn.stopPulseAnimation()
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
                        self.reserveBtn.stopPulseAnimation()
                    }
                } else {
                    DispatchQueue.main.async {
                        parentVC.showFindLocationAlert()
                        self.reserveBtn.stopPulseAnimation()
                    }
                }
            } catch let err {
                print(err)
                DispatchQueue.main.async {
                    parentVC.showFindLocationAlert()
                    self.reserveBtn.stopPulseAnimation()
                }
            }
        }
    }
    
    @IBAction func parkTapped(_ sender: Any) {
        
    }
    
    func styleButtons() {
        parkBtn.layer.cornerRadius = 12
        reserveBtn.layer.cornerRadius = 12
        
        parkBtn.setAttributedTitle(NSAttributedString(string: "Park".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
        reserveBtn.setAttributedTitle(NSAttributedString(string: "Reserve".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
        
        if #available(iOS 15.0, *) {
            parkBtn.configuration?.imagePlacement = .top
            reserveBtn.configuration?.imagePlacement = .top
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK: - View Configuration -
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview != nil {
            let homeVC = self.parentViewController() as! HomeViewController
            homeVC.isTipHidden = false
            homeVC.tipText.text = "Car Mode restricts some features. Learn more"
            homeVC.tipIcon.image = UIImage(systemName: "radio.fill")
            homeVC.tipHighlightedText = "Learn more"
            homeVC.tipDestinationViewID = "__NONE__"
            homeVC.tipTintColor = UIColor.Roadout.icons
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
