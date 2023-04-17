//
//  AddCardViewController.swift
//  Roadout
//
//  Created by David Retegan on 28.10.2021.
//

import UIKit

class AddCardViewController: UIViewController {
    
    let setTitle = NSAttributedString(string: "Save".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    private var initialCenter: CGPoint = .zero

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @IBOutlet weak var addBtn: UXButton!
    @IBAction func addTapped(_ sender: Any) {
        if cvvField.text?.count == 3 && expiryField.text != "" && numberField.text?.count == 16 {
            let blurredNr = "**** **** **** \(numberField.text!.suffix(4))"
            cardNumbers.append(blurredNr)
            NotificationCenter.default.post(name: .refreshCardsID, object: nil)
            NotificationCenter.default.post(name: .refreshCardsMenuID, object: nil)
            UIView.animate(withDuration: 0.1) {
                self.blurEffect.alpha = 0
            } completion: { done in
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error".localized(), message: "Please make sure all card details are correct and filled".localized(), preferredStyle: .alert)
            alert.view.tintColor = UIColor.Roadout.darkOrange
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    @IBOutlet weak var scanBtn: UXButton!
    @IBAction func scanTapped(_ sender: Any) {

    }
    
    @IBOutlet weak var cvvField: PaddedTextField!
    @IBOutlet weak var expiryField: PaddedTextField!
    @IBOutlet weak var holderField: PaddedTextField!
    @IBOutlet weak var numberField: PaddedTextField!
    
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

        addBtn.layer.cornerRadius = 13.0
        addBtn.setAttributedTitle(setTitle, for: .normal)
        addBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        scanBtn.layer.cornerRadius = 13.0
        scanBtn.setTitle("", for: .normal)
        scanBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        cvvField.layer.cornerRadius = 12.0
        cvvField.attributedPlaceholder = NSAttributedString(
            string: "CVV".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        expiryField.layer.cornerRadius = 12.0
        expiryField.attributedPlaceholder = NSAttributedString(
            string: "Expiry Date".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        holderField.layer.cornerRadius = 12.0
        holderField.attributedPlaceholder = NSAttributedString(
            string: "Card Holder".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        numberField.layer.cornerRadius = 12.0
        numberField.attributedPlaceholder = NSAttributedString(
            string: "Card Number".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        
        prepareDatePicker()
                
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
        
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cardPanned))
        panRecognizer.delegate = self
        cardView.addGestureRecognizer(panRecognizer)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.alpha = 0.7
        } completion: { _ in
            self.numberField.becomeFirstResponder()
        }
    }
    
    func prepareDatePicker() {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = MonthYearPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        
        expiryField.inputView = datePicker
    }
    
    @objc func datePickerChanged(datePicker: MonthYearPickerView) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/YY"
        expiryField.text = dateFormatter.string(from: datePicker.date)
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
extension AddCardViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !addBtn.bounds.contains(touch.location(in: addBtn)) && !scanBtn.bounds.contains(touch.location(in: scanBtn))
    }
}
