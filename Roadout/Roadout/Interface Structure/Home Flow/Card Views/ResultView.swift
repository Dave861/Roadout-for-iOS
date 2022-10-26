//
//  ResultView.swift
//  Roadout
//
//  Created by David Retegan on 30.10.2021.
//

import UIKit
import CoreLocation

class ResultView: UIView {
    
    let pickTitle = NSAttributedString(string: "Pick".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let continueTitle = NSAttributedString(string: "Continue".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var sectionsLbl: UILabel!
    @IBOutlet weak var freeSpotsLbl: UILabel!
    
    @IBOutlet weak var distanceIcon: UIImageView!
    @IBOutlet weak var sectionsIcon: UIImageView!
    @IBOutlet weak var spotsIcon: UIImageView!
    
    @IBOutlet weak var pickBtn: UIButton!
    @IBAction func pickTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        returnToResult = false
        self.downloadSpots()
        //Clear saved car park
        UserDefaults.roadout!.setValue("roadout_carpark_clear", forKey: "ro.roadout.Roadout.carParkHash")
        carParkHash = "roadout_carpark_clear"
        NotificationCenter.default.post(name: .refreshMarkedSpotID, object: nil)
        
        NotificationCenter.default.post(name: .addSectionCardID, object: nil)
    }
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        returnToResult = true
        //Clear saved car park
        UserDefaults.roadout!.setValue("roadout_carpark_clear", forKey: "ro.roadout.Roadout.carParkHash")
        carParkHash = "roadout_carpark_clear"
        NotificationCenter.default.post(name: .refreshMarkedSpotID, object: nil)
        //Find first free spot
        self.showLoadingIndicator()
        FunctionsManager.sharedInstance.reserveSpotInLocation(sectionIndex: 0, location: parkLocations[selectedParkLocationIndex])
    }
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeResultCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(showNoFreeSpotAlert), name: .showNoFreeSpotInLocationID, object: nil)
    }
    @objc func showNoFreeSpotAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error".localized(), message: "It seems there are no free spots in this location at the moment".localized(), preferredStyle: .alert)
            alert.view.tintColor = selectedLocationColor ?? UIColor(named: "Main Yellow")!
            alert.addAction(UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil))
            self.parentViewController().present(alert, animated: true, completion: nil)
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        manageObs()
        
        self.layer.cornerRadius = 19.0
        locationLbl.text = parkLocations[selectedParkLocationIndex].name
        pickBtn.layer.cornerRadius = 12.0
        continueBtn.layer.cornerRadius = 12.0
        
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        
        pickBtn.setAttributedTitle(pickTitle, for: .normal)
        pickBtn.tintColor = selectedLocationColor
        
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        continueBtn.backgroundColor = selectedLocationColor
        
        if currentLocationCoord != nil {
            let c1 = CLLocation(latitude: parkLocations[selectedParkLocationIndex].latitude, longitude: parkLocations[selectedParkLocationIndex].longitude)
            let c2 = CLLocation(latitude: currentLocationCoord!.latitude, longitude: currentLocationCoord!.longitude)
            
            let distance = c1.distance(from: c2)
            let distanceKM = Double(distance)/1000.0
            let roundedDist = Double(round(100*distanceKM)/100)
            
            distanceLbl.text = "\(roundedDist) km"
        } else {
            distanceLbl.text = "- km"
        }
        
        sectionsLbl.text = "\(parkLocations[selectedParkLocationIndex].sections.count) " + "sections".localized()
        freeSpotsLbl.text = "\(parkLocations[selectedParkLocationIndex].freeSpots) " + "free spots".localized()
        
        distanceIcon.tintColor = selectedLocationColor
        sectionsIcon.tintColor = selectedLocationColor
        spotsIcon.tintColor = selectedLocationColor
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func downloadSpots() {
        for index in 0...parkLocations[selectedParkLocationIndex].sections.count-1 {
            parkLocations[selectedParkLocationIndex].sections[index].spots = [ParkSpot]()
        }
        for index in 0...parkLocations[selectedParkLocationIndex].sections.count-1 {
            EntityManager.sharedInstance.getParkSpots(parkLocations[selectedParkLocationIndex].sections[index].rID) { result in
                switch result {
                    case .success():
                        parkLocations[selectedParkLocationIndex].sections[index].spots = dbParkSpots
                        //selectedParkLocation.sections[index].spots = dbParkSpots
                    case .failure(let err):
                        print(err)
                }
            }
        }
    }
    
    func showLoadingIndicator() {
        let indicatorIcon = UIImage.init(systemName: "car.fill")!.withTintColor(selectedLocationColor ?? UIColor(named: "Main Yellow")!, renderingMode: .alwaysOriginal)
        let indicatorView = SPIndicatorView(title: "Loading...".localized(), message: "Please wait".localized(), preset: .custom(indicatorIcon))
        indicatorView.dismissByDrag = false
        indicatorView.present(duration: 1.0, haptic: .none, completion: nil)
    }

}
