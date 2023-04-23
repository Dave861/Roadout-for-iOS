//
//  SearchViewController.swift
//  Roadout
//
//  Created by David Retegan on 27.10.2021.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    
    var searchResults = parkLocations
    var smartSearchApplied = true
    
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.Roadout.mainYellow, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    //MARK: - IBOutlets -
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var searchTitle: UILabel!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchBar: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var modesButton: UIButton!
    @IBAction func modesTapped(_ sender: Any) {}
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderLbl: UILabel!
    
    func makeModesMenu() -> UIMenu {
        let smartAction = UIAction(title: "Smart Search".localized(), image: nil, state: smartSearchApplied ? .on : .off, handler: { (_) in
            self.smartSearchApplied = true
            self.modesButton.menu = self.makeModesMenu()
            self.modesButton.showsMenuAsPrimaryAction = true
            self.tableView.reloadData()
        })
        let classicAction = UIAction(title: "Classic Search".localized(), image: nil, state: smartSearchApplied ? .off : .on, handler: { (_) in
            self.smartSearchApplied = false
            self.modesButton.menu = self.makeModesMenu()
            self.modesButton.showsMenuAsPrimaryAction = true
            self.tableView.reloadData()
        })
        return UIMenu(title: "Search Settings".localized(), image: nil, identifier: nil, options: [], children: [classicAction, smartAction])
    }
    
    //MARK: - View Configuration -
        
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTitle.text = "Search".localized()
        
        card.layer.cornerRadius = 12.0
        card.clipsToBounds = true
        card.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        Task {
            await self.reloadFreeSpots()
        }
        
        cancelButton.setAttributedTitle(cancelTitle, for: .normal)
        modesButton.setTitle("", for: .normal)
        modesButton.layer.cornerRadius = 14.0
        
        modesButton.menu = makeModesMenu()
        modesButton.showsMenuAsPrimaryAction = true
        
        searchBar.layer.cornerRadius = 17.0
        
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOpacity = 0.1
        searchBar.layer.shadowOffset = .zero
        searchBar.layer.shadowRadius = 10
        searchBar.layer.shadowPath = UIBezierPath(rect: searchBar.bounds).cgPath
        searchBar.layer.shouldRasterize = true
        searchBar.layer.rasterizationScale = UIScreen.main.scale
        
        searchField.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: .editingChanged)
        searchField.attributedPlaceholder = NSAttributedString(string: "Search for a Location...".localized(),
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        
        placeholderView.alpha = 0
        placeholderLbl.text = "Wow, not so quick! You might be looking for a place that doesn't exist".localized()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchField.becomeFirstResponder()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
        }
    }
    
    //MARK: - Search Query -
    @objc func textFieldDidChange(_ textField: UITextField) {
        if smartSearchApplied {
            guard let query = searchField.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                  self.bruteFind() { success in
                      if success {
                          self.tableView.reloadData()
                          if searchResults.count == 0 {
                              self.placeholderView.alpha = 1
                          } else {
                              self.placeholderView.alpha = 0
                          }
                      }
                  }
                  return
            }
            let adjustedQuery = "Cluj-Napoca, " + query
            SearchManager.sharedInstance.startSearching(query: adjustedQuery) { result in
                switch result {
                    case .success(let searchCoordinates):
                        self.findByCoordinate(coords: searchCoordinates) { success in
                            if success {
                                self.tableView.reloadData()
                                if self.searchResults.count == 0 {
                                    self.placeholderView.alpha = 1
                                } else {
                                    self.placeholderView.alpha = 0
                                }
                            }
                        }
                    case .failure(_):
                        self.bruteFind() { success in
                            if success {
                                self.tableView.reloadData()
                                if self.searchResults.count == 0 {
                                    self.placeholderView.alpha = 1
                                } else {
                                    self.placeholderView.alpha = 0
                                }
                            }
                        }
                }
            }
        } else {
            self.bruteFind() { success in
                if success {
                    self.tableView.reloadData()
                    if self.searchResults.count == 0 {
                        self.placeholderView.alpha = 1
                    } else {
                        self.placeholderView.alpha = 0
                    }
                }
            }
        }
    }
    
    func bruteFind(completion: (_ success: Bool) -> Void) {
        if searchField.text == "" {
            searchResults = parkLocations
        } else {
            searchResults = parkLocations.filter { $0.name.localizedCaseInsensitiveContains(searchField.text!) }
        }
        completion(true)
    }
    
    func findByCoordinate(coords: CLLocationCoordinate2D, completion: (_ success: Bool) -> Void) {
        let foundLocation = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
        var dictArray = [[String: Any]]()
        for i in 0..<parkLocations.count {
            let loc = CLLocation(latitude: parkLocations[i].latitude, longitude: parkLocations[i].longitude)
            let distanceInMeters = foundLocation.distance(from: loc)
            let a:[String: Any] = ["distance": distanceInMeters, "location": parkLocations[i]]
            dictArray.append(a)
        }
        dictArray = dictArray.sorted(by: {($0["distance"] as! CLLocationDistance) < ($1["distance"] as! CLLocationDistance)})
        
        var sortedArray = [ParkLocation]()
        for i in dictArray{
            sortedArray.append(i["location"] as! ParkLocation)
        }
        
        searchResults = sortedArray
        completion(true)
    }
    
    //MARK: - Occupancy Functions -
    
    func reloadFreeSpots() async {
        for pI in 0...parkLocations.count-1 {
            do {
                try await EntityManager.sharedInstance.updateFreeParkSpotsAsync(parkLocations[pI].rID, pI)
            } catch let err {
                print(err.localizedDescription)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getPercentageFrom(totalSpots: Int, freeSpots: Int) -> Int {
        return 100-Int(Float(freeSpots)/Float(totalSpots) * 100)
    }
    
    func dismissScreen() {
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
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

    
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
        cell.nameLbl.text = searchResults[indexPath.row].name
        let coord = CLLocationCoordinate2D(latitude: searchResults[indexPath.row].latitude, longitude: searchResults[indexPath.row].longitude)
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
        let color = UIColor(named: searchResults[indexPath.row].accentColor)!
        cell.gaugeIcon.image = cell.gaugeIcon.image?.withRenderingMode(.alwaysTemplate)
        cell.gaugeIcon.tintColor = color
        cell.distanceIcon.tintColor = color
        
        let occupancyPercent = self.getPercentageFrom(totalSpots: searchResults[indexPath.row].totalSpots, freeSpots: searchResults[indexPath.row].freeSpots)
        
        cell.gaugeIcon.transform = .identity
        cell.gaugeIcon.transform = cell.gaugeIcon.transform.rotated(by: self.getRotationFor(occupancyPercent))

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        selectedLocation.name = searchResults[indexPath.row].name
        selectedLocation.latitude = searchResults[indexPath.row].latitude
        selectedLocation.longitude = searchResults[indexPath.row].longitude
        selectedLocation.accentColor = searchResults[indexPath.row].accentColor
        NotificationCenter.default.post(name: .addResultCardID, object: nil)
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        cell.card.backgroundColor = UIColor(named: "Highlight Secondary Detail")
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        cell.card.backgroundColor = UIColor(named: "Secondary Detail")
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        
        let config = UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchPreviewVC") as! SearchPreviewController
            vc.preferredContentSize = CGSize(width: cell.frame.width, height: 250)
            
            vc.previewLocationName = self.searchResults[indexPath.row].name
            vc.previewLocationDistance = cell.distanceLbl.text ?? "- km"
            vc.previewLocationFreeSpots = self.searchResults[indexPath.row].freeSpots
            vc.previewLocationSections = self.searchResults[indexPath.row].sections.count
            vc.previewLocationCoords = CLLocationCoordinate2D(latitude: self.searchResults[indexPath.row].latitude, longitude: self.searchResults[indexPath.row].longitude)
            vc.previewLocationColorName = self.searchResults[indexPath.row].accentColor
            vc.previewLocationColor = cell.gaugeIcon.tintColor
            
            
            return vc
        }, actionProvider: nil)
        
        
        return config
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        let indexPath = configuration.identifier as! IndexPath
        selectedLocation.name = searchResults[indexPath.row].name
        selectedLocation.latitude = searchResults[indexPath.row].latitude
        selectedLocation.longitude = searchResults[indexPath.row].longitude
        selectedLocation.accentColor = searchResults[indexPath.row].accentColor
        NotificationCenter.default.post(name: .addResultCardID, object: nil)
        self.dismiss(animated: false) {
            self.dismissScreen()
        }
    }
}
