//
//  ARDirectionsViewController.swift
//  Roadout
//
//  Created by David Retegan on 12.12.2022.
//

import UIKit

class ARDirectionsViewController: UIViewController {
    
    var distance = 10
    var direction = "left".localized()
    
    //Background components
    @IBOutlet weak var backgroundCard: UIView!
    @IBOutlet weak var floatingCard: UIView!
    
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var questionBtn: UIButton!
  
    @IBAction func infoTapped(_ sender: Any) {
        ARManager.sharedInstance.helpMode = .info
        let vc = storyboard?.instantiateViewController(withIdentifier: "ARHelpVC") as! ARHelpViewController
        self.present(vc, animated: true)
    }
    @IBAction func questionsTapped(_ sender: Any) {
        ARManager.sharedInstance.helpMode = .questions
        let vc = storyboard?.instantiateViewController(withIdentifier: "ARHelpVC") as! ARHelpViewController
        self.present(vc, animated: true)
    }
    
    //Card components
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var arrivedBtn: UIButton!
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var directionLbl: UILabel!
    
    @IBAction func closeTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .removeReservationCardID, object: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func arrivedTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .addUnlockCardID, object: nil)
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        styleBackground()
        styleForeground()
        updateInfoLabels()
    }
    
    func styleBackground() {
        backgroundCard.layer.cornerRadius = 12.0
        backgroundCard.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        infoBtn.setTitle("", for: .normal)
        questionBtn.setTitle("", for: .normal)
        
        infoBtn.layer.cornerRadius = infoBtn.frame.height/2
        questionBtn.layer.cornerRadius = questionBtn.frame.height/2
    }
    
    func styleForeground() {
        floatingCard.layer.cornerRadius = 17.0
        
        floatingCard.layer.shadowColor = UIColor.black.cgColor
        floatingCard.layer.shadowOpacity = 0.15
        floatingCard.layer.shadowOffset = .zero
        floatingCard.layer.shadowRadius = 17.0
        floatingCard.layer.shadowPath = UIBezierPath(rect: floatingCard.bounds).cgPath
        floatingCard.layer.shouldRasterize = true
        floatingCard.layer.rasterizationScale = UIScreen.main.scale
        
        closeBtn.setTitle("", for: .normal)
        closeBtn.layer.cornerRadius = closeBtn.frame.height/2
        
        let arrivedTitle = NSAttributedString(string: "Arrived".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        arrivedBtn.setAttributedTitle(arrivedTitle, for: .normal)
        arrivedBtn.layer.cornerRadius = 12.0
        updateInfoLabels()
    }
    
    func updateInfoLabels() {
        distanceLbl.text = "\(distance) meters away"
        directionLbl.text = "Direction \(direction)"
        
        locationLbl.set(font: .systemFont(ofSize: 19, weight: .medium), range: locationLbl.range(after: "Section ", before: " - Spot"))
        locationLbl.set(font: .systemFont(ofSize: 19, weight: .medium), range: locationLbl.range(after: "Spot"))
        locationLbl.set(textColor: UIColor(named: "Kinda Red")!, range: locationLbl.range(after: "Section ", before: " - Spot"))
        locationLbl.set(textColor: UIColor(named: "Kinda Red")!, range: locationLbl.range(after: "Spot"))
        
        distanceLbl.set(font: .systemFont(ofSize: 19, weight: .medium), range: distanceLbl.range(before: " away"))
        distanceLbl.set(textColor: UIColor(named: "Kinda Red")!, range: distanceLbl.range(before: " away"))
        
        directionLbl.set(font: .systemFont(ofSize: 19, weight: .medium), range: directionLbl.range(after: "Direction "))
        directionLbl.set(textColor: UIColor(named: "Kinda Red")!, range: directionLbl.range(after: "Direction "))
    }
    
}