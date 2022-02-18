//
//  SectionView.swift
//  Roadout
//
//  Created by David Retegan on 30.10.2021.
//

import UIKit

class SectionView: UIView {
    
    var letter = "A"
    var letterTitle: NSAttributedString!

    var lettersMenu: UIMenu {
        return UIMenu(title: "Choose a section", image: nil, identifier: nil, options: [], children: makeMenuActions(sections: selectedParkLocation.sections))
    }
    
    @IBOutlet weak var sectionImage: UIImageView!
    
    @IBOutlet weak var sectionBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .addSpotCardID, object: nil)
    }
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        letter = "A"
        selectedSection = selectedParkLocation.sections[0]
        NotificationCenter.default.post(name: .removeSectionCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func sectionTapped(_ sender: Any) {
        self.parentViewController().present(makeAlert(sections: selectedParkLocation.sections), animated: true, completion: nil)
    }
    
    let continueTitle = NSAttributedString(string: "Continue", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        continueBtn.layer.cornerRadius = 12.0
        backBtn.setTitle("", for: .normal)
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        
        sectionImage.image = UIImage(named: selectedParkLocation.sectionImage)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        if letter == "A" {
            selectedSection = selectedParkLocation.sections[0]
        }
        
        sectionBtn.layer.cornerRadius = 6.0
        letterTitle = NSAttributedString(string: letter,
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
        sectionBtn.setAttributedTitle(letterTitle, for: .normal)
        if #available(iOS 14.0, *) {
            sectionBtn.menu = lettersMenu
            sectionBtn.showsMenuAsPrimaryAction = true
        } else {
            
        }
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }
    
    func makeAlert(sections: [ParkSection]) -> UIAlertController {
        let alert = UIAlertController(title: "", message: "Choose a section", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(named: "Icons")
        
        for section in sections {
            let sectionAction = UIAlertAction(title: "Section \(section.name)", style: .default) { action in
                self.letter = section.name
                self.letterTitle = NSAttributedString(string: self.letter,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
                self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
                selectedSection = section
            }
            alert.addAction(sectionAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Greyish")!, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        return alert
    }
    
    func makeMenuActions(sections: [ParkSection]) -> [UIAction] {
        var menuItems = [UIAction]()
        
        for section in sections {
            let action = UIAction(title: "Section \(section.name)", image: nil, handler: { (_) in
                self.letter = section.name
                self.letterTitle = NSAttributedString(string: self.letter,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
                self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
                selectedSection = section
            })
            menuItems.append(action)
        }
        
        return menuItems
    }
}
