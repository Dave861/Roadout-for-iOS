//
//  CarViewController.swift
//  Roadout
//
//  Created by David Retegan on 13.02.2023.
//

import UIKit
import CoreLocation

class CarViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var warningBtn: UIButton!
    @IBOutlet weak var warningLbl: UILabel!
    @IBAction func warningTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Warning".localized(), message: "Location must be always enabled in order for Roadout to work with Siri".localized(), preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "Icons")
        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel)
        let turnAction = UIAlertAction(title: "Enable".localized(), style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
        alert.addAction(okAction)
        alert.addAction(turnAction)
        self.present(alert, animated: true)
    }
    
    @IBOutlet weak var siriCard: UIView!
    @IBOutlet weak var siriTitle: UILabel!
    @IBOutlet weak var siriDescription: UILabel!
    
    @IBOutlet weak var carplayCard: UIView!
    @IBOutlet weak var carplayTitle: UILabel!
    @IBOutlet weak var carplayDescription: UILabel!
    
    //MARK: - View Configuration -

    override func viewDidLoad() {
        super.viewDidLoad()
        siriCard.layer.cornerRadius = 16.0
        carplayCard.layer.cornerRadius = 16.0
        highlightDescriptions()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        manageWarning()
    }
    
    func highlightDescriptions() {
        siriDescription.text = "While driving, we recommend using Roadout with Siri. You can ask Siri to find parking with Roadout, check your reservation status, and get directions to your parking spot".localized()
        carplayDescription.text = "You will soon be able to use Roadout in your CarPlay enabled car to make reservation, delay or even unlock them".localized()
        
        siriDescription.set(textColor: UIColor(named: "Icons")!, range: siriDescription.range(string: "find parking"))
        siriDescription.set(textColor: UIColor(named: "Icons")!, range: siriDescription.range(string: "reservation"))
        siriDescription.set(textColor: UIColor(named: "Icons")!, range: siriDescription.range(string: "directions"))
        siriDescription.set(font: .systemFont(ofSize: 17, weight: .medium), range: siriDescription.range(string: "find parking"))
        siriDescription.set(font: .systemFont(ofSize: 17, weight: .medium), range: siriDescription.range(string: "reservation"))
        siriDescription.set(font: .systemFont(ofSize: 17, weight: .medium), range: siriDescription.range(string: "directions"))
        
        carplayDescription.set(textColor: UIColor(named: "Icons")!, range: carplayDescription.range(string: "CarPlay"))
        carplayDescription.set(textColor: UIColor(named: "Icons")!, range: carplayDescription.range(string: "unlock"))
        carplayDescription.set(font: .systemFont(ofSize: 17, weight: .medium), range: carplayDescription.range(string: "CarPlay"))
        carplayDescription.set(font: .systemFont(ofSize: 17, weight: .medium), range: carplayDescription.range(string: "unlock"))
    }
    
    func manageWarning() {
        warningBtn.setTitle("", for: .normal)
        warningLbl.text = "Siri Integration is disabled. Learn more".localized()
        warningLbl.set(textColor: UIColor(named: "Icons")!, range: warningLbl.range(after: ". "))
        warningLbl.set(font: .systemFont(ofSize: 18.0, weight: .medium), range: warningLbl.range(after: ". "))
        if locationManager?.authorizationStatus == .authorizedAlways {
            warningBtn.isHidden = true
            warningBtn.isUserInteractionEnabled = false
            warningLbl.isHidden = true
        } else {
            warningBtn.isHidden = false
            warningBtn.isUserInteractionEnabled = true
            warningLbl.isHidden = false
        }
    }
    
}
extension CarViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.manageWarning()
    }
}
