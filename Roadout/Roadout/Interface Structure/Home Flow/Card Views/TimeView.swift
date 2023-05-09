//
//  TimeView.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit
import CoreLocation

class TimeView: UXView {
    
    let continueTitle = NSAttributedString(string: "Continue".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeTimeCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: - Swipe Gesture Configuration -
    
    override func viewSwipedBack() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeTimeCardID, object: nil)
    }
    
    override func excludePansFrom(touch: UITouch) -> Bool {
        return !continueBtn.bounds.contains(touch.location(in: continueBtn)) && !backBtn.bounds.contains(touch.location(in: backBtn))
    }
    
    @IBOutlet weak var continueBtn: UXButton!
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if flowType == .reserve {
            reservationTime = Int(timeSlider.value*60)
            NotificationCenter.default.post(name: .addPayCardID, object: nil)
        } else if flowType == .pay {
            parkingTime = Int(timeSlider.value)
            let alert = UIAlertController(title: "Oops!", message: "Not implemented yet!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            alert.view.tintColor = UIColor.Roadout.darkYellow
            self.parentViewController().present(alert, animated: true)
        }
        ///NotificationCenter.default.post(name: .addPayCardID, object: nil)
    }
        
    @IBOutlet weak var timeSlider: UISlider!
    @IBAction func slided(_ sender: Any) {
        if flowType == .reserve {
            let roundedValue = round(timeSlider.value/1.0)*1.0
            updatePhraseSelect()
            timeLbl.text = "\(Int(timeSlider.value))" + " min".localized()
            delayLbl.isHidden = true
            recommendationIcon.image = UIImage(systemName: "clock.fill")!
        } else {
            let roundedValue = round(timeSlider.value/1.0)*1.0
            updatePhraseParking()
            timeLbl.text = "\(Int(timeSlider.value))" + " hrs".localized()
            delayLbl.isHidden = true
            recommendationIcon.image = UIImage(systemName: "clock.fill")!
        }
    }
        
    @IBOutlet weak var recommendationCard: UIView!
    @IBOutlet weak var phraseLbl: UXResizeLabel!
    @IBOutlet weak var recommendationIcon: UIImageView!
    @IBOutlet weak var recommendationBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var delayLbl: UILabel!
    
    @IBAction func recommendationTapped(_ sender: Any) {
        if flowType == .reserve {
            let alert = UIAlertController(title: "Recommended Time".localized(), message: "We recommend time based on your current location and estimated time to commute to the selected parking spot, if the time exceeds 30 minutes, we do not recommend reserving just yet.".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.view.tintColor = UIColor.Roadout.darkYellow
            self.parentViewController().present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - View Confiuration -
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        continueBtn.layer.cornerRadius = 12.0
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        continueBtn.setAttributedTitle(continueTitle, for: .normal)

        setUpFlow()
        
        self.accentColor = UIColor.Roadout.darkYellow
    }
    
    override func didMoveToSuperview() {
        if self.superview != nil && flowType == .reserve {
            self.getTimeToCommute()
        }
    }
    
    func setUpFlow() {
        if flowType == .reserve {
            timeSlider.minimumValue = 1.0
            timeSlider.maximumValue = 20.0
            timeSlider.minimumValueImage = UIImage(systemName: "1.circle.fill")
            timeSlider.maximumValueImage = UIImage(systemName: "20.circle.fill")
            
            recommendationIcon.image = UIImage(systemName: "wand.and.stars")!
            recommendationBtn.setTitle("", for: .normal)
            updatePhraseLoad()
            timeLbl.text = "..." + " min".localized()
            delayLbl.isHidden = true
            recommendationCard.layer.cornerRadius = recommendationCard.frame.height/5
        } else if flowType == .pay {
            timeSlider.minimumValue = 1.0
            timeSlider.maximumValue = 6.0
            timeSlider.minimumValueImage = UIImage(systemName: "1.circle.fill")
            timeSlider.maximumValueImage = UIImage(systemName: "6.circle.fill")
            
            recommendationIcon.image = UIImage(systemName: "clock.fill")!
            recommendationBtn.setTitle("", for: .normal)
            updatePhraseParking()
            timeLbl.text = "\(Int(timeSlider.value))" + " hrs".localized()
            delayLbl.isHidden = true
            recommendationCard.layer.cornerRadius = recommendationCard.frame.height/5
        }
    }
    
    func updatePhraseParking() {
        phraseLbl.longText = "Park your car for".localized()
        phraseLbl.mediumText = "Park your car".localized()
        phraseLbl.shortText = "Park".localized()
        phraseLbl.text = "Park your car for".localized()
    }
    
    func updatePhraseLoad() {
        phraseLbl.longText = "Loading time recommendation".localized()
        phraseLbl.mediumText = "Loading recommendation".localized()
        phraseLbl.shortText = "Loading".localized()
        phraseLbl.text = "Loading time recommendation".localized()
    }
    func updatePhraseSelect() {
        phraseLbl.longText = "You chose to reserve for".localized()
        phraseLbl.mediumText = "You chose to reserve".localized()
        phraseLbl.shortText = "You chose".localized()
        phraseLbl.text = "You chose to reserve for".localized()
    }
    func updatePhraseRecommend() {
        phraseLbl.longText = "We recommend reserving for".localized()
        phraseLbl.mediumText = "We recommend reserving".localized()
        phraseLbl.shortText = "We recommend".localized()
        phraseLbl.text = "We recommend reserving for".localized()
    }
    
    //MARK: - Time Predictors -
    
    func getTimeToCommute() {
        guard let parentVC = self.parentViewController() as? HomeViewController else {
            self.updatePhraseSelect()
            self.timeLbl.text = "\(Int(self.timeSlider.value))" + " min".localized()
            self.delayLbl.isHidden = true
            self.recommendationIcon.image = UIImage(systemName: "clock.fill")!
            return
        }
        guard let myLocation = parentVC.mapView.myLocation else {
            self.updatePhraseSelect()
            self.timeLbl.text = "\(Int(self.timeSlider.value))" + " min".localized()
            self.delayLbl.isHidden = true
            self.recommendationIcon.image = UIImage(systemName: "clock.fill")!
            return
        }
        let ogCoords = myLocation.coordinate
        let destCoords = CLLocationCoordinate2D(latitude: parkLocations[selectedParkLocationIndex].latitude, longitude: parkLocations[selectedParkLocationIndex].longitude)
        Task {
            self.continueBtn.isEnabled = false
            self.continueBtn.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
            self.timeSlider.isEnabled = false
            do {
                let resultedTime = try await DistanceManager.sharedInstance.getTimeAndDistanceBetween(ogCoords, destCoords)
                DispatchQueue.main.async {
                    if self.evaluateTime(resultedTime) == 2 {
                        self.updatePhraseRecommend()
                        self.timeLbl.text = "20" + " min".localized()
                        self.delayLbl.isHidden = false
                        self.delayLbl.text = "+ " + self.getDelayTime(resultedTime)
                        self.recommendationIcon.image = UIImage(systemName: "wand.and.stars")!
                        self.timeSlider.setValue(20.0, animated: true)
                    } else if self.evaluateTime(resultedTime) == 1 {
                        self.updatePhraseRecommend()
                        self.timeLbl.text = resultedTime.replacingOccurrences(of: " min", with: " min".localized())
                        self.delayLbl.isHidden = true
                        self.recommendationIcon.image = UIImage(systemName: "wand.and.stars")!
                        
                        var valueTime = resultedTime.replacingOccurrences(of: " mins", with: "")
                        valueTime = valueTime.replacingOccurrences(of: " min", with: "")
                        self.timeSlider.setValue(Float(Int(valueTime) ?? 15), animated: true)
                    } else if self.evaluateTime(resultedTime) == 0 {
                        self.updatePhraseSelect()
                        self.timeLbl.text = "\(Int(self.timeSlider.value))" + " min".localized()
                        self.delayLbl.isHidden = true
                        self.recommendationIcon.image = UIImage(systemName: "clock.fill")!
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.updatePhraseSelect()
                    self.timeLbl.text = "\(Int(self.timeSlider.value))" + " min".localized()
                    self.delayLbl.isHidden = true
                    self.recommendationIcon.image = UIImage(systemName: "clock.fill")!
                }
            }
            self.timeSlider.isEnabled = true
            self.continueBtn.isEnabled = true
            self.continueBtn.backgroundColor = UIColor.Roadout.darkYellow.withAlphaComponent(1.0)
        }
    }
    
    func evaluateTime(_ time: String) -> Int {
        //0 for > 30, 1 for < 20, 2 for < 30
        if time.contains("hours") || time.contains("hour") {
            return 0
        } else {
            var timeToConvert = time.replacingOccurrences(of: " mins", with: "")
            timeToConvert = timeToConvert.replacingOccurrences(of: " min", with: "")
            let convertedTime = Int(timeToConvert) ?? 100
            if convertedTime > 30 {
                return 0
            } else if convertedTime > 20 {
                return 2
            } else {
                return 1
            }
        }
    }
    
    func getDelayTime(_ time: String) -> String {
        var timeToConvert = time.replacingOccurrences(of: " mins", with: "")
        timeToConvert = timeToConvert.replacingOccurrences(of: " min", with: "")
        let convertedTime = Int(timeToConvert) ?? 100
        return "\(convertedTime-20) " + "delay".localized()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[3] as! UIView
    }

}
