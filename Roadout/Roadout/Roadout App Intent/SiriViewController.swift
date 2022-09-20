//
//  SiriViewController.swift
//  Roadout
//
//  Created by David Retegan on 18.09.2022.
//

import UIKit

class SiriViewController: UIViewController {

    let icons = ["waveform", "bolt.fill", "hand.point.up.fill"]
    let titles = ["Hands-free".localized(), "Fast & Accurate".localized(), "Intuitive".localized()]
    let descriptions = [
        "Just ask Siri to find and reserve the nearest parking spot near you using Roadout, no other interaction required".localized(),
        "Roadout will find the best spot everytime and make sure to keep it free during your reservation".localized(),
        "No set-up required, just say 'Hey Siri, ask Roadout to find somewhere to park', that's it".localized()
    ]
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var okBtn: UIButton!
    @IBAction func okTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    let okTitle = NSAttributedString(string: "OK".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "Use with Siri".localized()
        okBtn.layer.cornerRadius = 13.0
        okBtn.setAttributedTitle(okTitle, for: .normal)
        
        descriptionLbl.text = "Only on iOS 16.0 or newer".localized()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

}
extension SiriViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SiriCell") as! SiriCell
        cell.titleLabel.text = titles[indexPath.row]
        cell.infoLabel.text = descriptions[indexPath.row]
        cell.iconImage.image = UIImage(systemName: icons[indexPath.row])!
        
        return cell
    }
    
}
