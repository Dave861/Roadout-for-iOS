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
    let colors = ["Main Yellow", "Redish", "Dark Yellow", "Brownish", "Icons", "Greyish", "Second Orange", "Dark Orange"]
    
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
    
    @IBOutlet weak var moreButton: UIButton!
    
    @IBAction func moreTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        let findAction = UIAlertAction(title: "Find Spot", style: .default) { action in
            guard currentLocationCoord != nil else { return }
            FunctionsManager.sharedInstance.findSpot(currentLocationCoord!) { success in
                if success {
                    self.dismiss(animated: false, completion: nil)
                    NotificationCenter.default.post(name: .showFindCardID, object: nil)
                } else {
                    //MANAGE
                }
            }

        }
        findAction.setValue(UIColor(named: "Brownish")!, forKey: "titleTextColor")
        
        let expressAction = UIAlertAction(title: "Express Reserve", style: .default) { action in
            self.dismiss(animated: false, completion: nil)
            NotificationCenter.default.post(name: .addExpressPickViewID, object: nil)
        }
        expressAction.setValue(UIColor(named: "Dark Orange")!, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Greyish")!, forKey: "titleTextColor")
        
        alert.addAction(findAction)
        alert.addAction(expressAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Find Spot", image: UIImage(systemName: "loupe"), handler: { (_) in
                
                guard currentLocationCoord != nil else { return }
                FunctionsManager.sharedInstance.findSpot(currentLocationCoord!) { success in
                    if success {
                        self.dismiss(animated: false, completion: nil)
                        NotificationCenter.default.post(name: .showFindCardID, object: nil)
                    } else {
                        //MANAGE
                    }
                }
            }),
            UIAction(title: "Express Reserve", image: UIImage(systemName: "flag.2.crossed"), handler: { (_) in
                self.dismiss(animated: false, completion: nil)
                NotificationCenter.default.post(name: .addExpressPickViewID, object: nil)
            }),
        ]
    }
    var moreMenu: UIMenu {
        return UIMenu(title: "What would you like to do?", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.cornerRadius = 12.0
        card.clipsToBounds = true
        card.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        cancelButton.setAttributedTitle(cancelTitle, for: .normal)
        moreButton.setTitle("", for: .normal)
        
        if #available(iOS 14.0, *) {
            moreButton.menu = moreMenu
            moreButton.showsMenuAsPrimaryAction = true
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
        cell.numberLbl.text = "\(results[indexPath.row].freeSpots)"
        let color = UIColor(named: colors.randomElement() ?? "Main Yellow")
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
