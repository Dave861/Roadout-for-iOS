//
//  RemindersViewController.swift
//  Roadout
//
//  Created by David Retegan on 28.10.2021.
//

import UIKit

var reminderDates = ["Oct 19, 13:45", "Oct 31, 11:15", "Nov 05, 16:30", "Dec 07, 08:00", "Dec 22, 21:20"]

class RemindersViewController: UIViewController {
    
    let refreshReminderID = "ro.codebranch.Roadout.refreshReminder"

    @IBOutlet weak var addBtn: UIButton!
    
    @IBAction func addTapped(_ sender: Any) {
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
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView), name: Notification.Name(refreshReminderID), object: nil)
    }
    
    @objc func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObs()
        backButton.setTitle("", for: .normal)
        addBtn.setAttributedTitle(buttonTitle, for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 15.0
        addBtnOutline.layer.cornerRadius = 12.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }


}
extension RemindersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderDates.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell") as! ReminderCell
        cell.reminderLbl.text = "Reminder \(indexPath.row+1)"
        cell.dateLbl.text = reminderDates[indexPath.row]
        return cell
    }
}
