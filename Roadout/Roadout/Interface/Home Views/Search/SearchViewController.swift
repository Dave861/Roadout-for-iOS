//
//  SearchViewController.swift
//  Roadout
//
//  Created by David Retegan on 27.10.2021.
//

import UIKit
import CoreLocation


let parkLocations = [ParkLocation(name: "Buna Ziua", latitude: 46.752207, longitude: 23.603324, freeSpots: 11),
                 ParkLocation(name: "Airport", latitude: 46.781864, longitude: 23.671744, freeSpots: 7),
                 ParkLocation(name: "Marasti", latitude: 46.782288, longitude: 23.613756, freeSpots: 15),
                 ParkLocation(name: "Old Town", latitude: 46.772051, longitude: 23.587260, freeSpots: 22),
                 ParkLocation(name: "21 Decembrie", latitude: 46.772798, longitude: 23.594725, freeSpots: 35),
                 ParkLocation(name: "Mihai Viteazu", latitude: 46.775235, longitude: 23.590412, freeSpots: 18),
                 ParkLocation(name: "Eroilor", latitude: 46.769916, longitude: 23.593454, freeSpots: 9),
                 ParkLocation(name: "Gheorgheni", latitude: 46.768776, longitude: 23.618535, freeSpots: 26),
                 ParkLocation(name: "Manastur", latitude: 46.758061, longitude: 23.554228, freeSpots: 13),
                 ParkLocation(name: "Andrei Muresanu", latitude: 46.758449, longitude: 23.606643, freeSpots: 39)]

class SearchViewController: UIViewController {
    
    var results = parkLocations
    let colors = ["Main Yellow", "Redish", "Dark Yellow", "Brownish", "Icons", "Greyish", "Second Orange", "Dark Orange"]
    
    let addResultCardID = "ro.roadout.Roadout.addResultCardID"

    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var searchBar: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    
    let cancelTitle = NSAttributedString(string: "Cancel", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Main Yellow")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.cornerRadius = 12.0
        card.clipsToBounds = true
        card.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        cancelButton.setAttributedTitle(cancelTitle, for: .normal)
        
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
        if searchField.text == "" {
            results = parkLocations
        } else {
            results = parkLocations.filter { $0.name.localizedCaseInsensitiveContains(searchField.text!) }
        }
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchField.becomeFirstResponder()
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
        cell.numberLbl.text = "\(Int.random(in: 5..<30))"
        let color = UIColor(named: colors.randomElement() ?? "Main Yellow")
        cell.numberLbl.textColor = color
        cell.spotsLbl.textColor = color
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        selectedLocation = results[indexPath.row].name
        selectedLocationCoord = CLLocationCoordinate2D(latitude: results[indexPath.row].latitude, longitude: results[indexPath.row].longitude)
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        selectedLocationColor = cell.numberLbl.textColor
        NotificationCenter.default.post(name: Notification.Name(addResultCardID), object: nil)
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
}
