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
    
    @IBOutlet weak var pickBtn: UXButton!
    @IBAction func pickTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        returnToResult = false
        Task.detached {
            do {
                try await self.downloadSpots()
            } catch let err {
                print(err)
            }
        }
        
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
        let indicatorIcon = UIImage(named: "roadout.car")!.withTintColor(UIColor(named: selectedLocation.accentColor)!, renderingMode: .alwaysOriginal)
        let indicatorView = SPIndicatorView(title: "Loading...".localized(), message: "Please wait".localized(), preset: .custom(indicatorIcon))
        indicatorView.dismissByDrag = false
        indicatorView.present()
        Task {
            do {
                try await FunctionsManager.sharedInstance.findSpotInLocationAsync(location: parkLocations[selectedParkLocationIndex])
                DispatchQueue.main.async {
                    isSelectionFlow = false
                    NotificationCenter.default.post(name: .addSpotMarkerID, object: nil)
                    NotificationCenter.default.post(name: .addTimeCardID, object: nil)
                    indicatorView.dismiss()
                }
            } catch {
                self.showNoFreeSpotAlert(indicatorView: indicatorView)
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        isSelectionFlow = false
        NotificationCenter.default.post(name: .removeResultCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: - View Confiuration -
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        locationLbl.text = parkLocations[selectedParkLocationIndex].name
        pickBtn.layer.cornerRadius = 12.0
        continueBtn.layer.cornerRadius = 12.0
        
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        
        pickBtn.setAttributedTitle(pickTitle, for: .normal)
        pickBtn.tintColor = UIColor(named: selectedLocation.accentColor)!
        
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        continueBtn.backgroundColor = UIColor(named: selectedLocation.accentColor)!
        
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
        
        distanceIcon.tintColor = UIColor(named: selectedLocation.accentColor)!
        sectionsIcon.tintColor = UIColor(named: selectedLocation.accentColor)!
        spotsIcon.tintColor = UIColor(named: selectedLocation.accentColor)!
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    //MARK: - Data Preparation -
    
    func downloadSpots() async throws {
        for sI in 0...parkLocations[selectedParkLocationIndex].sections.count-1 {
            parkLocations[selectedParkLocationIndex].sections[sI].spots = [ParkSpot]()
        }
        for sI in 0...parkLocations[selectedParkLocationIndex].sections.count-1 {
            do {
                try await EntityManager.sharedInstance.saveParkSpotsAsync(parkLocations[selectedParkLocationIndex].sections[sI].rID)
                parkLocations[selectedParkLocationIndex].sections[sI].spots = dbParkSpots
            } catch let err {
                throw err
            }
        }
    }

    func showNoFreeSpotAlert(indicatorView: SPIndicatorView) {
        DispatchQueue.main.async {
            indicatorView.dismiss()
            
            let alert = UIAlertController(title: "Error".localized(), message: "It seems there are no free spots in this location at the moment".localized(), preferredStyle: .alert)
            alert.view.tintColor = UIColor(named: selectedLocation.accentColor)!
            alert.addAction(UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil))
            self.parentViewController().present(alert, animated: true, completion: nil)
        }
    }
    
}
