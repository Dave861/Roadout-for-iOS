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
        return UIMenu(title: "Choose a section".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(sections: parkLocations[selectedParkLocationIndex].sections))
    }
    
    @IBOutlet weak var sectionImage: UIImageView!
    
    @IBOutlet weak var sectionBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if parkLocations[selectedParkLocationIndex].sections.last?.spots == [ParkSpot]() {
            self.showLoadingAlert()
        } else {
            NotificationCenter.default.post(name: .addSpotCardID, object: nil)
        }
    }
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        letter = "A"
        selectedSectionIndex = 0
        NotificationCenter.default.post(name: .removeSectionCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func sectionTapped(_ sender: Any) {
        self.parentViewController().present(makeAlert(sections: parkLocations[selectedParkLocationIndex].sections), animated: true, completion: nil)
    }
    
    let continueTitle = NSAttributedString(string: "Continue".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        continueBtn.layer.cornerRadius = 12.0
        backBtn.setTitle("", for: .normal)
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        
        sectionImage.image = UIImage(named: parkLocations[selectedParkLocationIndex].sectionImage)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        if letter == "A" {
            selectedSectionIndex = 0
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
    
    func showLoadingAlert() {
        let alert = UIAlertController(title: "Loading...".localized(), message: "The spots are still downloading, this should not happen normally and might be caused by poor network connection. Please wait and try again.".localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.view.tintColor = UIColor(named: "Icons")
        self.parentViewController().present(alert, animated: true, completion: nil)
    }
    
    func makeAlert(sections: [ParkSection]) -> UIAlertController {
        let alert = UIAlertController(title: "", message: "Choose a section".localized(), preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(named: "Icons")
        
        for index in 0...sections.count-1 {
            let sectionAction = UIAlertAction(title: "Section ".localized() + "\(sections[index].name)", style: .default) { action in
                self.letter = sections[index].name
                self.letterTitle = NSAttributedString(string: self.letter,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
                self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
                selectedSectionIndex = index
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
        
        for index in 0...sections.count-1 {
            let action = UIAction(title: "Section ".localized() + "\(sections[index].name)", image: nil, handler: { (_) in
                self.letter = sections[index].name
                self.letterTitle = NSAttributedString(string: self.letter,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
                self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
                selectedSectionIndex = index
            })
            menuItems.append(action)
        }
        
        return menuItems
    }
}
