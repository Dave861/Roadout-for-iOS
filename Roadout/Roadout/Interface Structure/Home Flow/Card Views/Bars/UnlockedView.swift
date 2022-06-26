//
//  UnlockedView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit

class UnlockedView: UIView {
    
    let buttonTitle = NSAttributedString(string: "Options".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Brownish")!])
    
    @IBOutlet weak var optionsBtn: UIButton!
    
    @IBAction func optionsTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Options".localized(), preferredStyle: .actionSheet)
        
        let directionsAction = UIAlertAction(title: "Get Directions".localized(), style: .default) { action in
            self.openDirectionsToCoords(lat: 46.565645, long: 32.65565)
        }
        let ARAction = UIAlertAction(title: "Open in AR (BETA)".localized(), style: .default) { action in
            let sb = UIStoryboard(name: "Home", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ARVC") as! ARViewController
            self.parentViewController().present(vc, animated: true, completion: nil)
        }
        let doneAction = UIAlertAction(title: "Done".localized(), style: .default) { action in
            let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
            ReservationManager.sharedInstance.checkForReservation(Date(), userID: id) { _ in
                //API call for continuity when app is opened again (to prevent showing unlock bar)
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
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Greyish")!, forKey: "titleTextColor")
        
        alert.addAction(directionsAction)
        alert.addAction(ARAction)
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        
        alert.view.tintColor = UIColor(named: "Brownish")!
        self.parentViewController().present(alert, animated: true, completion: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 17.0
        optionsBtn.setAttributedTitle(buttonTitle, for: .normal)
        
        if #available(iOS 14.0, *) {
            optionsBtn.menu = optionsMenu
            optionsBtn.showsMenuAsPrimaryAction = true
        }
        
        timerSeconds = 0
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Bars", bundle: nil).instantiate(withOwner: nil, options: nil)[2] as! UIView
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
            UIAction(title: "Done".localized(), image: UIImage(systemName: "xmark"), handler: { (_) in
                let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
                ReservationManager.sharedInstance.checkForReservation(Date(), userID: id) { _ in
                    //API call for continuity when app is opened again (to prevent showing unlock bar)
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
            })
        ]
    }
    var optionsMenu: UIMenu {
        return UIMenu(title: "Options".localized(), image: nil, identifier: nil, options: [], children: menuItems)
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

}
