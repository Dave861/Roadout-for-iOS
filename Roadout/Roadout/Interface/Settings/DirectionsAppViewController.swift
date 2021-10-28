//
//  DirectionsAppViewController.swift
//  Roadout
//
//  Created by David Retegan on 27.10.2021.
//

import UIKit

class DirectionsAppViewController: UIViewController {

    var index = 1
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func appleMapsTapped(_ sender: Any) {
        index = 1
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        updateSelection()
    }
    @IBAction func googleMapsTapped(_ sender: Any) {
        index = 2
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        updateSelection()
    }
    @IBAction func wazeTapped(_ sender: Any) {
        index = 3
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        updateSelection()
    }
    
    @IBOutlet weak var card1: UIView!
    @IBOutlet weak var card2: UIView!
    @IBOutlet weak var card3: UIView!
    
    @IBOutlet weak var circle1: UIImageView!
    @IBOutlet weak var circle2: UIImageView!
    @IBOutlet weak var circle3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card1.layer.cornerRadius = 16.0
        card2.layer.cornerRadius = 16.0
        card3.layer.cornerRadius = 16.0
        
        backButton.setTitle("", for: .normal)
        button1.setTitle("", for: .normal)
        button2.setTitle("", for: .normal)
        button3.setTitle("", for: .normal)
    }
    
    func updateSelection() {
        if index == 1 {
            circle1.image = UIImage(systemName: "checkmark.circle.fill")
            circle2.image = UIImage(systemName: "circle")
            circle3.image = UIImage(systemName: "circle")
        } else if index == 2 {
            circle2.image = UIImage(systemName: "checkmark.circle.fill")
            circle1.image = UIImage(systemName: "circle")
            circle3.image = UIImage(systemName: "circle")
        } else {
            circle3.image = UIImage(systemName: "checkmark.circle.fill")
            circle2.image = UIImage(systemName: "circle")
            circle1.image = UIImage(systemName: "circle")
        }
    }

}
