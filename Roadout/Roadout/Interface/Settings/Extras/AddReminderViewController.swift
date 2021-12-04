//
//  AddReminderViewController.swift
//  Roadout
//
//  Created by David Retegan on 28.10.2021.
//

import UIKit

class AddReminderViewController: UIViewController {

    let refreshReminderID = "ro.roadout.Roadout.refreshReminder"
    
    let setTitle = NSAttributedString(string: "Set", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurButton: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var setBtn: UIButton!
    @IBAction func setTapped(_ sender: Any) {
        var ok = true
        for reminder in reminders {
            if reminder.label == labelField.text {
                ok = false
            }
        }
        if ok == true {
            if labelField.text != "" {
                let reminder = Reminder(label: labelField.text!, date: datePicker.date, identifier: "ro.roadout.reminder.\(labelField.text!.replacingOccurrences(of: " ", with: ""))")
                if UserPrefsUtils.sharedInstance.reminderNotificationsEnabled() {
                    NotificationHelper.sharedInstance.scheduleReminder(reminder: reminder)
                }
                saveReminder(reminder: reminder)
                NotificationCenter.default.post(name: Notification.Name(refreshReminderID), object: nil)
                UIView.animate(withDuration: 0.1) {
                    self.blurButton.alpha = 0
                } completion: { done in
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Please add a label to the reminder", preferredStyle: .alert)
                alert.view.tintColor = UIColor(named: "Icons")
                let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "There is already an active reminder with this label, please pick another label", preferredStyle: .alert)
            alert.view.tintColor = UIColor(named: "Icons")
            let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func saveReminder(reminder: Reminder) {
        reminders.append(reminder)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(reminders)
            UserDefaults.standard.set(data, forKey: "ro.roadout.remindersList")
        } catch {
            print("Unable to Encode Array of Reminders (\(error))")
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
        cardView.layer.cornerRadius = 13.0
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
