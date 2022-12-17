//
//  ReservationView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit
import GeohashKit

class ReservationView: UIView {
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeReservationCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var timerLbl: UILabel!
        
    @IBOutlet weak var unlockBtn: UIButton!
    @IBOutlet weak var directionsBtn: UIButton!
    @IBOutlet weak var delayBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var arBtn: UIButton!
    @IBOutlet weak var worldBtn: UIButton!
    @IBOutlet weak var helpBtn: UIButton!
    
    @IBOutlet weak var unlockView: UIView!
    @IBOutlet weak var directionsView: UIView!
    @IBOutlet weak var delayView: UIView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var arView: UIView!
    @IBOutlet weak var worldView: UIView!
    @IBOutlet weak var helpView: UIView!
    
    @IBOutlet weak var unlockLbl: UILabel!
    @IBOutlet weak var directionsLbl: UILabel!
    @IBOutlet weak var delayLbl: UILabel!
    @IBOutlet weak var cancelLbl: UILabel!
    @IBOutlet weak var arLbl: UILabel!
    @IBOutlet weak var worldLbl: UILabel!
    @IBOutlet weak var helpLbl: UILabel!
    
    
    func styleActionButtons() {
        unlockBtn.setTitle("", for: .normal)
        directionsBtn.setTitle("", for: .normal)
        delayBtn.setTitle("", for: .normal)
        arBtn.setTitle("", for: .normal)
        helpBtn.setTitle("", for: .normal)
        cancelBtn.setTitle("", for: .normal)
        worldBtn.setTitle("", for: .normal)
        
        unlockView.layer.cornerRadius = 9
        directionsView.layer.cornerRadius = 9
        delayView.layer.cornerRadius = 9
        cancelView.layer.cornerRadius = 9
        arView.layer.cornerRadius = 9
        helpView.layer.cornerRadius = 9
        worldView.layer.cornerRadius = 9
        
        unlockLbl.text = "Unlock".localized()
        directionsLbl.text = "Navigate".localized()
        delayLbl.text = "Delay".localized()
        arLbl.text = "Open in AR".localized()
        cancelLbl.text = "Cancel".localized()
        worldLbl.text = "World View".localized()
        helpLbl.text = "Help & Support".localized()
    }
    
    
    @IBAction func unlockTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .addUnlockCardID, object: nil)
    }
    
    @IBAction func directionsTapped(_ sender: Any) {
        let hashComponents = selectedSpotHash.components(separatedBy: "-") //[hash, fNR, hNR, pNR]
        let lat = Geohash(geohash: hashComponents[0])!.coordinates.latitude
        let long = Geohash(geohash: hashComponents[0])!.coordinates.longitude
        
        self.openDirectionsToCoords(lat: lat, long: long)
    }
    
    @IBAction func delayTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        Task {
            do {
                let delayWasMade = try await ReservationManager.sharedInstance.checkReservationWasDelayedAsync(userID: id)
                if delayWasMade == false {
                        if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.shownDelayWarning") == false {
                            UserDefaults.roadout!.set(true, forKey: "ro.roadout.Roadout.shownDelayWarning")
                            let alert = UIAlertController(title: "Delay Reservation".localized(), message: "You can only delay a reservation once. Use carefully.".localized(), preferredStyle: .alert)
                            alert.view.tintColor = UIColor(named: "Second Orange")
                            let cancelAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                            alert.addAction(cancelAction)
                            self.parentViewController().present(alert, animated: true, completion: nil)
                        }
                        NotificationCenter.default.post(name: .addDelayCardID, object: nil)
                } else {
                    let alert = UIAlertController(title: "Delay Error".localized(), message: "You have already delayed this reservation. This can only be done once per reservation, please hurry, once the displayed time passes the spot won't be secured.".localized(), preferredStyle: .alert)
                    alert.view.tintColor = UIColor(named: "Kinda Red")
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
        let alert = UIAlertController(title: "Cancel".localized(), message: "Are you sure you want to cancel your reservation? You will only get half the money back and only if the reservation is less than half consumed.".localized(), preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "Redish")
        let cancelAction = UIAlertAction(title: "No".localized(), style: .cancel, handler: nil)
        let proceedAction = UIAlertAction(title: "Yes".localized(), style: .destructive) { action in
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
            Task {
                do {
                    try await ReservationManager.sharedInstance.cancelReservationAsync(userID: id, date: Date())
                    DispatchQueue.main.async {
                        if ReservationManager.sharedInstance.reservationTimer != nil {
                            ReservationManager.sharedInstance.reservationTimer.invalidate()
                        }
                        NotificationHelper.sharedInstance.cancelReservationNotification()
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
    
    @IBAction func arTapped(_ sender: Any) {
        guard selectedSpotHash != "" else {
            self.manageLocalError()
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
    }
    
    @IBAction func worldTapped(_ sender: Any) {
        guard selectedSpotHash != "" else {
            self.manageLocalError()
            return
        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "WorldVC") as! WorldViewController
        self.parentViewController().present(vc, animated: true, completion: nil)
    }
    
    @IBAction func helpTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HelpVC") as! HelpViewController
        self.parentViewController().present(vc, animated: true, completion: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        self.addObs()
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        
        styleActionButtons()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedDate = dateFormatter.string(from: ReservationManager.sharedInstance.reservationEndDate)
        self.timerLbl.text = formattedDate
    }
    
    func addObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimeLbl), name: .updateReservationTimeLabelID, object: nil)
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

    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[5] as! UIView
    }
    
    func manageLocalError() {
        let alert = UIAlertController(title: "Error".localized(), message: "There was an error requesting spot details.".localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor(named: "Redish")
        self.parentViewController().present(alert, animated: true, completion: nil)
    }

    func manageServerSideErrors(error: Error) {
        switch error {
            case ReservationManager.ReservationErrors.spotAlreadyTaken:
                let alert = UIAlertController(title: "Couldn't reserve".localized(), message: "Sorry, the 60 seconds have passed and it seems like someone already took the spot, hence we are not able to reserve it. We are sorry.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.networkError:
                let alert = UIAlertController(title: "Network Error".localized(), message: "Please check you network connection.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.databaseFailure:
                let alert = UIAlertController(title: "Internal Error".localized(), message: "There was an internal problem, please wait and try again a little later.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.unknownError:
                let alert = UIAlertController(title: "Unknown Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.errorWithJson:
                let alert = UIAlertController(title: "JSON Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)
            default:
                let alert = UIAlertController(title: "Unknown Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)
        }
    }
    
    
}

