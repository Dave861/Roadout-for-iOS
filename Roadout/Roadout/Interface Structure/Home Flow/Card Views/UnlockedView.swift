//
//  UnlockedView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit

class UnlockedView: UIView {
    
    @IBOutlet weak var doneBtn: UIButton!
    
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var payView: UIView!
    @IBOutlet weak var payLbl: UILabel!
    
    @IBOutlet weak var directionsLbl: UILabel!
    @IBOutlet weak var directionsView: UIView!
    @IBOutlet weak var directionsBtn: UIButton!
    
    @IBAction func payTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        isPayFlow = false
        selectedPayLocation = getLocationWith(name: EntityManager.sharedInstance.decodeSpotID(selectedSpotID)[0])
        NotificationCenter.default.post(name: .addPayDurationCardID, object: nil)
    }
    
    @IBAction func directionsTapped(_ sender: Any) {
        //Handled by menu
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        ReservationManager.sharedInstance.checkForReservation(Date(), userID: id) { _ in
            //API call for continuity when app is opened again (to prevent showing unlocked view)
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
    }
    
    func styleActionButtons() {
        payBtn.setTitle("", for: .normal)
        directionsBtn.setTitle("", for: .normal)
        
        payView.layer.cornerRadius = 9
        directionsView.layer.cornerRadius = 9
        
        payLbl.text = "Pay Parking".localized()
        directionsLbl.text = "Find".localized()
    }
    
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        
        directionsBtn.menu = directionsMenu
        directionsBtn.showsMenuAsPrimaryAction = true
        
        timerSeconds = 0
        
        styleActionButtons()
        doneBtn.layer.cornerRadius = doneBtn.frame.height/2
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[8] as! UIView
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Get Directions".localized(), image: UIImage(systemName: "arrow.triangle.branch"), handler: { (_) in
                self.openDirectionsToCoords(lat: 46.565645, long: 32.65565)
            }),
            UIAction(title: "Open in AR (BETA)".localized(), image: UIImage(systemName: "arkit"), handler: { (_) in
                let sb = UIStoryboard(name: "Home", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ARVC") as! ARViewController
                self.parentViewController().present(vc, animated: true, completion: nil)
            }),
            UIAction(title: "World View".localized(), image: UIImage(named: "globe_desk"), handler: { (_) in
                //Make sure selected spot hash is ok
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "WorldVC") as! WorldViewController
                self.parentViewController().present(vc, animated: true, completion: nil)
            })
        ]
    }
    var directionsMenu: UIMenu {
        return UIMenu(title: "Find".localized(), image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    func openDirectionsToCoords(lat: Double, long: Double) {
        var link: String
        switch UserPrefsUtils.sharedInstance.returnPrefferedMapsApp() {
        case "Google Maps":
            link = "https://www.google.com/maps/search/?api=1&query=\(lat),\(long)"
        case "Waze":
            link = "https://www.waze.com/ul?ll=\(lat)%2C-\(long)&navigate=yes&zoom=15"
        default:
            link = "http://maps.apple.com/?ll=\(lat),\(long)&q=Parking%20Location"
        }
        guard UIApplication.shared.canOpenURL(URL(string: link)!) else { return }
        UIApplication.shared.open(URL(string: link)!)
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
