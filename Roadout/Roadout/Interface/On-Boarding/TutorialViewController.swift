//
//  TutorialViewController.swift
//  Roadout
//
//  Created by David Retegan on 15.01.2022.
//

import UIKit

struct TutorialItem {
    var title: String
    var description: String
    var icon: UIImage
}

class TutorialViewController: UIViewController {
    
    var tutorialSet = [TutorialItem]()
    
    let homeTutorialSet = [TutorialItem(title: "Search Bar".localized(), description: "Use the search bar to find park locations near streets or places you need to get to.".localized(), icon: UIImage(systemName: "magnifyingglass")!),
                           TutorialItem(title: "Markers".localized(), description: "Parking locations are highlighted on the map using markers, you can zoom in and select them.".localized(), icon: UIImage(systemName: "mappin.and.ellipse")!),
                           TutorialItem(title: "Menu".localized(), description: "The menu has other methods of finding a parking spot, you can try them right now!".localized(), icon: UIImage(systemName: "ellipsis.circle")!)]
    
    let settingsTutorialSet = [TutorialItem(title: "User Control".localized(), description: "Here you edit your account and see all your data.".localized(), icon: UIImage(systemName: "person.fill")!),
                               TutorialItem(title: "App Options and Features".localized(), description: "You can customize Roadout and use Reminders to keep you from forgetting to make a reservation".localized(), icon:UIImage(systemName: "arrow.up.forward.app")!),
                               TutorialItem(title: "About and Help", description: "Have any questions? Reach out via FAQ & Support".localized(), icon: UIImage(systemName: "questionmark.circle")!)]
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @objc func blurTapped() {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func closeTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon3: UIImageView!
    
    @IBOutlet weak var titleLbl1: UILabel!
    @IBOutlet weak var titleLbl2: UILabel!
    @IBOutlet weak var titleLbl3: UILabel!
    
    @IBOutlet weak var descriptionText1: UILabel!
    @IBOutlet weak var descriptionText2: UILabel!
    @IBOutlet weak var descriptionText3: UILabel!

    func setTutorial() {
        icon1.image = tutorialSet[0].icon
        titleLbl1.text = tutorialSet[0].title
        descriptionText1.text = tutorialSet[0].description
        
        icon2.image = tutorialSet[1].icon
        titleLbl2.text = tutorialSet[1].title
        descriptionText2.text = tutorialSet[1].description
        
        icon3.image = tutorialSet[2].icon
        titleLbl3.text = tutorialSet[2].title
        descriptionText3.text = tutorialSet[2].description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 19.0
        setTutorial()
        closeButton.setTitle("", for: .normal)
        closeButton.layer.cornerRadius = closeButton.frame.height/2
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
        
        titleLbl.text = "Tutorial".localized()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.blurEffect.alpha = 1
        }
    }
   
}

