//
//  VIPInfoViewController.swift
//  Roadout
//
//  Created by David Retegan on 25.05.2023.
//

import UIKit

class VIPInfoViewController: UIViewController {

    let subscribeTitle = NSAttributedString(string: "Subscribe to VIP".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let cancelTitle = NSAttributedString(
        string: "Cancel".localized(),
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.Roadout.goldBrown, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
    )
    
    let icons = ["car_parking_dashed", "banknote", "web_camera"]
    let titles = ["Premium Parkings".localized(), "Universal Price".localized(), "Car Security".localized()]
    let descriptions = ["Enjoy an array of premium, central parkings, only available to VIP users".localized(), "With your subscription you can enjoy 2 hours of free parking each day and extra hours at one universal fee for all VIP parkings".localized(), "All premium parkings are enclosed and only you will be able to unlock their gates, thus making sure your vehicle is safe".localized()]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var subscribeBtn: UXButton!
    @IBAction func subscribeTapped(_ sender: Any) {
    
    }
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeBtn.layer.cornerRadius = 13.0
        subscribeBtn.setAttributedTitle(subscribeTitle, for: .normal)
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}
extension VIPInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VIPInfoCell") as! VIPInfoCell
        cell.titleLabel.text = titles[indexPath.row]
        cell.infoLabel.text = descriptions[indexPath.row]
        cell.iconImage.image = UIImage(named: self.icons[indexPath.row])!
        
        return cell
    }
    
}
