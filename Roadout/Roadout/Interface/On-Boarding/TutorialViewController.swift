//
//  TutorialViewController.swift
//  Roadout
//
//  Created by David Retegan on 15.01.2022.
//

import UIKit
import SPPerspective

class TutorialViewController: UIViewController {

    var tCounter = 1
    
    var tutorialTitles = ["Search Bar", "More Button", "Express Reserve", "Find Spot", "Preferences", "Markers"]
    var tutorialTexts = ["Use the search bar to find specific parking locations in your city and easily reserve the perfect spot for you.", "Use the more button to access more powerful options of the app. Tap it for more info.", "This is a quick and easy way to reserve a spot in a desired location.", "The fastest way to find a parking spot near you, great for you just need to park quickly.", "The place to see stats, add cards, reminders and manage permissions.", "Markers are easily glanceable indicators of where parking locations are relative to your location"]
    
    @IBOutlet weak var t1: UIView!
    
    @IBOutlet weak var t2: UIView!
    @IBOutlet weak var t2Btn: UIButton!
    @IBAction func t2Tapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "What would you like to do?", preferredStyle: .actionSheet)
        let settingsAction = UIAlertAction(title: "Preferences", style: .default) { action in
            self.tutorialTitle.text = self.tutorialTitles[4]
            self.tutorialText.text = self.tutorialTexts[4]
        }
        settingsAction.setValue(UIColor(named: "Icons")!, forKey: "titleTextColor")
        
        let findAction = UIAlertAction(title: "Find Spot", style: .default) { action in
            self.tutorialTitle.text = self.tutorialTitles[3]
            self.tutorialText.text = self.tutorialTexts[3]
        }
        findAction.setValue(UIColor(named: "Brownish")!, forKey: "titleTextColor")
        
        let expressAction = UIAlertAction(title: "Express Reserve", style: .default) { action in
            self.tutorialTitle.text = self.tutorialTitles[2]
            self.tutorialText.text = self.tutorialTexts[2]
        }
        expressAction.setValue(UIColor(named: "Dark Orange")!, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Greyish")!, forKey: "titleTextColor")
        
        alert.addAction(settingsAction)
        alert.addAction(findAction)
        alert.addAction(expressAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var t3: UIImageView!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBAction func continueTapped(_ sender: Any) {
        tCounter += 1
        if tCounter == 2 {
            t2.isHidden = false
            let animationConfig = SPPerspectiveAnimationConfig(duration: 15.0, distortion: 500, angle: 18, vectorStep: 3.14, shadow: nil)
            t2.roundCorners(corners: [.topRight, .bottomRight], radius: 13.0)
            t2.applyPerspective(animationConfig)
            tutorialTitle.text = tutorialTitles[1]
            tutorialText.text = tutorialTexts[1]
            
            t1.isHidden = true
        } else if tCounter == 3 {
            t3.isHidden = false
            let animationConfig = SPPerspectiveAnimationConfig(duration: 15.0, distortion: 500, angle: 18, vectorStep: 3.14, shadow: nil)
            t3.roundCorners(corners: [.topRight, .bottomRight], radius: 13.0)
            t3.applyPerspective(animationConfig)
            tutorialTitle.text = tutorialTitles[5]
            tutorialText.text = tutorialTexts[5]
            
            t1.isHidden = true
            t2.isHidden = true
            continueBtn.setAttributedTitle(doneTitle, for: .normal)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var skipBtn: UIButton!
    @IBAction func skipTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tutorialTitle: UILabel!
    @IBOutlet weak var tutorialText: UITextView!

    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Preferences", image: UIImage(systemName: "gearshape.2"), handler: { (_) in
                self.tutorialTitle.text = self.tutorialTitles[4]
                self.tutorialText.text = self.tutorialTexts[4]
            }),
            UIAction(title: "Find Spot", image: UIImage(systemName: "loupe"), handler: { (_) in
                self.tutorialTitle.text = self.tutorialTitles[3]
                self.tutorialText.text = self.tutorialTexts[3]
            }),
            UIAction(title: "Express Reserve", image: UIImage(systemName: "flag.2.crossed"), handler: { (_) in
                self.tutorialTitle.text = self.tutorialTitles[2]
                self.tutorialText.text = self.tutorialTexts[2]
            }),
        ]
    }
    var moreMenu: UIMenu {
        return UIMenu(title: "What would you like to do?", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    let continueTitle = NSAttributedString(string: "Continue", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let doneTitle = NSAttributedString(string: "Done", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let skipTitle = NSAttributedString(
        string: "Skip Tutorial",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Greyish")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        t1.isHidden = false
        let animationConfig = SPPerspectiveAnimationConfig(duration: 15.0, distortion: 500, angle: 18, vectorStep: 3.14, shadow: nil)
        t1.roundCorners(corners: [.topLeft, .bottomLeft], radius: 13.0)
        t1.applyPerspective(animationConfig)
        tutorialTitle.text = tutorialTitles[0]
        tutorialText.text = tutorialTexts[0]
        
        t2.isHidden = true
        t3.isHidden = true
        tCounter = 1
        
        t2Btn.setTitle("", for: .normal)
        
        continueBtn.layer.cornerRadius = continueBtn.frame.height/4
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        
        skipBtn.setAttributedTitle(skipTitle, for: .normal)
        
        if #available(iOS 14.0, *) {
            t2Btn.menu = moreMenu
            t2Btn.showsMenuAsPrimaryAction = true
        }
    }
   
}

