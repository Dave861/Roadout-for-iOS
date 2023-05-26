//
//  VIPIncludedViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.05.2023.
//

import UIKit

class VIPIncludedViewController: UIViewController {
    
    let featureDescriptions = ["Access to premium enclosed parkings with 24/7 surveillance", "24 hours free in any parking of your choice every month", "Fixed price in VIP Parkings, always pay the same regardless of demand", "Support priority, never wait in a queue to get in touch with us"]
    
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
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension VIPIncludedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featureDescriptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VIPIncludedCell") as! VIPIncludedCell
        cell.featureLbl.text = featureDescriptions[indexPath.row]
        
        if indexPath.row == featureDescriptions.count-1 {
            cell.separatorView.isHidden = true
        }
        
        return cell
    }
}
