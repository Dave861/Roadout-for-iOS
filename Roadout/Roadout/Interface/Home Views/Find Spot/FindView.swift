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

    let returnToSearchBarID = "ro.roadout.Roadout.returnToSearchBarID"
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: Notification.Name(returnToSearchBarID), object: nil)
    }
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
    }
    
    @IBOutlet weak var changeBtn: UIButton!
    @IBAction func changeTapped(_ sender: Any) {
        let changeAlert = UIAlertController(title: "\(self.minutesValue) Minutes", message: " ", preferredStyle: .alert)
        let myFrame = CGRect(x: 10.0, y: 45.0, width: 250.0, height: 25.0)
        let slider = UISlider(frame: myFrame)
        slider.minimumValue = 1
        slider.maximumValue = 20
        slider.tintColor = UIColor(named: "Greyish")!
        slider.value = Float(minutesValue)
        slider.addTarget(self, action: #selector(changedMinutes(_:)), for: .valueChanged)
        
        changeAlert.view.addSubview(slider)
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: { (action: UIAlertAction!) in
            print(slider.value)
            self.minutesValue = Int(slider.value)
            self.timeLbl.text = "Reserve \(self.minutesValue) Minutes"
            self.timeLbl.set(textColor: UIColor(named: "Greyish")!, range: self.timeLbl.range(after: "Reserve "))
        })
        doneAction.setValue(UIColor(named: "Icons")!, forKey: "titleTextColor")
        changeAlert.addAction(doneAction)
        changeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        changeAlert.view.tintColor = UIColor(named: "Greyish")!
        self.parentViewController().present(changeAlert, animated: true, completion: nil)
    }
    
    @objc func changedMinutes(_ sender: UISlider) {
        let roundedValue = round(sender.value/1.0)*1.0
        sender.value = roundedValue
        let pview = sender.parentViewController() as! UIAlertController
        pview.title = "\(Int(sender.value)) Minutes"
    }
    
    
    @IBOutlet weak var siriBtnView: UIView!
    
    let continueTitle = NSAttributedString(string: "Continue", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    var changeTitle = NSAttributedString(string: "Change", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Greyish")!])
   
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        
        backBtn.setTitle("", for: .normal)
        
        continueBtn.layer.cornerRadius = 12.0
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        
        changeBtn.setAttributedTitle(changeTitle, for: .normal)
        
        locationLbl.set(textColor: UIColor(named: "Greyish")!, range: locationLbl.range(before: " - Section"))
        timeLbl.text = "Reserve \(minutesValue) Minutes"
        timeLbl.set(textColor: UIColor(named: "Greyish")!, range: timeLbl.range(after: "Reserve "))

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
