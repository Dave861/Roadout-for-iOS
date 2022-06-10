//
//  AddReminderViewController.swift
//  Roadout
//
//  Created by David Retegan on 28.10.2021.
//

import UIKit

class AddReminderViewController: UIViewController {

    let UserDefaultsSuite = UserDefaults.init(suiteName: "group.ro.roadout.Roadout")!
    
    let setTitle = NSAttributedString(string: "Set".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    var oldSelectedDate = Date().addingTimeInterval(900)

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @objc func blurTapped() {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var pickBtn: UIButton!
    @IBAction func pickTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.alert)
        let alertDatePicker: UIDatePicker = UIDatePicker()
        alertDatePicker.frame = CGRect(x: 0, y: 15, width: alertController.view.frame.width, height: 200)
        alertDatePicker.minimumDate = Date().addingTimeInterval(900)
        if #available(iOS 14.0, *) {
            alertDatePicker.preferredDatePickerStyle = .wheels
        }
        alertDatePicker.minuteInterval = 15
        alertController.view.addSubview(alertDatePicker)
        let okAction = UIAlertAction(title: "OK".localized(), style: .default) { _ in
            self.oldSelectedDate = alertDatePicker.date
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = UIColor(named: "Icons")
        self.present(alertController, animated: true, completion: nil)
    }
    
    
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
                if #available(iOS 14.0, *) {
                    let reminder = Reminder(label: labelField.text!, date: datePicker.date, identifier: "ro.roadout.reminder.\(labelField.text!.replacingOccurrences(of: " ", with: ""))")
                    if UserPrefsUtils.sharedInstance.reminderNotificationsEnabled() {
                        NotificationHelper.sharedInstance.scheduleReminder(reminder: reminder)
                    }
                    saveReminder(reminder: reminder)
                } else {
                    let reminder = Reminder(label: labelField.text!, date: oldSelectedDate, identifier: "ro.roadout.reminder.\(labelField.text!.replacingOccurrences(of: " ", with: ""))")
                    if UserPrefsUtils.sharedInstance.reminderNotificationsEnabled() {
                        NotificationHelper.sharedInstance.scheduleReminder(reminder: reminder)
                    }
                    saveReminder(reminder: reminder)
                }
                NotificationCenter.default.post(name: .refreshReminderID, object: nil)
                UIView.animate(withDuration: 0.1) {
                    self.blurEffect.alpha = 0
                } completion: { done in
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Error".localized(), message: "Please add a label to the reminder".localized(), preferredStyle: .alert)
                alert.view.tintColor = UIColor(named: "Icons")
                let okAction = UIAlertAction(title: "OK".localized(), style: .default) { action in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error".localized(), message: "There is already an active reminder with this label, please pick another label".localized(), preferredStyle: .alert)
            alert.view.tintColor = UIColor(named: "Icons")
            let okAction = UIAlertAction(title: "OK".localized(), style: .default) { action in
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
            UserDefaultsSuite.set(data, forKey: "ro.roadout.remindersList")
        } catch {
            print("Unable to Encode Array of Reminders (\(error))")
        }
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var labelField: PaddedTextField!
    
    @IBAction func cancelTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 19.0
        setBtn.layer.cornerRadius = 13.0
        setBtn.setAttributedTitle(setTitle, for: .normal)
        
        datePicker.minimumDate = Date().addingTimeInterval(900)
        
        labelField.layer.cornerRadius = 12.0
        labelField.attributedPlaceholder = NSAttributedString(
            string: "Notification Label".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        if #available(iOS 14.0, *) {
            self.pickBtn.isEnabled = false
            self.pickBtn.isHidden = true
            self.datePicker.isEnabled = true
            self.datePicker.isHidden = false
        } else {
            self.pickBtn.isEnabled = true
            self.pickBtn.isHidden = false
            self.datePicker.isEnabled = false
            self.datePicker.isHidden = true
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.alpha = 1.0
        }
    }

}
