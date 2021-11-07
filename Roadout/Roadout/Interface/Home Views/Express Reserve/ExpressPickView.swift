//
//  ExpressPickView.swift
//  Roadout
//
//  Created by David Retegan on 07.11.2021.
//

import UIKit
import CoreLocation

class ExpressPickView: UIView {
    
    let returnToSearchBarID = "ro.roadout.Roadout.returnToSearchBarID"
    let addExpressViewID = "ro.roadout.Roadout.addExpressViewID"

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: Notification.Name(returnToSearchBarID), object: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        
        backBtn.setTitle("", for: .normal)

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        tableView.register(UINib(nibName: "ExpressLocationCell", bundle: nil), forCellReuseIdentifier: "ExpressLocationCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Express", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    
}
extension ExpressPickView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkLocations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpressLocationCell") as! ExpressLocationCell
        cell.nameLbl.text = parkLocations[indexPath.row].name
        let coord = CLLocationCoordinate2D(latitude: parkLocations[indexPath.row].latitude, longitude: parkLocations[indexPath.row].longitude)
        if currentLocationCoord != nil {
            let c1 = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            let c2 = CLLocation(latitude: currentLocationCoord!.latitude, longitude: currentLocationCoord!.longitude)
            
            let distance = c1.distance(from: c2)
            let distanceKM = Double(distance)/1000.0
            let roundedDist = Double(round(100*distanceKM)/100)
            
            cell.distanceLbl.text = "\(roundedDist) km"
        } else {
            cell.distanceLbl.text = "- km"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        selectedLocation = parkLocations[indexPath.row].name
        selectedLocationColor = UIColor(named: "Dark Orange")!
        selectedLocationCoord = CLLocationCoordinate2DMake(parkLocations[indexPath.row].latitude, parkLocations[indexPath.row].longitude)
        NotificationCenter.default.post(name: Notification.Name(addExpressViewID), object: nil)
    }
}
