//
//  ExpressView.swift
//  Roadout
//
//  Created by David Retegan on 07.11.2021.
//

import UIKit

class ExpressView: UIView {
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var chargeLbl: UILabel!
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .addExpressPickViewID, object: nil)
    }
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func sliderChangedValue(_ sender: Any) {
        let roundedValue = round(slider.value/1.0)*1.0
        slider.value = roundedValue
        chargeLbl.text = "\(Int(slider.value))" + " Minutes ".localized() + "- \(Int(slider.value)) RON"
        chargeLbl.set(textColor: UIColor(named: "ExpressFocus")!, range: chargeLbl.range(after: " - "))
        chargeLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: chargeLbl.range(after: " - "))
    }
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var spotSectionLbl: UILabel!
    
    @IBOutlet weak var applePayBtn: UIButton!
    @IBOutlet weak var mainCardBtn: UIButton!
    
    @IBAction func paidApplePay(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        timerSeconds = Int(slider.value*60)
        
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        ReservationManager.sharedInstance.makeReservation(Date(), time: timerSeconds/60, spotID: selectedSpotID, payment: 10, userID: id) { result in
            switch result {
                case .success():
                    print("WE RESERVEDDDDD")
                    selectedSpotID = nil
                case .failure(let err):
                    print(err)
                    self.manageServerSideErrors(error: err)
            }
        }
    }
    
    @IBAction func payMainCard(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        timerSeconds = Int(slider.value*60)
        
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        ReservationManager.sharedInstance.makeReservation(Date(), time: timerSeconds/60, spotID: selectedSpotID, payment: 10, userID: id) { result in
            switch result {
                case .success():
                    print("WE RESERVEDDDDD")
                    selectedSpotID = nil
                case .failure(let err):
                    print(err)
                    self.manageServerSideErrors(error: err)
            }
        }
    }
    
    let applePayTitle = NSAttributedString(string: " Apple Pay".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .regular)])
    var mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        backBtn.setTitle("", for: .normal)
        
        applePayBtn.layer.cornerRadius = 12.0
        applePayBtn.setAttributedTitle(applePayTitle, for: .normal)
        mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        mainCardBtn.layer.cornerRadius = 12.0
        mainCardBtn.setAttributedTitle(mainCardTitle, for: .normal)
        
        chargeLbl.set(textColor: UIColor(named: "ExpressFocus")!, range: chargeLbl.range(after: " - "))
        chargeLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: chargeLbl.range(after: " - "))
        
        locationLbl.text = selectedLocationName
        spotSectionLbl.text = "Section ".localized() + FunctionsManager.sharedInstance.foundSection.name + " - Spot ".localized() + "\(FunctionsManager.sharedInstance.foundSpot.number)"
        
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Express", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
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
