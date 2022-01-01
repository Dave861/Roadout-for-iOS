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
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Section G", image: nil, handler: { (_) in
                self.letter = "G"
                self.letterTitle = NSAttributedString(string: self.letter,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
                self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
            }),
            UIAction(title: "Section F", image: nil, handler: { (_) in
                self.letter = "F"
                self.letterTitle = NSAttributedString(string: self.letter,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
                self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
            }),
            UIAction(title: "Section E", image: nil, handler: { (_) in
                self.letter = "E"
                self.letterTitle = NSAttributedString(string: self.letter,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
                self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
            }),
            UIAction(title: "Section D", image: nil, handler: { (_) in
                self.letter = "D"
                self.letterTitle = NSAttributedString(string: self.letter,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
                self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
            }),
            UIAction(title: "Section C", image: nil, handler: { (_) in
                self.letter = "C"
                self.letterTitle = NSAttributedString(string: self.letter,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
                self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
            }),
            UIAction(title: "Section B", image: nil, handler: { (_) in
                self.letter = "B"
                self.letterTitle = NSAttributedString(string: self.letter,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
                self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
            }),
            UIAction(title: "Section A", image: nil, handler: { (_) in
                self.letter = "A"
                self.letterTitle = NSAttributedString(string: self.letter,
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
                self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
            }),
        ]
    }
    var lettersMenu: UIMenu {
        return UIMenu(title: "Choose a section", image: nil, identifier: nil, options: [], children: menuItems)
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
        NotificationCenter.default.post(name: .removeSectionCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func sectionTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Choose a section", preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor(named: "Icons")
        let sectionAAction = UIAlertAction(title: "Section A", style: .default) { action in
            self.letter = "A"
            self.letterTitle = NSAttributedString(string: self.letter,
                                             attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
            self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
        }
        let sectionBAction = UIAlertAction(title: "Section B", style: .default) { action in
            self.letter = "B"
            self.letterTitle = NSAttributedString(string: self.letter,
                                             attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
            self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
        }
        let sectionCAction = UIAlertAction(title: "Section C", style: .default) { action in
            self.letter = "C"
            self.letterTitle = NSAttributedString(string: self.letter,
                                             attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
            self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
        }
        let sectionDAction = UIAlertAction(title: "Section D", style: .default) { action in
            self.letter = "D"
            self.letterTitle = NSAttributedString(string: self.letter,
                                             attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
            self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
        }
        let sectionEAction = UIAlertAction(title: "Section E", style: .default) { action in
            self.letter = "E"
            self.letterTitle = NSAttributedString(string: self.letter,
                                             attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
            self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
        }
        let sectionFAction = UIAlertAction(title: "Section F", style: .default) { action in
            self.letter = "F"
            self.letterTitle = NSAttributedString(string: self.letter,
                                             attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
            self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
        }
        let sectionGAction = UIAlertAction(title: "Section G", style: .default) { action in
            self.letter = "G"
            self.letterTitle = NSAttributedString(string: self.letter,
                                             attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
            self.sectionBtn.setAttributedTitle(self.letterTitle, for: .normal)
        }        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Greyish")!, forKey: "titleTextColor")
        
        alert.addAction(sectionAAction)
        alert.addAction(sectionBAction)
        alert.addAction(sectionCAction)
        alert.addAction(sectionDAction)
        alert.addAction(sectionEAction)
        alert.addAction(sectionFAction)
        alert.addAction(sectionGAction)
        alert.addAction(cancelAction)
        self.parentViewController().present(alert, animated: true, completion: nil)
    }
    
    let continueTitle = NSAttributedString(string: "Continue", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        continueBtn.layer.cornerRadius = 12.0
        backBtn.setTitle("", for: .normal)
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
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
}
