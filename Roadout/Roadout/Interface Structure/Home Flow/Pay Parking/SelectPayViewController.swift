//
//  SelectViewController.swift
//  Roadout
//
//  Created by David Retegan on 19.07.2022.
//

import UIKit
import CoreLocation

class SelectPayViewController: UIViewController {
    
    let recentSpots = [
        ParkIndividualSpot(streetName: "Republicii", number: 18, latitude: 46.765461, longitude: 23.587458, rID: "Cluj.StrRepublicii.18")
    ]
    let nearbySpots = individualSpots
    
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
    }

}
extension SelectPayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSpots.count + nearbySpots.count + 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == recentSpots.count + 1 {
            return 35
        } else {
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPayHeaderCell") as! SelectPayHeaderCell
            cell.headerLbl.text = "Recent"
            if recentSpots.count == 0 {
                cell.headerLbl.text = "No Recents"
            }
            return cell
        } else if indexPath.row > 0 && indexPath.row <= recentSpots.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPayCell") as! SelectPayCell
            
            cell.spotNumber.text = "\(recentSpots[indexPath.row-1].number)"
            
            cell.spotLbl.text = "Spot \(recentSpots[indexPath.row-1].number) - Str. \(recentSpots[indexPath.row-1].streetName)"
            
            cell.spotLbl.set(textColor: UIColor(named: "Cash Yellow")!, range: cell.spotLbl.range(after: " - "))
            
            let coord = CLLocationCoordinate2D(latitude: recentSpots[indexPath.row-1].latitude, longitude: recentSpots[indexPath.row-1].longitude)
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
        } else if indexPath.row == recentSpots.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPayHeaderCell") as! SelectPayHeaderCell
            cell.headerLbl.text = "Nearby"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPayCell") as! SelectPayCell
            
            cell.spotNumber.text = "\(nearbySpots[indexPath.row-2-recentSpots.count].number)"
            
            cell.spotLbl.text = "Spot \(nearbySpots[indexPath.row-2-recentSpots.count].number) - Str. \(nearbySpots[indexPath.row-2-recentSpots.count].streetName)"
            
            cell.spotLbl.set(textColor: UIColor(named: "Cash Yellow")!, range: cell.spotLbl.range(after: " - "))
            
            let coord = CLLocationCoordinate2D(latitude: nearbySpots[indexPath.row-2-recentSpots.count].latitude, longitude: nearbySpots[indexPath.row-2-recentSpots.count].longitude)
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 || indexPath.row != recentSpots.count + 1 {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if indexPath.row != 0 || indexPath.row != recentSpots.count + 1 {
            let cell = tableView.cellForRow(at: indexPath) as! SelectPayCell
            cell.card.backgroundColor = UIColor(named: "Highlight Secondary Detail")
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if indexPath.row != 0 || indexPath.row != recentSpots.count + 1 {
            let cell = tableView.cellForRow(at: indexPath) as! SelectPayCell
            cell.card.backgroundColor = UIColor(named: "Secondary Detail")
        }
    }
}
