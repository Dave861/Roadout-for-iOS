//
//  ReportBugViewController.swift
//  Roadout
//
//  Created by David Retegan on 17.04.2023.
//

import UIKit

class ReportBugViewController: UIViewController {

    let reportTitle = NSAttributedString(string: "Report".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    private var initialCenter: CGPoint = .zero

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var priorityControl: UISegmentedControl!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var reportBtn: UXButton!
    @IBAction func reportTapped(_ sender: Any) {
        
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

        reportBtn.layer.cornerRadius = 13.0
        reportBtn.setAttributedTitle(reportTitle, for: .normal)
        
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
        
        descriptionField.text = "Please describe your issue and any steps to reproduce it...".localized()
        descriptionField.textColor = .systemGray
        descriptionField.delegate = self
        descriptionField.textContainerInset = UIEdgeInsets(top: 8, left: 6, bottom: 5, right: 6)
        
        localizeSegments()
        
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
        } completion: { _ in
            if UserDefaults.roadout!.bool(forKey: "eu.roadout.Roadout.shownTip10") == false {
                self.cardView.tooltip(TutorialView10.instanceFromNib(), orientation: Tooltip.Orientation.top, configuration: { configuration in
                    
                    configuration.backgroundColor = UIColor(named: "Card Background")!
                    configuration.shadowConfiguration.shadowOpacity = 0.2
                    configuration.shadowConfiguration.shadowColor = UIColor.black.cgColor
                    configuration.shadowConfiguration.shadowOffset = .zero
                    
                    return configuration
                })
                UserDefaults.roadout!.set(true, forKey: "eu.roadout.Roadout.shownTip10")
            }
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
    
    func localizeSegments() {
        priorityControl.setTitle("Low".localized(), forSegmentAt: 0)
        priorityControl.setTitle("Medium".localized(), forSegmentAt: 1)
        priorityControl.setTitle("High".localized(), forSegmentAt: 2)
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
extension ReportBugViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !reportBtn.bounds.contains(touch.location(in: reportBtn))
    }
}
extension ReportBugViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please describe your issue and any steps to reproduce it...".localized()
            textView.textColor = UIColor.systemGray
        }
    }
}
