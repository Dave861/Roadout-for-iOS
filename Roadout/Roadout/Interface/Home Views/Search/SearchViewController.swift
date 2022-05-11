//
//  SearchViewController.swift
//  Roadout
//
//  Created by David Retegan on 27.10.2021.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    
    var results = parkLocations
    var smartApplied = true
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var searchBar: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Main Yellow")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var modesButton: UIButton!
    
    @IBAction func modesTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Search Settings".localized(), preferredStyle: .actionSheet)
        
        let smartAction = UIAlertAction(title: "Smart Search".localized(), style: .default) { action in
            self.smartApplied = true
            self.tableView.reloadData()
        }
        smartAction.setValue(UIColor(named: "Main Yellow")!, forKey: "titleTextColor")
        
        let classicAction = UIAlertAction(title: "Classic Search".localized(), style: .default) { action in
            self.smartApplied = false
            self.tableView.reloadData()
        }
        classicAction.setValue(UIColor(named: "Icons")!, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Greyish")!, forKey: "titleTextColor")
        
        alert.addAction(smartAction)
        alert.addAction(classicAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeModesMenu() -> UIMenu {
        let smartAction = UIAction(title: "Smart Search".localized(), image: nil, state: smartApplied ? .on : .off, handler: { (_) in
            self.smartApplied = true
            if #available(iOS 14.0, *) {
                self.modesButton.menu = self.makeModesMenu()
                self.modesButton.showsMenuAsPrimaryAction = true
            }
            self.tableView.reloadData()
        })
        let classicAction = UIAction(title: "Classic Search".localized(), image: nil, state: smartApplied ? .off : .on, handler: { (_) in
            self.smartApplied = false
            if #available(iOS 14.0, *) {
                self.modesButton.menu = self.makeModesMenu()
                self.modesButton.showsMenuAsPrimaryAction = true
            }
            self.tableView.reloadData()
        })
        return UIMenu(title: "Search Settings".localized(), image: nil, identifier: nil, options: [], children: [classicAction, smartAction])
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.cornerRadius = 12.0
        card.clipsToBounds = true
        card.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        reloadFreeSpots()
        
        cancelButton.setAttributedTitle(cancelTitle, for: .normal)
        modesButton.setTitle("", for: .normal)
        
        if #available(iOS 14.0, *) {
            modesButton.menu = makeModesMenu()
            modesButton.showsMenuAsPrimaryAction = true
        }
        
        searchBar.layer.cornerRadius = 13.0
        
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOpacity = 0.1
        searchBar.layer.shadowOffset = .zero
        searchBar.layer.shadowRadius = 10
        searchBar.layer.shadowPath = UIBezierPath(rect: searchBar.bounds).cgPath
        searchBar.layer.shouldRasterize = true
        searchBar.layer.rasterizationScale = UIScreen.main.scale
        
        searchField.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if smartApplied {
            guard let query = searchField.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                  self.bruteFind() { success in
                      if success {
                          self.tableView.reloadData()
                      }
                  }
                  return
            }
            let adjustedQuery = "Cluj-Napoca, " + query
            SearchManager.sharedInstance.startSearching(query: adjustedQuery) { result in
                switch result {
                    case .success(let searchCoordinates):
                        print("\(searchCoordinates.latitude), \(searchCoordinates.longitude)")
                    self.findByCoordinate(coords: searchCoordinates) { success in
                        if success {
                            self.tableView.reloadData()
                        }
                    }
                    case .failure(let err):
                        print(err.localizedDescription)
                        self.bruteFind() { success in
                            if success {
                                self.tableView.reloadData()
                            }
                        }
                }
            }
        } else {
            self.bruteFind() { success in
                if success {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func bruteFind(completion: (_ success: Bool) -> Void) {
        if searchField.text == "" {
            results = parkLocations
        } else {
            results = parkLocations.filter { $0.name.localizedCaseInsensitiveContains(searchField.text!) }
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
        
        results = sortedArray
        completion(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchField.becomeFirstResponder()
    }
    
    func reloadFreeSpots() {
        for index in 0...parkLocations.count-1 {
            EntityManager.sharedInstance.getFreeParkSpots(parkLocations[index].rID, index) { result in
                switch result {
                    case .success():
                        print("Got it")
                    case .failure(let err):
                        print(err)
                }
            }
        }
    }

    
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
        cell.nameLbl.text = results[indexPath.row].name
        let coord = CLLocationCoordinate2D(latitude: results[indexPath.row].latitude, longitude: results[indexPath.row].longitude)
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
        cell.numberLbl.text = "\(results[indexPath.row].freeSpots)"
        let color = UIColor(named: results[indexPath.row].accentColor)!
        cell.numberLbl.textColor = color
        cell.spotsLbl.textColor = color
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        selectedLocationName = results[indexPath.row].name
        selectedLocationCoord = CLLocationCoordinate2D(latitude: results[indexPath.row].latitude, longitude: results[indexPath.row].longitude)
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        selectedLocationColor = cell.numberLbl.textColor
        NotificationCenter.default.post(name: .addResultCardID, object: nil)
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
}
