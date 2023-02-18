//
//  MoreInfoViewController.swift
//  Roadout
//
//  Created by David Retegan on 14.01.2023.
//

import UIKit

class MoreInfoViewController: UIViewController {
    
    let doneTitle = NSAttributedString(string: "Done".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    public var titleText: String!
    public var descriptionText: String!
    public var highlightColor: String!
    public var highlightedWords: [String]!

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @objc func blurTapped() {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBOutlet weak var doneBtn: UXButton!
    @IBAction func doneTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }

    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 20.0
        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addShadowToCardView()
        styleLabels()
        
        doneBtn.layer.cornerRadius = 13.0
        doneBtn.setAttributedTitle(doneTitle, for: .normal)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
        
        doneBtn.backgroundColor = UIColor(named: highlightColor)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.alpha = 0.7
        }
    }
    
    func addShadowToCardView() {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 20.0
        cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
        cardView.layer.shouldRasterize = true
        cardView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func styleLabels() {
        titleLbl.text = titleText
        descriptionLbl.text = descriptionText
        
        for highlightedWord in highlightedWords {
            descriptionLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: descriptionLbl.range(string: highlightedWord))
            descriptionLbl.set(textColor: UIColor(named: highlightColor)!, range: descriptionLbl.range(string: highlightedWord))
        }
    }
}
