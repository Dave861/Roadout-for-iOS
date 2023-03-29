//
//  AddCardViewController.swift
//  Roadout
//
//  Created by David Retegan on 28.10.2021.
//

import UIKit

class AddCardViewController: UIViewController {
    
    let setTitle = NSAttributedString(string: "Add".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])

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
        
        self.expiryField.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
        
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.alpha = 0.7
        } completion: { _ in
            self.numberField.becomeFirstResponder()
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
            
    @objc func tapDone() {
        if let datePicker = self.expiryField.inputView as? MonthYearPickerView {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/YY"
            self.expiryField.text = dateformatter.string(from: datePicker.date)
        }
        self.expiryField.resignFirstResponder()
    }
    
}
