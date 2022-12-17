//
//  ARTutorialViewController.swift
//  Roadout
//
//  Created by David Retegan on 12.12.2022.
//

import UIKit

class ARTutorialViewController: UIViewController {
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var explainerText: UILabel!
    
    @IBAction func continueTapped(_ sender: Any) {
        ARManager.sharedInstance.markTutorial()
        let vc = storyboard?.instantiateViewController(withIdentifier: "ARDirectionsVC") as! ARDirectionsViewController
        self.present(vc, animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

    let continueTitle = NSAttributedString(string: "Continue".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Kinda Red")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 13.0
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
            
        styleExplanation()
    }
        
    func styleExplanation() {
        explainerText.set(font: .systemFont(ofSize: 17, weight: .medium), range: explainerText.range(string: "arrived"))
        explainerText.set(font: .systemFont(ofSize: 17, weight: .medium), range: explainerText.range(string: "limited accuracy"))
        explainerText.set(font: .systemFont(ofSize: 17, weight: .medium), range: explainerText.range(string: "do not drive"))
            
        explainerText.set(textColor: UIColor(named: "Kinda Red")!, range: explainerText.range(string: "arrived"))
        explainerText.set(textColor: UIColor(named: "Kinda Red")!, range: explainerText.range(string: "limited accuracy"))
        explainerText.set(textColor: UIColor(named: "Kinda Red")!, range: explainerText.range(string: "do not drive"))
    }
    
}
