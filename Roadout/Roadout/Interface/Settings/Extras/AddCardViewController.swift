//
//  AddCardViewController.swift
//  Roadout
//
//  Created by David Retegan on 28.10.2021.
//

import UIKit

class AddCardViewController: UIViewController {

    let refreshCardsID = "ro.roadout.Roadout.refreshCards"
    
    let setTitle = NSAttributedString(string: "Add", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurButton: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBAction func addTapped(_ sender: Any) {
        if cvvField.text?.count == 3 && expiryField.text != "" && numberField.text?.count == 16 {
            let blurredNr = "**** **** **** \(numberField.text!.suffix(4))"
            cardNumbers.append(blurredNr)
            NotificationCenter.default.post(name: Notification.Name(refreshCardsID), object: nil)
            UIView.animate(withDuration: 0.1) {
                self.blurButton.alpha = 0
            } completion: { done in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var cvvField: PaddedTextField!
    @IBOutlet weak var expiryField: PaddedTextField!
    @IBOutlet weak var holderField: PaddedTextField!
    @IBOutlet weak var numberField: PaddedTextField!
    
    @IBAction func cancelTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.blurButton.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func dismissTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.blurButton.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = 15
        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        addBtn.layer.cornerRadius = 13.0
        addBtn.setAttributedTitle(setTitle, for: .normal)
        
        cvvField.layer.cornerRadius = 12.0
        cvvField.attributedPlaceholder = NSAttributedString(
            string: "CVV",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Brownish")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        expiryField.layer.cornerRadius = 12.0
        expiryField.attributedPlaceholder = NSAttributedString(
            string: "Expiry Date",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Greyish")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        holderField.layer.cornerRadius = 12.0
        holderField.attributedPlaceholder = NSAttributedString(
            string: "Card Holder",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Dark Orange")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        numberField.layer.cornerRadius = 12.0
        numberField.attributedPlaceholder = NSAttributedString(
            string: "Card Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Second Orange")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
        
        self.expiryField.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //1
    }
            
    @objc func tapDone() {
        if let datePicker = self.expiryField.inputView as? MonthYearPickerView {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/YY"
            self.expiryField.text = dateformatter.string(from: datePicker.date)
        }
        self.expiryField.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.blurButton.alpha = 1.0
        }
    }
}
