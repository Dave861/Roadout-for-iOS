//
//  ARViewController.swift
//  Roadout
//
//  Created by David Retegan on 18.06.2022.
//

import UIKit

class ARViewController: UIViewController {
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var soonLbl: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var compassArrow: UIImageView!
    @IBOutlet weak var distanceLbl: UILabel!
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.cornerRadius = 19.0
        closeButton.setTitle("", for: .normal)
        closeButton.layer.cornerRadius = closeButton.frame.height/2
        titleLbl.text = "AR Directions".localized()
        soonLbl.text = "Coming Soon...".localized()
        fillLabels()
        styleDetailsLbl()
    }
    
    func styleDetailsLbl() {
        self.detailsLbl.set(textColor: UIColor(named: "Kinda Red")!, range: self.detailsLbl.range(after: "Section ".localized(), before: " - Spot ".localized()))
        self.detailsLbl.set(textColor: UIColor(named: "Kinda Red")!, range: self.detailsLbl.range(after: " - Spot ".localized()))
        self.detailsLbl.set(font: .systemFont(ofSize: 19.0, weight: .medium), range: self.detailsLbl.range(after: "Section ".localized(), before: " - Spot ".localized()))
        self.detailsLbl.set(font: .systemFont(ofSize: 19.0, weight: .medium), range: self.detailsLbl.range(after: " - Spot ".localized()))
    }
    
    func fillLabels() {
        self.locationLbl.text = EntityManager.sharedInstance.decodeSpotID(selectedSpotID)[0]
        self.detailsLbl.text = "Section ".localized() + EntityManager.sharedInstance.decodeSpotID(selectedSpotID)[1] + " - Spot ".localized() + EntityManager.sharedInstance.decodeSpotID(selectedSpotID)[2]
    }

}
