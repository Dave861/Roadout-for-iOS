//
//  SectionView.swift
//  Roadout
//
//  Created by David Retegan on 30.10.2021.
//

import UIKit

class SectionView: UXView {
    
    var letter = "A"
    var letterTitle: NSAttributedString!

    var lettersMenu: UIMenu {
        return UIMenu(title: "Choose a section".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(sections: parkLocations[selectedParkLocationIndex].sections))
    }
    
    let continueTitle = NSAttributedString(string: "Continue".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    @IBOutlet weak var sectionImage: UIImageView!
    
    @IBOutlet weak var sectionBtn: UIButton!
    
    
    @IBOutlet weak var continueBtn: UXButton!
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
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        letter = "A"
        selectedSectionIndex = 0
        NotificationCenter.default.post(name: .removeSectionCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func sectionTapped(_ sender: Any) {}
    
    //MARK: - Swipe Gesture Configuration -
    
    override func viewSwipedBack() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        letter = "A"
        selectedSectionIndex = 0
        NotificationCenter.default.post(name: .removeSectionCardID, object: nil)
    }
    
    override func excludePansFrom(touch: UITouch) -> Bool {
        return !continueBtn.bounds.contains(touch.location(in: continueBtn)) && !backBtn.bounds.contains(touch.location(in: backBtn))
    }
    
    //MARK: - View Confiuration -
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        continueBtn.layer.cornerRadius = 12.0
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        
        sectionImage.image = UIImage(named: parkLocations[selectedParkLocationIndex].sectionImage)
        sectionImage.isUserInteractionEnabled = true
        
        if newSuperview != nil {
            addPointsToImage(sections: parkLocations[selectedParkLocationIndex].sections)
        } else {
            removePointsFromImage()
        }
        
        
        if letter == "A" {
            selectedSectionIndex = 0
        }
        
        sectionBtn.layer.cornerRadius = 6.0
        letterTitle = NSAttributedString(string: letter,
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor.Roadout.icons])
        sectionBtn.setAttributedTitle(letterTitle, for: .normal)

        sectionBtn.menu = lettersMenu
        sectionBtn.showsMenuAsPrimaryAction = true
        
        self.accentColor = UIColor.Roadout.icons
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }
    
    func makeMenuActions(sections: [ParkSection]) -> [UIAction] {
        var menuItems = [UIAction]()
        
        for index in 0...sections.count-1 {
            let action = UIAction(title: "Section ".localized() + "\(sections[index].name)", image: nil, handler: { (_) in
                self.letter = sections[index].name
                self.letterTitle = NSAttributedString(string: self.letter,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor.Roadout.icons])
                self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
                selectedSectionIndex = index
                self.removePointsFromImage()
                self.addPointsToImage(sections: sections)
            })
            menuItems.append(action)
        }
        
        return menuItems
    }
    
    //MARK: - Image Configuration -
    
    func addPointsToImage(sections: [ParkSection]) {
        let sectionWidth = UIScreen.main.bounds.width - 46
        
        for index in 0...sections.count-1 {
        
            var newX = sections[index].imagePoint.x
            if sectionWidth > 365 {
                newX += 3
            } else if sectionWidth < 330 {
                newX -= 3
            }
            let z1 = CGFloat(newX) * sectionWidth / 100
            let z2 = CGFloat(sections[index].imagePoint.y) * self.sectionImage.frame.size.height / 100
            
            let letterBtn = UIButton(frame: CGRect(x: z1 - 30, y: z2 - 15, width: 30, height: 30))
            letterBtn.layer.cornerRadius = 6
            letterBtn.backgroundColor = UIColor(named: "IconsTransparent")!
            letterBtn.setTitle(sections[index].name, for: .normal)
            letterBtn.setTitleColor(UIColor.Roadout.icons, for: .normal)
            
            if letter == sections[index].name {
                letterBtn.setTitleColor(UIColor(named: "Background")!, for: .normal)
                letterBtn.backgroundColor = UIColor.Roadout.icons
            }
            
            letterBtn.addAction(for: .touchUpInside) {
                self.letter = sections[index].name
                self.letterTitle = NSAttributedString(string: self.letter,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor.Roadout.icons])
                self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
                selectedSectionIndex = index
                self.decolorButtonsInSectionImage()
                letterBtn.setTitleColor(UIColor(named: "Background")!, for: .normal)
                letterBtn.backgroundColor = UIColor.Roadout.icons
            }
            
            self.sectionImage.addSubview(letterBtn)
        }
    }
    
    func removePointsFromImage() {
        sectionImage.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func decolorButtonsInSectionImage() {
        for subview in sectionImage.subviews {
            guard let btn = subview as? UIButton else { return }
            btn.setTitleColor(UIColor.Roadout.icons, for: .normal)
            btn.backgroundColor = UIColor(named: "IconsTransparent")!
        }
    }
    
    //MARK: - Alert -
        
    func showLoadingAlert() {
        let alert = UIAlertController(title: "Loading...".localized(), message: "The spots are still downloading, this should not happen normally and might be caused by poor network connection. Please wait and try again.".localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.view.tintColor = UIColor.Roadout.icons
        self.parentViewController().present(alert, animated: true, completion: nil)
    }
    
}
