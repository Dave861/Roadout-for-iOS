//
//  FindView.swift
//  Roadout
//
//  Created by David Retegan on 01.12.2021.
//

import UIKit
import IntentsUI
import Intents

class FindView: UIView {
    
    var minutesValue = 15
    
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
    
    
    @IBAction func locationTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Choose another location", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(named: "Greyish")
        let action1 = UIAlertAction(title: "Old Town", style: .default) { action in
            self.locationLbl.text = "Old Town"
        }
        let action2 = UIAlertAction(title: "Airport", style: .default) { action in
            self.locationLbl.text = "Airport"
        }
        let action3 = UIAlertAction(title: "Marasti", style: .default) { action in
            self.locationLbl.text = "Marasti"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Brownish")!, forKey: "titleTextColor")
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)

        self.parentViewController().present(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var locationBtn: UIButton!
    
    
    @IBAction func sectionTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Choose another section", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(named: "Greyish")
        let action1 = UIAlertAction(title: "Section A", style: .default) { action in
            self.sectionLbl.text = "Section A"
        }
        let action2 = UIAlertAction(title: "Section D", style: .default) { action in
            self.locationLbl.text = "Section D"
        }
        let action3 = UIAlertAction(title: "Section F", style: .default) { action in
            self.locationLbl.text = "Section F"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Brownish")!, forKey: "titleTextColor")
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)

        self.parentViewController().present(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var sectionBtn: UIButton!
    
    
    @IBAction func spotTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Choose another spot", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(named: "Greyish")
        let action1 = UIAlertAction(title: "Spot 9", style: .default) { action in
            self.spotLbl.text = "Spot 9"
        }
        let action2 = UIAlertAction(title: "Spot 12", style: .default) { action in
            self.spotLbl.text = "Spot 12"
        }
        let action3 = UIAlertAction(title: "Spot 16", style: .default) { action in
            self.spotLbl.text = "Spot 16"
        }
        let action4 = UIAlertAction(title: "Spot 19", style: .default) { action in
            self.spotLbl.text = "Spot 19"
        }
        let action5 = UIAlertAction(title: "Spot 21", style: .default) { action in
            self.spotLbl.text = "Spot 21"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Brownish")!, forKey: "titleTextColor")
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        alert.addAction(action5)

        self.parentViewController().present(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var spotBtn: UIButton!
    
    
    @IBAction func timeTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Choose duration", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(named: "Greyish")
        let action1 = UIAlertAction(title: "5 Minutes", style: .default) { action in
            self.timeLbl.text = "5 Minutes"
            self.minutesValue = 5
        }
        let action2 = UIAlertAction(title: "10 Minutes", style: .default) { action in
            self.timeLbl.text = "10 Minutes"
            self.minutesValue = 10
        }
        let action3 = UIAlertAction(title: "15 Minutes", style: .default) { action in
            self.timeLbl.text = "15 Minutes"
            self.minutesValue = 15
        }
        let action4 = UIAlertAction(title: "20 Minutes", style: .default) { action in
            self.timeLbl.text = "20 Minutes"
            self.minutesValue = 20
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Brownish")!, forKey: "titleTextColor")
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)

        self.parentViewController().present(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var timeBtn: UIButton!
    
    
        
    let continueTitle = NSAttributedString(string: "Continue", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
   
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        
        backBtn.setTitle("", for: .normal)
        
        continueBtn.layer.cornerRadius = 12.0
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        
        
        timeLbl.text = "\(minutesValue) Minutes"
        
        locationCard.layer.cornerRadius = 12.0
        sectionCard.layer.cornerRadius = 12.0
        spotCard.layer.cornerRadius = 12.0
        timeCard.layer.cornerRadius = 12.0
        
        locationBtn.setTitle("", for: .normal)
        sectionBtn.setTitle("", for: .normal)
        spotBtn.setTitle("", for: .normal)
        timeBtn.setTitle("", for: .normal)
        
        if #available(iOS 14.0, *) {
            locationBtn.menu = locationsMenu
            sectionBtn.menu = sectionsMenu
            spotBtn.menu = spotsMenu
            timeBtn.menu = durationMenu
            locationBtn.showsMenuAsPrimaryAction = true
            sectionBtn.showsMenuAsPrimaryAction = true
            spotBtn.showsMenuAsPrimaryAction = true
            timeBtn.showsMenuAsPrimaryAction = true
        }

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        donateInteration()
        addToSiriBtn()
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Find", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    var locationsMenuItems: [UIAction] {
        return [
            UIAction(title: "Old Town", image: nil, handler: { (_) in
                self.locationLbl.text = "Old Town"
            }),
            UIAction(title: "Airport", image: nil, handler: { (_) in
                self.locationLbl.text = "Airport"
            }),
            UIAction(title: "Marasti", image: nil, handler: { (_) in
                self.locationLbl.text = "Marasti"
            })
        ]
    }
    var locationsMenu: UIMenu {
        return UIMenu(title: "Choose another location", image: nil, identifier: nil, options: [], children: locationsMenuItems)
    }
    
    var sectionsMenuItems: [UIAction] {
        return [
            UIAction(title: "Section F", image: nil, handler: { (_) in
                self.sectionLbl.text = "Section F"
            }),
            UIAction(title: "Section D", image: nil, handler: { (_) in
                self.sectionLbl.text = "Section D"
            }),
            UIAction(title: "Section A", image: nil, handler: { (_) in
                self.sectionLbl.text = "Section A"
            })
        ]
    }
    var sectionsMenu: UIMenu {
        return UIMenu(title: "Choose another section", image: nil, identifier: nil, options: [], children: sectionsMenuItems)
    }
    
    var spotsMenuItems: [UIAction] {
        return [
            UIAction(title: "Spot 21", image: nil, handler: { (_) in
                self.spotLbl.text = "Spot 21"
            }),
            UIAction(title: "Spot 19", image: nil, handler: { (_) in
                self.spotLbl.text = "Spot 19"
            }),
            UIAction(title: "Spot 16", image: nil, handler: { (_) in
                self.spotLbl.text = "Spot 16"
            }),
            UIAction(title: "Spot 12", image: nil, handler: { (_) in
                self.spotLbl.text = "Spot 12"
            }),
            UIAction(title: "Spot 9", image: nil, handler: { (_) in
                self.spotLbl.text = "Spot 9"
            })
        ]
    }
    var spotsMenu: UIMenu {
        return UIMenu(title: "Choose another spot", image: nil, identifier: nil, options: [], children: spotsMenuItems)
    }
    

    
    var durationMenuItems: [UIAction] {
        return [
            UIAction(title: "20 Minutes", image: nil, handler: { (_) in
                self.timeLbl.text = "20 Minutes"
                self.minutesValue = 20
            }),
            UIAction(title: "15 Minutes", image: nil, handler: { (_) in
                self.timeLbl.text = "15 Minutes"
                self.minutesValue = 15
            }),
            UIAction(title: "10 Minutes", image: nil, handler: { (_) in
                self.timeLbl.text = "10 Minutes"
                self.minutesValue = 10
            }),
            UIAction(title: "5 Minutes", image: nil, handler: { (_) in
                self.timeLbl.text = "5 Minutes"
                self.minutesValue = 5
            })
        ]
    }
    var durationMenu: UIMenu {
        return UIMenu(title: "Choose duration", image: nil, identifier: nil, options: [], children: durationMenuItems)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func donateInteration() {
        let intent = QuickReserveIntent()
        intent.suggestedInvocationPhrase = "Find me a parking spot"
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { err in
            if err == nil {
                print("Great Success")
            } else {
                print(err?.localizedDescription)
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
