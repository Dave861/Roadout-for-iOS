//
//  HelpContactViewController.swift
//  Roadout
//
//  Created by David Retegan on 23.04.2023.
//

import UIKit

class HelpContactViewController: UIViewController {

    let submitTitle = NSAttributedString(string: "Submit".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    private var initialCenter: CGPoint = .zero
    var tintColor = UIColor.Roadout.icons

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var subjectSegments: UISegmentedControl!
    @IBAction func segmentsChanged(_ sender: Any) {
        if descriptionField.textColor == UIColor.systemGray {
            if subjectSegments.selectedSegmentIndex == 0 {
                descriptionField.text = "I need help with this because...".localized()
            } else {
                descriptionField.text = "I think it would be great if...".localized()
            }
        }
    }
    
    @IBOutlet weak var submitBtn: UXButton!
    @IBAction func submitTapped(_ sender: Any) {
        
    }
    
    @objc func blurTapped() {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
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

        submitBtn.layer.cornerRadius = 13.0
        submitBtn.setAttributedTitle(submitTitle, for: .normal)
        
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
        
        if subjectSegments.selectedSegmentIndex == 0 {
            descriptionField.text = "I need help with this because...".localized()
        } else {
            descriptionField.text = "I think it would be great if...".localized()
        }
        descriptionField.textColor = .systemGray
        descriptionField.delegate = self
        descriptionField.textContainerInset = UIEdgeInsets(top: 8, left: 6, bottom: 5, right: 6)
        
        tintCard()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cardPanned))
        panRecognizer.delegate = self
        cardView.addGestureRecognizer(panRecognizer)
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
    
    func tintCard() {
        cancelBtn.tintColor = self.tintColor
        submitBtn.backgroundColor = self.tintColor
        descriptionField.tintColor = self.tintColor
    }
    
    @objc func cardPanned(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
            case .began:
                initialCenter = cardView.center
            case .changed:
                let translation = recognizer.translation(in: cardView)
                if translation.y > 0 {
                    cardView.center = CGPoint(x: initialCenter.x, y: initialCenter.y + translation.y)
                    let progress = translation.y / (view.bounds.height / 2)
                    blurEffect.alpha = 0.7 - progress * 0.7 // decrease blur opacity as card is panned down
                }
            case .ended:
                let velocity = recognizer.velocity(in: cardView)
                if velocity.y >= 1000 {
                    self.view.endEditing(true)
                    UIView.animate(withDuration: 0.2, animations: {
                        self.blurEffect.alpha = 0
                        self.cardView.frame.origin.y = self.view.frame.maxY
                    }, completion: { done in
                        self.dismiss(animated: false, completion: nil)
                    })
                } else {
                    UIView.animate(withDuration: 0.2) {
                        self.cardView.center = self.initialCenter
                        self.blurEffect.alpha = 0.7
                    }
                }
            default:
                break
        }
    }
    
}
extension HelpContactViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !submitBtn.bounds.contains(touch.location(in: submitBtn))
    }
}
extension HelpContactViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if subjectSegments.selectedSegmentIndex == 0 {
                textView.text = "I need help with this because...".localized()
            } else {
                textView.text = "I think it would be great if...".localized()
            }
            textView.textColor = UIColor.systemGray
        }
    }
}
