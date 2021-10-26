//
//  HomeViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var searchBar: UIView!
    
    @IBAction func searchTapped(_ sender: Any) {
        print("Search")
    }
    @IBAction func settingsTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
        self.presentDetail(vc)
    }
    
    @IBOutlet weak var searchTapArea: UIButton!
    @IBOutlet weak var settingsTapArea: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTapArea.setTitle("", for: .normal)
        settingsTapArea.setTitle("", for: .normal)
        
        searchBar.layer.cornerRadius = 13.0
        
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOpacity = 0.1
        searchBar.layer.shadowOffset = .zero
        searchBar.layer.shadowRadius = 10
        searchBar.layer.shadowPath = UIBezierPath(rect: searchBar.bounds).cgPath
        searchBar.layer.shouldRasterize = true
        searchBar.layer.rasterizationScale = UIScreen.main.scale
        
    }
    

}
