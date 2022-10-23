//
//  FindView.swift
//  Roadout
//
//  Created by David Retegan on 01.12.2021.
//

import UIKit

class FindView: UIView {
    
    var minutesValue = 15
    
    @IBOutlet weak var tipSourceView: UIView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeSpotMarkerID, object: nil)
        NotificationCenter.default.post(name: .returnToSearchBarID, object: nil)
    }
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var sectionLbl: UILabel!
    @IBOutlet weak var spotLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var locationCard: UIView!
    @IBOutlet weak var sectionCard: UIView!
    @IBOutlet weak var spotCard: UIView!
    @IBOutlet weak var timeCard: UIView!
    
    
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        returnToFind = true
        timerSeconds = minutesValue*60
        NotificationCenter.default.post(name: .addPayCardID, object: nil)
    }
    
    @IBOutlet weak var locationBtn: UIButton!
    
    @IBOutlet weak var sectionBtn: UIButton!
    
    @IBOutlet weak var spotBtn: UIButton!
    
    
    @IBAction func timeTapped(_ sender: Any) {
        //Handled by menu
    }
    @IBOutlet weak var timeBtn: UIButton!
    
    
        
    let continueTitle = NSAttributedString(string: "Continue".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let siriTitle = NSAttributedString(string: "Use with Siri".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Greyish")!])
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.shownTip2") == false {
            tipSourceView.tooltip(TutorialView2.instanceFromNib(), orientation: Tooltip.Orientation.top, configuration: { configuration in
                
                configuration.backgroundColor = UIColor(named: "Card Background")!
                configuration.shadowConfiguration.shadowOpacity = 0.1
                configuration.shadowConfiguration.shadowColor = UIColor.black.cgColor
                configuration.shadowConfiguration.shadowOffset = .zero
                
                return configuration
            })
            UserDefaults.roadout!.set(true, forKey: "ro.roadout.Roadout.shownTip2")
        }
    }
   
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        
        continueBtn.layer.cornerRadius = 12.0
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        
        timeLbl.text = "\(minutesValue)" + " Minutes".localized()
        
        locationCard.layer.cornerRadius = 12.0
        sectionCard.layer.cornerRadius = 12.0
        spotCard.layer.cornerRadius = 12.0
        timeCard.layer.cornerRadius = 12.0
        
        locationBtn.setTitle("", for: .normal)
        sectionBtn.setTitle("", for: .normal)
        spotBtn.setTitle("", for: .normal)
        timeBtn.setTitle("", for: .normal)
    
        timeBtn.menu = durationMenu
        timeBtn.showsMenuAsPrimaryAction = true

        NotificationCenter.default.post(name: .animateCameraToFoundID, object: nil)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.locationLbl.text = FunctionsManager.sharedInstance.foundLocation.name
        self.sectionLbl.text = "Section ".localized() + FunctionsManager.sharedInstance.foundSection.name
        self.spotLbl.text = "Spot ".localized() + "\(FunctionsManager.sharedInstance.foundSpot.number)"
    }
    
    
    

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Find", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    var durationMenuItems: [UIAction] {
        return [
            UIAction(title: "20" + " Minutes".localized(), image: nil, handler: { (_) in
                self.timeLbl.text = "20" + " Minutes".localized()
                self.minutesValue = 20
            }),
            UIAction(title: "15" + " Minutes".localized(), image: nil, handler: { (_) in
                self.timeLbl.text = "15" + " Minutes".localized()
                self.minutesValue = 15
            }),
            UIAction(title: "10" + " Minutes".localized(), image: nil, handler: { (_) in
                self.timeLbl.text = "10" + " Minutes".localized()
                self.minutesValue = 10
            }),
            UIAction(title: "5" + " Minutes".localized(), image: nil, handler: { (_) in
                self.timeLbl.text = "5" + " Minutes".localized()
                self.minutesValue = 5
            })
        ]
    }
    var durationMenu: UIMenu {
        return UIMenu(title: "Choose duration".localized(), image: nil, identifier: nil, options: [], children: durationMenuItems)
    }
        
    
}
