//
//  RemindersViewController.swift
//  Roadout
//
//  Created by David Retegan on 28.10.2021.
//

import UIKit

var reminders = [Reminder]()

class RemindersViewController: UIViewController {
    
    let UserDefaultsSuite = UserDefaults.init(suiteName: "group.ro.roadout.Roadout")!

    @IBOutlet weak var addBtn: UIButton!
    
    @IBAction func addTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddReminderVC") as! AddReminderViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: ContentSizedTableView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var addBtnOutline: UIView!
    
    let buttonTitle = NSAttributedString(string: "Add Reminder",
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView), name: .refreshReminderID, object: nil)
    }
    
    @objc func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObs()
        addBtn.setAttributedTitle(buttonTitle, for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 15.0
        addBtnOutline.layer.cornerRadius = 12.0
        
        getReminders()
        var index = 0
        for reminder in reminders {
            if reminder.date < Date() {
                reminders.remove(at: index)
            }
            index += 1
        }
        saveReminders()
    }
    
    func getReminders() {
        if let data = UserDefaultsSuite.data(forKey: "ro.roadout.remindersList") {
            do {
                let decoder = JSONDecoder()
                reminders = try decoder.decode([Reminder].self, from: data)
            } catch {
                reminders = [Reminder]()
                print("Unable to Decode Reminders (\(error))")
            }
        }
        tableView.reloadData()
    }
    
    func saveReminders() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(reminders)
            UserDefaultsSuite.set(data, forKey: "ro.roadout.remindersList")
        } catch {
            print("Unable to Encode Array of Reminders (\(error))")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        if UserPrefsUtils.sharedInstance.reminderNotificationsEnabled() == false {
            let alert = UIAlertController(title: "Warning", message: "Reminder notifications are disabled, you will NOT be notified by Roadout unless you enable reminder notifications", preferredStyle: .alert)
            alert.view.tintColor = UIColor(named: "Icons")
            let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }


}
extension RemindersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell") as! ReminderCell
        cell.reminderLbl.text = reminders[indexPath.row].label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, hh:mm"
        cell.dateLbl.text = dateFormatter.string(from: reminders[indexPath.row].date)
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            let alert = UIAlertController(title: "Delete", message: "Do you want to delete this reminder?", preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                NotificationHelper.sharedInstance.removeReminder(reminder: reminders[indexPath.row])
                reminders.remove(at: indexPath.row)
                self.saveReminders()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                self.tableView.reloadData()
            }
            alert.view.tintColor = UIColor(named: "Icons")
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        action.backgroundColor = UIColor.systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
}
