//
//  ReserveView.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit
import CoreLocation

class ReserveView: UIView {

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        if returnToResult {
            NotificationCenter.default.post(name: .removeSpotMarkerID, object: nil)
        }
        NotificationCenter.default.post(name: .removeReserveCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        timerSeconds = Int(minuteSlider.value*60)
        NotificationCenter.default.post(name: .addPayCardID, object: nil)
    }
    
    @IBOutlet weak var coordonatesLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var minuteSlider: UISlider!
    @IBAction func slided(_ sender: Any) {
        let roundedValue = round(minuteSlider.value/1.0)*1.0
        minuteSlider.value = roundedValue
        totalLbl.text = "\(Int(minuteSlider.value))" + " Minutes ".localized() + "- \(Int(minuteSlider.value)) RON"
        totalLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: totalLbl.range(after: " - "))
        totalLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: totalLbl.range(after: " - "))
    }
    
    @IBOutlet weak var totalLbl: UILabel!
    
    @IBOutlet weak var recommendationCard: UIView!
    @IBOutlet weak var recommendationLbl: UILabel!
    
    @IBAction func recommendationTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Recommended Time".localized(), message: "We recommend time based on your current location and estimated time to commute to the selected parking spot, if the time exceeds 20 minutes, we do not recommend reserving just yet.".localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.view.tintColor = UIColor(named: "Dark Yellow")!
        self.parentViewController().present(alert, animated: true, completion: nil)
    }
    
    let continueTitle = NSAttributedString(string: "Continue".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        continueBtn.layer.cornerRadius = 12.0
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        
        coordonatesLbl.text = "\(parkLocations[selectedParkLocationIndex].latitude), \(parkLocations[selectedParkLocationIndex].longitude)"
        recommendationLbl.text = "We recommed reserving for ".localized() + "..."
        
        recommendationCard.layer.cornerRadius = recommendationCard.frame.height/5
        
        totalLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: totalLbl.range(after: " - "))
        totalLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: totalLbl.range(after: " - "))
        
    }
    
    override func didMoveToSuperview() {
        if self.superview != nil {
            self.getTimeToCommute()
        }
    }
    
    func getTimeToCommute() {
        guard let parentVC = self.parentViewController() as? HomeViewController else {
            return
        }
        guard let myLocation = parentVC.mapView.myLocation else {
            self.recommendationLbl.text = "Couldn't get a recommendation.".localized()
            return
        }
        let ogCoords = myLocation.coordinate
        let destCoords = CLLocationCoordinate2D(latitude: parkLocations[selectedParkLocationIndex].latitude, longitude: parkLocations[selectedParkLocationIndex].longitude)
        DistanceManager.sharedInstance.getTimeAndDistanceBetween(ogCoords, destCoords) { result in
            switch result {
            case .success(let resultedTime):
                print(resultedTime)
                if self.evaluateTime(resultedTime) {
                    self.recommendationLbl.text = "We recommed reserving for ".localized() + resultedTime
                } else {
                    self.recommendationLbl.text = "We don't recommed reserving yet.".localized()
                }
            case .failure(let err):
                print(err)
                self.recommendationLbl.text = "Couldn't get a recommendation.".localized()
            }
        }
    }
    
    func evaluateTime(_ time: String) -> Bool {
        if time.contains("hours".localized()) {
            return false
        } else {
            let timeToConvert = time.replacingOccurrences(of: " mins".localized(), with: "")
            let convertedTime = Int(timeToConvert) ?? 100
            if convertedTime > 20 {
                return false
            } else {
                return true
            }
        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[3] as! UIView
    }

}
