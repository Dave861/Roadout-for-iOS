//
//  FindView.swift
//  Roadout
//
//  Created by David Retegan on 01.12.2021.
//

import UIKit
import IntentsUI
import Intents
import MarqueeLabel

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
    
    @IBOutlet weak var locationLbl: MarqueeLabel!
    @IBOutlet weak var sectionLbl: MarqueeLabel!
    @IBOutlet weak var spotLbl: MarqueeLabel!
    @IBOutlet weak var timeLbl: MarqueeLabel!
    
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
    
    @IBOutlet weak var siriBtnView: UIView!
    
    @IBOutlet weak var locationBtn: UIButton!
    
    @IBOutlet weak var sectionBtn: UIButton!
    
    @IBOutlet weak var spotBtn: UIButton!
    
    
    @IBAction func timeTapped(_ sender: Any) {
        //Handled by menu
    }
    @IBOutlet weak var timeBtn: UIButton!
    
    
        
    let continueTitle = NSAttributedString(string: "Continue".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
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

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        NotificationCenter.default.post(name: .animateCameraToFoundID, object: nil)
        donateInteration()
        addToSiriBtn()
        
        //LOADING
        locationLbl.text = "Loading...".localized()
        sectionLbl.text = "Loading...".localized()
        spotLbl.text = "Loading...".localized()
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.locationLbl.text = FunctionsManager.sharedInstance.foundLocation.name
            self.sectionLbl.text = "Section ".localized() + FunctionsManager.sharedInstance.foundSection.name
            self.spotLbl.text = "Spot ".localized() + "\(FunctionsManager.sharedInstance.foundSpot.number)"
        }
        print("presented")
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
        
    func donateInteration() {
        let intent = QuickReserveIntent()
        intent.suggestedInvocationPhrase = "Find me a Parking Spot"
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { err in
            if err == nil {
                print("Donated Succesfully")
            } else {
                print(String(describing: err?.localizedDescription))
            }
        }
    }
    
    func addToSiriBtn() {
        let button = INUIAddVoiceShortcutButton(style: .automaticOutline)
        button.backgroundColor = .clear
        button.frame = CGRect(x: 0, y: 0, width: self.frame.width-20, height: 50)
        button.delegate = self
        let intent = QuickReserveIntent()
        if let shortcut = INShortcut(intent: intent) {
            button.shortcut = shortcut
        }
        siriBtnView.addSubview(button)
    }
    
}
extension FindView: INUIAddVoiceShortcutButtonDelegate {
    
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        self.parentViewController().present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        self.parentViewController().present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
}

extension FindView: INUIAddVoiceShortcutViewControllerDelegate, INUIEditVoiceShortcutViewControllerDelegate {
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
