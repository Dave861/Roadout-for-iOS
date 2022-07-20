//
//  ExpressPickViewController.swift
//  Roadout
//
//  Created by David Retegan on 19.07.2022.
//

import UIKit
import CoreLocation

class ExpressPickViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "ExpressFocus")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    @IBOutlet weak var tableView: UITableView!
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(showNoFreeSpotAlert), name: .showNoFreeSpotInLocationID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showFreeSpot), name: .showExpressLaneFreeSpotID, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        manageObs()
        cancelButton.setAttributedTitle(cancelTitle, for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
         if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.shownTip3") == false {
             tableView.tooltip(TutorialView3.instanceFromNib(), orientation: Tooltip.Orientation.top, configuration: { configuration in
                 
                 configuration.backgroundColor = UIColor(named: "Card Background")!
                 configuration.shadowConfiguration.shadowOpacity = 0.1
                 configuration.shadowConfiguration.shadowColor = UIColor.black.cgColor
                 configuration.shadowConfiguration.shadowOffset = .zero
                 
                 return configuration
             })
             UserDefaults.roadout!.set(true, forKey: "ro.roadout.Roadout.shownTip3")
         }
    }
    
    @objc func showNoFreeSpotAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error".localized(), message: "It seems there are no free places in this location at the moment".localized(), preferredStyle: .alert)
            alert.view.tintColor = UIColor(named: "ExpressFocus")!
            alert.addAction(UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func showFreeSpot() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    func getPercentageFrom(totalSpots: Int, freeSpots: Int) -> Int {
        return 100-Int(Float(freeSpots)/Float(totalSpots) * 100)
    }

}
extension ExpressPickViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkLocations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpressPickCell") as! ExpressPickCell
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

        let occupancyPercent = self.getPercentageFrom(totalSpots: parkLocations[indexPath.row].totalSpots, freeSpots: parkLocations[indexPath.row].freeSpots)
        
        if occupancyPercent == 100 {
            cell.gaugeIcon.transform = .identity
            cell.gaugeIcon.transform = cell.gaugeIcon.transform.rotated(by: 2.356)
        } else if 85 < occupancyPercent && occupancyPercent < 100 {
            cell.gaugeIcon.transform = .identity
            cell.gaugeIcon.transform = cell.gaugeIcon.transform.rotated(by: 0.785)
        } else if 60 < occupancyPercent && occupancyPercent < 85 {
            cell.gaugeIcon.transform = .identity
            cell.gaugeIcon.transform = cell.gaugeIcon.transform.rotated(by: 0)
        } else if 40 < occupancyPercent && occupancyPercent < 60 {
            cell.gaugeIcon.transform = .identity
            cell.gaugeIcon.transform = cell.gaugeIcon.transform.rotated(by: -0.785)
        } else if 20 < occupancyPercent && occupancyPercent < 40 {
            cell.gaugeIcon.transform = .identity
            cell.gaugeIcon.transform = cell.gaugeIcon.transform.rotated(by: -1.570)
        } else {
            cell.gaugeIcon.transform = .identity
            cell.gaugeIcon.transform = cell.gaugeIcon.transform.rotated(by: -2.356)
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        selectedParkLocationIndex = indexPath.row
        FunctionsManager.sharedInstance.foundSpot = nil
        FunctionsManager.sharedInstance.expressReserveInLocation(sectionIndex: 0, location: parkLocations[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ExpressPickCell
        cell.card.backgroundColor = UIColor(named: "Highlight Secondary Detail")
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ExpressPickCell
        cell.card.backgroundColor = UIColor(named: "Secondary Detail")
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath) as! ExpressPickCell
        
        let config = UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchPreviewVC") as! SearchPreviewController
            vc.preferredContentSize = CGSize(width: cell.frame.width, height: 250)
            
            vc.previewLocationName = parkLocations[indexPath.row].name
            vc.previewLocationDistance = cell.distanceLbl.text ?? "- km"
            vc.previewLocationFreeSpots = parkLocations[indexPath.row].freeSpots
            vc.previewLocationSections = parkLocations[indexPath.row].sections.count
            vc.previewLocationCoords = CLLocationCoordinate2D(latitude: parkLocations[indexPath.row].latitude, longitude: parkLocations[indexPath.row].longitude)
            vc.previewLocationColorName = "ExpressFocus"
            vc.previewLocationColor = UIColor(named: "ExpressFocus")!
            
            
            return vc
        }, actionProvider: nil)
        
        
        return config
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        let indexPath = configuration.identifier as! IndexPath
        selectedParkLocationIndex = indexPath.row
        FunctionsManager.sharedInstance.foundSpot = nil
        FunctionsManager.sharedInstance.expressReserveInLocation(sectionIndex: 0, location: parkLocations[indexPath.row])
    }
}
