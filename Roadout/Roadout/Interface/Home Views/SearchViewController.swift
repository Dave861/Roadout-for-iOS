//
//  SearchViewController.swift
//  Roadout
//
//  Created by David Retegan on 27.10.2021.
//

import UIKit

let parkNames = ["Buna Ziua", "Airport", "Marasti", "Old Town", "21 Decembrie", "Mihai Viteazu", "Eroilor", "Gheorgheni", "Manastur"]
let parkLatitudes = [46.752207, 46.781864, 46.782288, 46.772051, 46.772798, 46.775235, 46.769916, 46.768776, 46.758061]
let parkLongitudes = [23.603324, 23.671744, 23.613756, 23.587260, 23.594725, 23.590412, 23.593454, 23.618535, 23.554228]

class SearchViewController: UIViewController {
    
    var results = ["Buna Ziua", "Airport", "Marasti", "Old Town", "21 Decembrie", "Mihai Viteazu", "Eroilor", "Gheorgheni", "Manastur"]
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
        print("Changed")
        if searchField.text == "" {
            results = parkNames
        } else {
            results = parkNames.filter { $0.localizedCaseInsensitiveContains(searchField.text!) }
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
        cell.nameLbl.text = results[indexPath.row]
        cell.distanceLbl.text = "\(Int.random(in: 1..<10)) km"
        cell.numberLbl.text = "\(Int.random(in: 5..<30))"
        let color = UIColor(named: colors.randomElement() ?? "Main Yellow")
        cell.numberLbl.textColor = color
        cell.spotsLbl.textColor = color
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        selectedLocation = results[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        selectedLocationColor = cell.numberLbl.textColor
        NotificationCenter.default.post(name: Notification.Name(addResultCardID), object: nil)
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
}
