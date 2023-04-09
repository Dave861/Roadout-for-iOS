//
//  ExpressChooseViewController.swift
//  Roadout
//
//  Created by David Retegan on 19.07.2022.
//

import UIKit
import CoreLocation

class ExpressChooseViewController: UIViewController {
    
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.Roadout.expressFocus, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    let editLocationTitle = NSAttributedString(string: " " + "Edit Locations".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.Roadout.devBrown, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderText: UILabel!
    @IBOutlet weak var placeholderAddBtn: UIButton!
    
    @IBAction func placeholderAddTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddExpressVC") as! AddExpressViewController
        self.present(vc, animated: true)
    }
    
    @IBOutlet weak var editLocationBtn: UIButton!
    
    @IBAction func addLocationTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddExpressVC") as! AddExpressViewController
        self.present(vc, animated: true)
    }
    
    //MARK: - View Configuration -
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(showFreeSpot), name: .showExpressLaneFreeSpotID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getFavouriteLocations), name: .reloadExpressLocationsID, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        manageObs()
        
        titleLbl.text = "Choose".localized()
        
        cancelButton.setAttributedTitle(cancelTitle, for: .normal)
        editLocationBtn.setAttributedTitle(editLocationTitle, for: .normal)
        
        placeholderAddBtn.setTitle("Tap here to add".localized(), for: .normal)
        placeholderText.text = "You haven’t added any locations to Express Lane".localized()
        
        getFavouriteLocations()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        reloadScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.shownTip3") == false {
             titleLbl.tooltip(TutorialView3.instanceFromNib(), orientation: Tooltip.Orientation.top, configuration: { configuration in
                 
                 configuration.backgroundColor = UIColor(named: "Card Background")!
                 configuration.shadowConfiguration.shadowOpacity = 0.1
                 configuration.shadowConfiguration.shadowColor = UIColor.black.cgColor
                 configuration.shadowConfiguration.shadowOffset = .zero
                 
                 return configuration
             })
             UserDefaults.roadout!.set(true, forKey: "ro.roadout.Roadout.shownTip3")
         }
    }
    
    //MARK: - Data Functions -
    
    @objc func getFavouriteLocations() {
        favouriteLocationIDs = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.Roadout.favouriteLocationIDs") ?? [String]()
        favouriteLocations = [ParkLocation]()
        for location in parkLocations {
            if favouriteLocationIDs.contains(location.rID) {
                favouriteLocations.append(location)
            }
        }
        self.reloadScreen()
    }
    
    func removeFromFavouriteLocations(_ locationID: String) {
        favouriteLocationIDs = favouriteLocationIDs.remove(locationID)
        UserDefaults.roadout!.set(favouriteLocationIDs, forKey: "ro.roadout.Roadout.favouriteLocationIDs")
        getFavouriteLocations()
    }
    
    func reloadScreen() {
        if favouriteLocations.count == 0 {
            placeholderView.isHidden = false
            tableView.isHidden = true
            editLocationBtn.isHidden = true
        } else {
            placeholderView.isHidden = true
            tableView.isHidden = false
            editLocationBtn.isHidden = false
            tableView.reloadData()
        }
    }
    
    func showNoFreeSpotAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error".localized(), message: "It seems there are no free spots in this location at the moment".localized(), preferredStyle: .alert)
            alert.view.tintColor = UIColor.Roadout.expressFocus
            alert.addAction(UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func showFreeSpot() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
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
    
    func findFavouriteIndexInParkLocations(_ favouriteID: String) -> Int {
        for ind in 0...parkLocations.count-1 {
            if parkLocations[ind].rID == favouriteID {
                return ind
            }
        }
        return 0
    }

}
extension ExpressChooseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteLocations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpressChooseCell") as! ExpressChooseCell
        cell.nameLbl.text = favouriteLocations[indexPath.row].name
        let coord = CLLocationCoordinate2D(latitude: favouriteLocations[indexPath.row].latitude, longitude: favouriteLocations[indexPath.row].longitude)
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

        let occupancyPercent = self.getPercentageFrom(totalSpots: favouriteLocations[indexPath.row].totalSpots, freeSpots: favouriteLocations[indexPath.row].freeSpots)
        
        cell.gaugeIcon.transform = .identity
        cell.gaugeIcon.transform = cell.gaugeIcon.transform.rotated(by: self.getRotationFor(occupancyPercent))

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        //load here
        selectedParkLocationIndex = findFavouriteIndexInParkLocations(favouriteLocations[indexPath.row].rID)
        FunctionsManager.sharedInstance.foundLocation = parkLocations[selectedParkLocationIndex]
        Task {
            do {
                try await FunctionsManager.sharedInstance.findSpotInLocationAsync(location: favouriteLocations[indexPath.row])
                DispatchQueue.main.async {
                    //stop here
                    NotificationCenter.default.post(name: .addSpotMarkerID, object: nil)
                    NotificationCenter.default.post(name: .addExpressViewID, object: nil)
                    NotificationCenter.default.post(name: .showExpressLaneFreeSpotID, object: nil)
                }
            } catch let err {
                //stop here
                self.showNoFreeSpotAlert()
                print(err)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ExpressChooseCell
        cell.card.backgroundColor = UIColor(named: "Highlight Secondary Detail")
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ExpressChooseCell
        cell.card.backgroundColor = UIColor(named: "Secondary Detail")
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath) as! ExpressChooseCell
        
        let config = UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchPreviewVC") as! SearchPreviewController
            vc.preferredContentSize = CGSize(width: cell.frame.width, height: 250)
            
            vc.previewLocationName = favouriteLocations[indexPath.row].name
            vc.previewLocationDistance = cell.distanceLbl.text ?? "- km"
            vc.previewLocationFreeSpots = favouriteLocations[indexPath.row].freeSpots
            vc.previewLocationSections = favouriteLocations[indexPath.row].sections.count
            vc.previewLocationCoords = CLLocationCoordinate2D(latitude: favouriteLocations[indexPath.row].latitude, longitude: favouriteLocations[indexPath.row].longitude)
            vc.previewLocationColorName = "ExpressFocus"
            vc.previewLocationColor = UIColor.Roadout.expressFocus
            
            
            return vc
        }, actionProvider: nil)
        
        
        return config
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        let indexPath = configuration.identifier as! IndexPath
        
        //load here
        selectedParkLocationIndex = findFavouriteIndexInParkLocations(favouriteLocations[indexPath.row].rID)
        FunctionsManager.sharedInstance.foundLocation = parkLocations[selectedParkLocationIndex]
        Task {
            do {
                try await FunctionsManager.sharedInstance.findSpotInLocationAsync(location: favouriteLocations[indexPath.row])
                DispatchQueue.main.async {
                    //stop here
                    NotificationCenter.default.post(name: .addSpotMarkerID, object: nil)
                    NotificationCenter.default.post(name: .addExpressViewID, object: nil)
                    NotificationCenter.default.post(name: .showExpressLaneFreeSpotID, object: nil)
                }
            } catch let err {
                //stop here
                self.showNoFreeSpotAlert()
                print(err)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "  Remove".localized()) { _, _, completion in
            self.removeFromFavouriteLocations(favouriteLocations[indexPath.row].rID)
            completion(true)
        }
        deleteAction.backgroundColor = UIColor(named: "Second Background")!
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
    
}
