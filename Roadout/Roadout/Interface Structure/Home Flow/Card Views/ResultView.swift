//
//  ResultView.swift
//  Roadout
//
//  Created by David Retegan on 30.10.2021.
//

import UIKit
import CoreLocation

class ResultView: UIView {
    
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
        self.downloadSpots()
        NotificationCenter.default.post(name: .addSectionCardID, object: nil)
    }
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeResultCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    let pickTitle = NSAttributedString(string: "Pick".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        
        locationLbl.text = parkLocations[selectedParkLocationIndex].name
        pickBtn.layer.cornerRadius = 12.0
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        pickBtn.setAttributedTitle(pickTitle, for: .normal)
        pickBtn.backgroundColor = selectedLocationColor
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
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

}