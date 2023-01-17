//
//  FutureReserveViewController.swift
//  Roadout
//
//  Created by David Retegan on 16.01.2023.
//

import UIKit

class FutureReserveViewController: UIViewController {
    
    let UserDefaultsSuite = UserDefaults.init(suiteName: "group.ro.roadout.Roadout")!

    let doneTitle = NSAttributedString(string: "Done".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Icons")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    let planReservationTitle = NSAttributedString(string: " Plan Reservation".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Icons")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderText: UILabel!
    @IBOutlet weak var placeholderAddBtn: UIButton!
    
    @IBAction func placeholderAddTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddFutureReserveVC") as! AddFutureReserveViewController
        self.present(vc, animated: true)
    }
    
    @IBOutlet weak var planReservationBtn: UIButton!
    
    @IBAction func planReservationTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddFutureReserveVC") as! AddFutureReserveViewController
        self.present(vc, animated: true)
    }
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(getFutureReservations), name: .reloadFutureReservationsID, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        manageObs()
        
        titleLbl.text = "Future Reserve".localized()
        
        doneButton.setAttributedTitle(doneTitle, for: .normal)
        planReservationBtn.setAttributedTitle(planReservationTitle, for: .normal)
        
        placeholderAddBtn.setTitle("Tap here to add".localized(), for: .normal)
        placeholderText.text = "You haven’t planned any Future Reservations".localized()
                
        tableView.delegate = self
        tableView.dataSource = self
                
        getFutureReservations()
        var index = 0
        for futureReservation in futureReservations {
            if futureReservation.date < Date() {
                futureReservations.remove(at: index)
            }
            index += 1
        }
        saveFutureReservations()
        reloadScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.shownTip5") == false {
             titleLbl.tooltip(TutorialView5.instanceFromNib(), orientation: Tooltip.Orientation.top, configuration: { configuration in

                 configuration.backgroundColor = UIColor(named: "Card Background")!
                 configuration.shadowConfiguration.shadowOpacity = 0.1
                 configuration.shadowConfiguration.shadowColor = UIColor.black.cgColor
                 configuration.shadowConfiguration.shadowOffset = .zero

                 return configuration
             })
             UserDefaults.roadout!.set(true, forKey: "ro.roadout.Roadout.shownTip5")
         }
        if UserPrefsUtils.sharedInstance.futureNotificationsEnabled() == false {
            let alert = UIAlertController(title: "Warning".localized(), message: "Future Reserve notifications are disabled, you will NOT be notified by Roadout unless you enable them".localized(), preferredStyle: .alert)
            alert.view.tintColor = UIColor(named: "Icons")
            let okAction = UIAlertAction(title: "OK".localized(), style: .default) { action in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func getFutureReservations() {
        if let data = UserDefaultsSuite.data(forKey: "ro.roadout.Roadout.futureReservations") {
            do {
                let decoder = JSONDecoder()
                futureReservations = try decoder.decode([FutureReservation].self, from: data)
            } catch {
                futureReservations = [FutureReservation]()
                print("Unable to Decode Future Reservations (\(error))")
            }
        }
        self.reloadScreen()
    }
    
    func saveFutureReservations() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(futureReservations)
            UserDefaultsSuite.set(data, forKey: "ro.roadout.Roadout.futureReservations")
        } catch {
            print("Unable to Encode Array of FRs (\(error))")
        }
    }

    func reloadScreen() {
        if futureReservations.count == 0 {
            placeholderView.isHidden = false
            tableView.isHidden = true
            planReservationBtn.isHidden = true
        } else {
            placeholderView.isHidden = true
            tableView.isHidden = false
            planReservationBtn.isHidden = false
            tableView.reloadData()
        }
    }

}
extension FutureReserveViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return futureReservations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FutureReserveCell") as! FutureReserveCell
        cell.titleLbl.text = "Reserve near " + futureReservations[indexPath.row].place
        cell.titleLbl.set(textColor: UIColor(named: "Icons")!, range: cell.titleLbl.range(after: "Reserve near "))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, hh:mm"
        cell.dateLbl.text = dateFormatter.string(from: futureReservations[indexPath.row].date)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FutureReserveCell
        cell.card.backgroundColor = UIColor(named: "Highlight Secondary Detail")
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FutureReserveCell
        cell.card.backgroundColor = UIColor(named: "Secondary Detail")
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "  Remove".localized()) { _, _, completion in
            NotificationHelper.sharedInstance.removeFutureReservation(futureReservation: futureReservations[indexPath.row])
            futureReservations.remove(at: indexPath.row)
            self.saveFutureReservations()
            tableView.reloadData()
            completion(true)
        }
        deleteAction.backgroundColor = UIColor(named: "Second Background")!
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
    
}
