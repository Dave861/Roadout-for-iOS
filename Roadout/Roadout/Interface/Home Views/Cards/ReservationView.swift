//
//  ReservationView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit

class ReservationView: UIView {
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
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
    @IBOutlet weak var helpBtn: UIButton!
    
    @IBOutlet weak var unlockView: UIView!
    @IBOutlet weak var directionsView: UIView!
    @IBOutlet weak var delayView: UIView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var arView: UIView!
    @IBOutlet weak var helpView: UIView!
    
    @IBOutlet weak var unlockLbl: UILabel!
    @IBOutlet weak var directionsLbl: UILabel!
    @IBOutlet weak var delayLbl: UILabel!
    @IBOutlet weak var cancelLbl: UILabel!
    @IBOutlet weak var arLbl: UILabel!
    @IBOutlet weak var helpLbl: UILabel!
    
    
    func styleActionButtons() {
        unlockBtn.setTitle("", for: .normal)
        directionsBtn.setTitle("", for: .normal)
        delayBtn.setTitle("", for: .normal)
        arBtn.setTitle("", for: .normal)
        helpBtn.setTitle("", for: .normal)
        cancelBtn.setTitle("", for: .normal)
        
        unlockView.layer.cornerRadius = 9
        directionsView.layer.cornerRadius = 9
        delayView.layer.cornerRadius = 9
        cancelView.layer.cornerRadius = 9
        arView.layer.cornerRadius = 9
        helpView.layer.cornerRadius = 9
        
        unlockLbl.text = "Unlock".localized()
        directionsLbl.text = "Directions".localized()
        delayLbl.text = "Delay".localized()
        arLbl.text = "Open in AR".localized()
        cancelLbl.text = "Cancel".localized()
        helpLbl.text = "Help".localized()
    }
    
    
    @IBAction func unlockTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .addUnlockCardID, object: nil)
    }
    
    @IBAction func directionsTapped(_ sender: Any) {
        self.openDirectionsToCoords(lat: 46.565645, long: 32.65565)
    }
    
    @IBAction func delayTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        ReservationManager.sharedInstance.checkReservationWasDelayed(id) { result in
            switch result {
                case .success():
                if ReservationManager.sharedInstance.delayWasMade == false {
                    let alert = UIAlertController(title: "Delay Reservation".localized(), message: "You can only delay a reservation once. Use carefully.".localized(), preferredStyle: .alert)
                    alert.view.tintColor = UIColor(named: "Second Orange")
                    let cancelAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.parentViewController().present(alert, animated: true, completion: nil)
                    NotificationCenter.default.post(name: .addDelayCardID, object: nil)
                } else {
                    let alert = UIAlertController(title: "Delay Error".localized(), message: "You have already delayed this reservation. This can only be done once per reservation, please hurry, once the displayed time passes the spot won't be secured.".localized(), preferredStyle: .alert)
                    alert.view.tintColor = UIColor(named: "Kinda Red")
                    let cancelAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.parentViewController().present(alert, animated: true, completion: nil)
                }
                case .failure(let err):
                    print(err)
                    self.manageServerSideErrors(error: err)
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let alert = UIAlertController(title: "Cancel".localized(), message: "Are you sure you want to cancel your reservation? You will only get money back for the unused minutes.".localized(), preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "Redish")
        let cancelAction = UIAlertAction(title: "No".localized(), style: .cancel, handler: nil)
        let proceedAction = UIAlertAction(title: "Yes".localized(), style: .destructive) { action in
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
            ReservationManager.sharedInstance.cancelReservation(id) { result in
                switch result {
                    case .success():
                        print("CANCELLED")
                    case .failure(let err):
                        print(err)
                        self.manageServerSideErrors(error: err)
                }
            }
        }
        alert.addAction(proceedAction)
        alert.addAction(cancelAction)
        self.parentViewController().present(alert, animated: true, completion: nil)
    }
    
    @IBAction func arTapped(_ sender: Any) {
        
    }
    
    @IBAction func helpTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HelpVC") as! HelpViewController
        self.parentViewController().present(vc, animated: true, completion: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.addObs()
        self.layer.cornerRadius = 13.0
        backBtn.setTitle("", for: .normal)
        
        styleActionButtons()
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedDate = dateFormatter.string(from: ReservationManager.sharedInstance.reservationEndDate)
        self.timerLbl.text = "Reserved for ".localized() + formattedDate
        self.timerLbl.set(textColor: UIColor.label, range: timerLbl.range(before: formattedDate))
        self.timerLbl.set(font: UIFont.systemFont(ofSize: 21, weight: .medium), range: timerLbl.range(after: "Reserved for ".localized()))
    }
    
    func addObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimeLbl), name: .updateReservationTimeLabelID, object: nil)
    }
    
    @objc func updateTimeLbl() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedDate = dateFormatter.string(from: ReservationManager.sharedInstance.reservationEndDate)
        self.timerLbl.text = "Reserved for ".localized() + formattedDate
        self.timerLbl.set(textColor: UIColor.label, range: timerLbl.range(before: formattedDate))
        self.timerLbl.set(font: UIFont.systemFont(ofSize: 21, weight: .medium), range: timerLbl.range(after: "Reserved for ".localized()))
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

    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[5] as! UIView
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

