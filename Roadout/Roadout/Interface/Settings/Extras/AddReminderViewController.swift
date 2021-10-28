//
//  AddReminderViewController.swift
//  Roadout
//
//  Created by David Retegan on 28.10.2021.
//

import UIKit

class AddReminderViewController: UIViewController {

    let refreshReminderID = "ro.codebranch.Roadout.refreshReminder"
    
    let setTitle = NSAttributedString(string: "Set", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurButton: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var setBtn: UIButton!
    @IBAction func setTapped(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm a"
        let formattedDate = formatter.string(from: datePicker.date)
        reminderDates.append(formattedDate)
        NotificationCenter.default.post(name: Notification.Name(refreshReminderID), object: nil)
        UIView.animate(withDuration: 0.1) {
            self.blurButton.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var labelField: PaddedTextField!
    
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
        setBtn.layer.cornerRadius = 13.0
        setBtn.setAttributedTitle(setTitle, for: .normal)
        
        labelField.layer.cornerRadius = 12.0
        labelField.attributedPlaceholder = NSAttributedString(
            string: "Notification Label",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Greyish")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.blurButton.alpha = 1
        }
    }

}
