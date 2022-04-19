//
//  FindView.swift
//  Roadout
//
//  Created by David Retegan on 01.12.2021.
//

import UIKit
import IntentsUI
import Intents
import SPAlert

class FindView: UIView {
    
    var minutesValue = 15
    var alertView: SPAlertView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
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
    
    @IBOutlet weak var siriBtnView: UIView!
    
    

    @IBOutlet weak var locationBtn: UIButton!
    
    @IBOutlet weak var sectionBtn: UIButton!
    
    @IBOutlet weak var spotBtn: UIButton!
    
    
    @IBAction func timeTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Choose duration".localized(), preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(named: "Greyish")
        let action1 = UIAlertAction(title: "5" + " Minutes".localized(), style: .default) { action in
            self.timeLbl.text = "5" + " Minutes".localized()
            self.minutesValue = 5
        }
        let action2 = UIAlertAction(title: "10" + " Minutes".localized(), style: .default) { action in
            self.timeLbl.text = "10" + " Minutes".localized()
            self.minutesValue = 10
        }
        let action3 = UIAlertAction(title: "15" + " Minutes".localized(), style: .default) { action in
            self.timeLbl.text = "15" + " Minutes".localized()
            self.minutesValue = 15
        }
        let action4 = UIAlertAction(title: "20" + " Minutes".localized(), style: .default) { action in
            self.timeLbl.text = "20" + " Minutes".localized()
            self.minutesValue = 20
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Brownish")!, forKey: "titleTextColor")
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)

        self.parentViewController().present(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var timeBtn: UIButton!
    
    
        
    let continueTitle = NSAttributedString(string: "Continue".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
   
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        
        backBtn.setTitle("", for: .normal)
        
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
    
        
        if #available(iOS 14.0, *) {
            timeBtn.menu = durationMenu
            timeBtn.showsMenuAsPrimaryAction = true
        }

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
        intent.suggestedInvocationPhrase = "Find me a parking spot"
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
