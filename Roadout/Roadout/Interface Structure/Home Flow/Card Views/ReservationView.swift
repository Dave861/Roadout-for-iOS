//
//  ReservationView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit
import GeohashKit

class ReservationView: UXView {
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeReservationCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: - Swipe Gesture Configuration -
    
    override func viewSwipedBack() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeReservationCardID, object: nil)
    }
    
    override func excludePansFrom(touch: UITouch) -> Bool {
        return !unlockBtn.bounds.contains(touch.location(in: unlockBtn)) && !directionsBtn.bounds.contains(touch.location(in: directionsBtn)) && !delayBtn.bounds.contains(touch.location(in: delayBtn)) && !cancelBtn.bounds.contains(touch.location(in: cancelBtn)) && !moreBtn.bounds.contains(touch.location(in: moreBtn)) && !helpBtn.bounds.contains(touch.location(in: helpBtn)) && !backBtn.bounds.contains(touch.location(in: backBtn))
    }
    
    @IBOutlet weak var timerLbl: UILabel!
        
    @IBOutlet weak var unlockBtn: UXButton!
    @IBOutlet weak var directionsBtn: UXButton!
    @IBOutlet weak var delayBtn: UXButton!
    @IBOutlet weak var cancelBtn: UXButton!
    @IBOutlet weak var moreBtn: UXButton!
    @IBOutlet weak var helpBtn: UXButton!
    
    
    func styleActionButtons() {
        unlockBtn.layer.cornerRadius = 12
        directionsBtn.layer.cornerRadius = 12
        delayBtn.layer.cornerRadius = 12
        cancelBtn.layer.cornerRadius = 12
        helpBtn.layer.cornerRadius = 12
        moreBtn.layer.cornerRadius = 12
        
        unlockBtn.setAttributedTitle(NSAttributedString(string: "Unlock".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
        directionsBtn.setAttributedTitle(NSAttributedString(string: "Navigate".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
        delayBtn.setAttributedTitle(NSAttributedString(string: "Delay".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
        cancelBtn.setAttributedTitle(NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
        helpBtn.setAttributedTitle(NSAttributedString(string: "Help".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
        moreBtn.setAttributedTitle(NSAttributedString(string: "More".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]), for: .normal)
        
        if #available(iOS 15.0, *) {
            unlockBtn.configuration?.imagePlacement = .top
            directionsBtn.configuration?.imagePlacement = .top
            delayBtn.configuration?.imagePlacement = .top
            cancelBtn.configuration?.imagePlacement = .top
            helpBtn.configuration?.imagePlacement = .top
            moreBtn.configuration?.imagePlacement = .top
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK: - Reservation Actions -
    
    @IBAction func unlockTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .addUnlockCardID, object: nil)
    }
    
    @IBAction func directionsTapped(_ sender: Any) {
        let hashComponents = selectedSpot.rHash.components(separatedBy: "-") //[hash, fNR, hNR, pNR]
        let lat = Geohash(geohash: hashComponents[0])!.coordinates.latitude
        let long = Geohash(geohash: hashComponents[0])!.coordinates.longitude
        
        self.openDirectionsToCoords(lat: lat, long: long)
    }
    
    @IBAction func delayTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let id = UserDefaults.roadout!.object(forKey: "eu.roadout.Roadout.userID") as! String
        Task {
            do {
                let delayWasMade = try await ReservationManager.sharedInstance.checkReservationWasDelayedAsync(userID: id)
                if delayWasMade == false {
                        if UserDefaults.roadout!.bool(forKey: "eu.roadout.Roadout.shownDelayWarning") == false {
                            UserDefaults.roadout!.set(true, forKey: "eu.roadout.Roadout.shownDelayWarning")
                            let alert = UIAlertController(title: "Delay Reservation".localized(), message: "You can only delay a reservation once. Use carefully.".localized(), preferredStyle: .alert)
                            alert.view.tintColor = UIColor.Roadout.secondOrange
                            let cancelAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                            alert.addAction(cancelAction)
                            self.parentViewController().present(alert, animated: true, completion: nil)
                        }
                        NotificationCenter.default.post(name: .addDelayCardID, object: nil)
                } else {
                    let alert = UIAlertController(title: "Delay Restricted".localized(), message: "You have already delayed this reservation. This can only be done once per reservation, please hurry, once the displayed time passes the spot won't be secured.".localized(), preferredStyle: .alert)
                    alert.view.tintColor = UIColor.Roadout.kindaRed
                    let cancelAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.parentViewController().present(alert, animated: true, completion: nil)
                }
            } catch let err {
                self.manageServerSideErrors(error: err)
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let alert = UIAlertController(title: "Cancel Reservation".localized(), message: "Are you sure you want to cancel your reservation? You will only get half the money back and only if the reservation is less than half consumed.".localized(), preferredStyle: .alert)
        alert.view.tintColor = UIColor.Roadout.redish
        let cancelAction = UIAlertAction(title: "No".localized(), style: .cancel, handler: nil)
        let proceedAction = UIAlertAction(title: "Yes".localized(), style: .destructive) { action in
            NotificationCenter.default.post(name: .btBarrierDown, object: nil)
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            let id = UserDefaults.roadout!.object(forKey: "eu.roadout.Roadout.userID") as! String
            Task {
                do {
                    try await ReservationManager.sharedInstance.cancelReservationAsync(userID: id, date: Date())
                    DispatchQueue.main.async {
                        if ReservationManager.sharedInstance.reservationTimer != nil {
                            ReservationManager.sharedInstance.reservationTimer.invalidate()
                        }
                        NotificationHelper.sharedInstance.cancelReservationNotification()
                        NotificationHelper.sharedInstance.cancelLocationNotification()
                        if #available(iOS 16.1, *) {
                            LiveActivityHelper.sharedInstance.endLiveActivity()
                        }
                        NotificationCenter.default.post(name: .showCancelledBarID, object: nil)
                    }
                } catch let err {
                    self.manageServerSideErrors(error: err)
                }
            }
        }
        alert.addAction(proceedAction)
        alert.addAction(cancelAction)
        self.parentViewController().present(alert, animated: true, completion: nil)
    }
    
    @IBAction func helpTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HelpVC") as! HelpViewController
        self.parentViewController().present(vc, animated: true, completion: nil)
    }
    
    func makeMoreMenu() -> UIMenu {
        let worldAction = UIAction(title: "World View".localized(), image: UIImage(systemName: "globe.desk.fill"), handler: { (_) in
            guard selectedSpot.rHash != "" else {
                self.manageLocalError(color: "Limey")
                return
            }
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "WorldVC") as! WorldViewController
            self.parentViewController().present(vc, animated: true, completion: nil)
        })
        let ARAction = UIAction(title: "AR Directions".localized(), image: UIImage(systemName: "arkit"), handler: { (_) in
            guard selectedSpot.rHash != "" else {
                self.manageLocalError(color: "Kinda Red")
                return
            }

            if ARManager.sharedInstance.shownTutorial() {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ARDirectionsVC") as! ARDirectionsViewController
                self.parentViewController().present(vc, animated: true, completion: nil)
            } else {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ARTutorialVC") as! ARTutorialViewController
                self.parentViewController().present(vc, animated: true, completion: nil)
            }
        })
        return UIMenu(title: "More Actions".localized(), image: nil, identifier: nil, options: [], children: [worldAction, ARAction])
    }
    
    //MARK: - View Configuration -
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimeLbl), name: .updateReservationTimeLabelID, object: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        manageObs()
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        
        styleActionButtons()
        moreBtn.showsMenuAsPrimaryAction = true
        moreBtn.menu = makeMoreMenu()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedDate = dateFormatter.string(from: ReservationManager.sharedInstance.reservationEndDate)
        self.timerLbl.text = formattedDate
        
        self.accentColor = UIColor.Roadout.icons
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[5] as! UIView
    }
    
    @objc func updateTimeLbl() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedDate = dateFormatter.string(from: ReservationManager.sharedInstance.reservationEndDate)
        self.timerLbl.text = formattedDate
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
    
    func manageLocalError(color: String) {
        let alert = UIAlertController(title: "Error".localized(), message: "There was an error requesting spot location.".localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor(named: color)
        self.parentViewController().present(alert, animated: true, completion: nil)
    }

    func manageServerSideErrors(error: Error) {
        switch error {
            case ReservationManager.ReservationErrors.spotAlreadyTaken:
                let alert = UIAlertController(title: "Couldn't reserve".localized(), message: "Something went wrong, it seems like someone already took the spot, hence we are not able to reserve it. We are sorry.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.networkError:
                let alert = UIAlertController(title: "Network Error".localized(), message: "Please check you network connection.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.databaseFailure:
                let alert = UIAlertController(title: "Internal Error".localized(), message: "There was an internal problem, please wait and try again a little later.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.unknownError:
                let alert = UIAlertController(title: "Unknown Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.errorWithJson:
                let alert = UIAlertController(title: "JSON Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                self.parentViewController().present(alert, animated: true, completion: nil)
            default:
                let alert = UIAlertController(title: "Unknown Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                self.parentViewController().present(alert, animated: true, completion: nil)
        }
    }
    
}

