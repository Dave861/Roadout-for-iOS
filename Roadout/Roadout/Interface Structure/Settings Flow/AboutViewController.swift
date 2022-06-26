//
//  AboutViewController.swift
//  Roadout
//
//  Created by David Retegan on 23.04.2022.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var easterEggLbl: UILabel!
    
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var websiteCard: UIView!
    @IBOutlet weak var appCard: UIView!
    @IBOutlet weak var otherCard: UIView!
    
    @IBAction func websiteTapped(_ sender: Any) {
        if let url = URL(string: "https://www.roadout.ro") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBOutlet weak var findWayIcon: UIImageView!
    @IBOutlet weak var expressLaneIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        websiteCard.layer.cornerRadius = 12.0
        appCard.layer.cornerRadius = 12.0
        otherCard.layer.cornerRadius = 12.0
        
        logoImage.layer.cornerRadius = logoImage.frame.height * 10/53
        findWayIcon.layer.cornerRadius = logoImage.frame.height * 10/53
        expressLaneIcon.layer.cornerRadius = logoImage.frame.height * 10/53
        
        localizeLabels()
    }
    
    func localizeLabels() {
        self.titleLbl.text = "About".localized()
        self.easterEggLbl.text = "Roadout\nMade in Cluj".localized()
        self.backButton.setTitle("Back".localized(), for: .normal)
    }

}
