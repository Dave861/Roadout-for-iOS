//
//  SectionView.swift
//  Roadout
//
//  Created by David Retegan on 30.10.2021.
//

import UIKit
import SPIndicator

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
        let generator = UIImpactFeedbackGenerator(style: .soft)
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
            sectionImage.subviews.forEach({ $0.removeFromSuperview() })
        }
        
        
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
            letterBtn.setTitleColor(UIColor(named: "Icons")!, for: .normal)
            
            letterBtn.addAction(for: .touchUpInside) {
                self.letter = sections[index].name
                self.letterTitle = NSAttributedString(string: self.letter,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
                self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
                selectedSectionIndex = index
                self.showSelectedIndicator(letter: sections[index].name)
                self.decolorButtonsInSectionImage()
                letterBtn.setTitleColor(UIColor(named: "Background")!, for: .normal)
                letterBtn.backgroundColor = UIColor(named: "Icons")!
            }
            
            self.sectionImage.addSubview(letterBtn)
        }
    }
    
    func decolorButtonsInSectionImage() {
        for subview in sectionImage.subviews {
            guard let btn = subview as? UIButton else { return }
            btn.setTitleColor(UIColor(named: "Icons")!, for: .normal)
            btn.backgroundColor = UIColor(named: "IconsTransparent")!
        }
    }
    
    func showSelectedIndicator(letter: String) {
        let image = UIImage.init(systemName: "\(letter.lowercased()).circle.fill")!.withTintColor(UIColor(named: "Icons")!, renderingMode: .alwaysOriginal)
        let indicatorView = SPIndicatorView(title: "Section ".localized() + "\(letter)", message: "Selected".localized(), preset: .custom(image))
        indicatorView.backgroundColor = UIColor(named: "Background")!
        indicatorView.present(duration: 0.7, haptic: .none, completion: nil)
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
