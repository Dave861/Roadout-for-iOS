//
//  SelectViewController.swift
//  Roadout
//
//  Created by David Retegan on 19.07.2022.
//

import UIKit
import CoreLocation

class SelectPayViewController: UIViewController {
    
    var recentParkLocations = [ParkLocation]()
    var nearbyParkLocations = [ParkLocation]()
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderText: UILabel!
    
    @IBOutlet weak var segmentedSwitcher: UISegmentedControl!
    
    @IBAction func spotsSwitched(_ sender: Any) {
        self.reloadSpotsCategory()
    }
    
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Cash Yellow")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.setAttributedTitle(cancelTitle, for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        segmentedSwitcher.setTitle("Nearby".localized(), forSegmentAt: 0)
        segmentedSwitcher.setTitle("Recent".localized(), forSegmentAt: 1)
        if currentLocationCoord != nil {
            nearbyParkLocations = sortLocations(currentLocation: currentLocationCoord!)
        } else {
            nearbyParkLocations = parkLocations
        }
        reloadSpotsCategory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.shownTip4") == false {
             titleLbl.tooltip(TutorialView4.instanceFromNib(), orientation: Tooltip.Orientation.top, configuration: { configuration in
                 
                 configuration.backgroundColor = UIColor(named: "Card Background")!
                 configuration.shadowConfiguration.shadowOpacity = 0.1
                 configuration.shadowConfiguration.shadowColor = UIColor.black.cgColor
                 configuration.shadowConfiguration.shadowOffset = .zero
                 
                 return configuration
             })
             UserDefaults.roadout!.set(true, forKey: "ro.roadout.Roadout.shownTip4")
         }
    }
    
    func reloadSpotsCategory() {
        if segmentedSwitcher.selectedSegmentIndex == 0 {
            //Nearby
            tableView.reloadData()
            placeholderText.text = "No locations found nearby. Location access might be disabled".localized()
            if nearbyParkLocations.count == 0 {
                placeholderView.alpha = 1
                tableView.alpha = 0
            } else {
                placeholderView.alpha = 0
                tableView.alpha = 1
            }
        } else {
            //Recent
            tableView.reloadData()
            placeholderText.text = "No recent locations found. Start in the nearby section".localized()
            if recentParkLocations.count == 0 {
                placeholderView.alpha = 1
                tableView.alpha = 0
            } else {
                placeholderView.alpha = 0
                tableView.alpha = 1
            }
        }
    }
    
    func sortLocations(currentLocation: CLLocationCoordinate2D) -> [ParkLocation] {
        let current = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        var dictArray = [[String: Any]]()
        for i in 0 ..< parkLocations.count {
            let loc = CLLocation(latitude: parkLocations[i].latitude, longitude: parkLocations[i].longitude)
            let distanceInMeters = current.distance(from: loc)
            let a:[String: Any] = ["distance": distanceInMeters, "location": parkLocations[i]]
            dictArray.append(a)
        }
        dictArray = dictArray.sorted(by: {($0["distance"] as! CLLocationDistance) < ($1["distance"] as! CLLocationDistance)})
        
        var sortedArray = [ParkLocation]()
       
        for i in dictArray {
            sortedArray.append(i["location"] as! ParkLocation)
        }
        
        return sortedArray
    }
    
    func getRotationFor(_ percent: Int) -> CGFloat {
        if percent == 100 {
            return 2.44
        } else if percent >= 90 {
            return 2.02
        } else if percent >= 80 {
            return 1.57
        } else if percent >= 70 {
            return 1.04
        } else if percent >= 60 {
            return 0.52
        } else if percent >= 50 {
            return 0
        } else if percent >= 40 {
            return -0.52
        } else if percent >= 30 {
            return -1.04
        } else if percent >= 20 {
            return -1.57
        } else if percent >= 10 {
            return -2.02
        } else {
            return 2.44
        }
    }
    
    func getPercentageFrom(totalSpots: Int, freeSpots: Int) -> Int {
        return 100-Int(Float(freeSpots)/Float(totalSpots) * 100)
    }
    

}
extension SelectPayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedSwitcher.selectedSegmentIndex == 0 {
            return nearbyParkLocations.count
        } else {
            return recentParkLocations.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedSwitcher.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPayCell") as! SelectPayCell
            cell.nameLbl.text = nearbyParkLocations[indexPath.row].name
            
            let coord = CLLocationCoordinate2D(latitude: nearbyParkLocations[indexPath.row].latitude, longitude: nearbyParkLocations[indexPath.row].longitude)
            if currentLocationCoord != nil {
                let c1 = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                let c2 = CLLocation(latitude: currentLocationCoord!.latitude, longitude: currentLocationCoord!.longitude)
                
                let distance = c1.distance(from: c2)
                let distanceKM = Double(distance)/1000.0
                let roundedDist = Double(round(100*distanceKM)/100)
                
                cell.distanceLbl.text = "\(roundedDist) km"
                
                if distanceKM <= 0.15 {
                    cell.currentLocationLbl.isHidden = false
                    cell.currentLocationIcon.isHidden = false
                }
            } else {
                cell.distanceLbl.text = "- km"
            }
            
            let occupancyPercent = self.getPercentageFrom(totalSpots: nearbyParkLocations[indexPath.row].totalSpots, freeSpots: nearbyParkLocations[indexPath.row].freeSpots)
            
            cell.gaugeIcon.transform = .identity
            cell.gaugeIcon.transform = cell.gaugeIcon.transform.rotated(by: self.getRotationFor(occupancyPercent))
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPayCell") as! SelectPayCell
            cell.nameLbl.text = recentParkLocations[indexPath.row-1].name
            
            let coord = CLLocationCoordinate2D(latitude: recentParkLocations[indexPath.row].latitude, longitude: recentParkLocations[indexPath.row].longitude)
            if currentLocationCoord != nil {
                let c1 = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                let c2 = CLLocation(latitude: currentLocationCoord!.latitude, longitude: currentLocationCoord!.longitude)
                
                let distance = c1.distance(from: c2)
                let distanceKM = Double(distance)/1000.0
                let roundedDist = Double(round(100*distanceKM)/100)
                
                cell.distanceLbl.text = "\(roundedDist) km"
                
                if distanceKM <= 0.15 {
                    cell.currentLocationLbl.isHidden = false
                    cell.currentLocationIcon.isHidden = false
                }
            } else {
                cell.distanceLbl.text = "- km"
            }
            
            let occupancyPercent = self.getPercentageFrom(totalSpots: recentParkLocations[indexPath.row].totalSpots, freeSpots: recentParkLocations[indexPath.row].freeSpots)
            
            cell.gaugeIcon.transform = .identity
            cell.gaugeIcon.transform = cell.gaugeIcon.transform.rotated(by: self.getRotationFor(occupancyPercent))
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if segmentedSwitcher.selectedSegmentIndex == 0 {
            selectedPayLocation = nearbyParkLocations[indexPath.row]
        } else {
            selectedPayLocation = recentParkLocations[indexPath.row]
        }
        isPayFlow = true
        //Clear saved car park
        UserDefaults.roadout!.setValue("roadout_carpark_clear", forKey: "ro.roadout.Roadout.carParkHash")
        carParkHash = "roadout_carpark_clear"
        NotificationCenter.default.post(name: .refreshMarkedSpotID, object: nil)
        NotificationCenter.default.post(name: .addPayDurationCardID, object: nil)
        self.dismiss(animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SelectPayCell
        cell.card.backgroundColor = UIColor(named: "Highlight Secondary Detail")
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SelectPayCell
        cell.card.backgroundColor = UIColor(named: "Secondary Detail")
    }
}
