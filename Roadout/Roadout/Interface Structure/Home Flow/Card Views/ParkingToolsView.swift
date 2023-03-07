//
//  ParkingToolsView.swift
//  Roadout
//
//  Created by David Retegan on 25.02.2023.
//

import UIKit

class ParkingToolsView: UIView {
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeToolsCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: - Parking Tools -
    
    @IBOutlet weak var findWayBtn: UIButton!
    @IBOutlet weak var expressLaneBtn: UIButton!
    @IBOutlet weak var futureReserveBtn: UIButton!
    @IBOutlet weak var payParkingBtn: UIButton!
    
    @IBAction func findWayTapped(_ sender: Any) {
        let parentVC = self.parentViewController() as! HomeViewController
        let indicatorIcon = UIImage.init(systemName: "binoculars.fill")!.withTintColor(UIColor(named: "Greyish")!, renderingMode: .alwaysOriginal)
        let indicatorView = SPIndicatorView(title: "Finding...".localized(), message: "Please wait".localized(), preset: .custom(indicatorIcon))
        DispatchQueue.main.async {
            indicatorView.dismissByDrag = false
            indicatorView.present()
        }
        FunctionsManager.sharedInstance.foundSpot = nil
        guard let coord = parentVC.mapView.myLocation?.coordinate else {
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
                        indicatorView.dismiss()
                    }
                } else {
                    DispatchQueue.main.async {
                        parentVC.showFindLocationAlert()
                        indicatorView.dismiss()
                    }
                }
            } catch let err {
                print(err)
                DispatchQueue.main.async {
                    parentVC.showFindLocationAlert()
                    indicatorView.dismiss()
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
            alert.view.tintColor = UIColor(named: "Cash Yellow")!
            
            parentVC.present(alert, animated: true)
            
            return
        }
        currentLocationCoord = coord
        let vc = parentVC.storyboard?.instantiateViewController(withIdentifier: "SelectPayVC") as! SelectPayViewController
        parentVC.present(vc, animated: true)
    }
    
    func styleButtons() {
        findWayBtn.layer.cornerRadius = 9
        expressLaneBtn.layer.cornerRadius = 9
        futureReserveBtn.layer.cornerRadius = 9
        payParkingBtn.layer.cornerRadius = 9
        
        findWayBtn.setAttributedTitle(NSAttributedString(string: " Find Way".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
        expressLaneBtn.setAttributedTitle(NSAttributedString(string: " Express Lane".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
        futureReserveBtn.setAttributedTitle(NSAttributedString(string: " Future Road".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
        payParkingBtn.setAttributedTitle(NSAttributedString(string: " Pay Parking".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
    }
    
    //MARK: - View Configuration -
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        
        styleButtons()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[9] as! UIView
    }
}
