//
//  VoiceAssitantsViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2022.
//

import UIKit

class VoiceAssitantsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var easterEggLbl: UILabel!
    
    @IBOutlet weak var siriHeader: UILabel!
    @IBOutlet weak var siriCard: UIView!
    @IBOutlet weak var siriDescriptionTitle: UILabel!
    @IBOutlet weak var siriDescriptionLbl: UILabel!
    
    @IBOutlet weak var siriPhraseLbl1: UILabel!
    @IBOutlet weak var siriPhraseLbl2: UILabel!
    @IBOutlet weak var siriPhraseLbl3: UILabel!
    @IBOutlet weak var siriPhraseLbl4: UILabel!
    
    @IBOutlet weak var otherHeader: UILabel!
    @IBOutlet weak var otherCard: UIView!
    @IBOutlet weak var otherDescriptionTitle: UILabel!
    @IBOutlet weak var otherDescriptionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        siriCard.layer.cornerRadius = 16.0
        otherCard.layer.cornerRadius = 16.0
        
        localizeLabels()
        addColorToPhraseLabels()
    }

    func localizeLabels() {
        titleLbl.text = "Voice Assitants".localized()
        easterEggLbl.text = "Roadout\nMade in Cluj :)".localized()
        backButton.setTitle("Back".localized(), for: .normal)
        otherHeader.text = "Other Assitants".localized()
        
        siriDescriptionTitle.text = "Use Roadout with Siri".localized()
        siriDescriptionLbl.text = "There is no set-up required, just say one of the following phrases to find a parking spot through Siri. In order to function properly make sure location is enabled for Roadout.".localized()
        otherDescriptionTitle.text = "More Integrations".localized()
        otherDescriptionLbl.text = "Stay tuned, more integrations with your favourite assitants are coming soon…".localized()
    }
    
    func addColorToPhraseLabels() {
        siriPhraseLbl1.set(textColor: UIColor(named: "GoldBrown")!, range: siriPhraseLbl1.range(string: "Roadout"))
        siriPhraseLbl1.set(textColor: UIColor(named: "GoldBrown")!, range: siriPhraseLbl1.range(string: "somewhere to park"))
        
        siriPhraseLbl2.set(textColor: UIColor(named: "GoldBrown")!, range: siriPhraseLbl2.range(string: "Roadout"))
        siriPhraseLbl2.set(textColor: UIColor(named: "GoldBrown")!, range: siriPhraseLbl2.range(string: "parking"))
        
        siriPhraseLbl3.set(textColor: UIColor(named: "GoldBrown")!, range: siriPhraseLbl3.range(string: "Roadout"))
        siriPhraseLbl3.set(textColor: UIColor(named: "GoldBrown")!, range: siriPhraseLbl3.range(string: "parking"))
        
        siriPhraseLbl4.set(textColor: UIColor(named: "GoldBrown")!, range: siriPhraseLbl4.range(string: "Roadout"))
        siriPhraseLbl4.set(textColor: UIColor(named: "GoldBrown")!, range: siriPhraseLbl4.range(string: "somewhere to park"))
    }
}
