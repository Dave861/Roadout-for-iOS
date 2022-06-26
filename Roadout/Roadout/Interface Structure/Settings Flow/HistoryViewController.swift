//
//  HistoryViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit

class HistoryViewController: UIViewController {
    
    let historyDates = ["15.10.2021", "08.10.2021", "27.09.2021"]
    let historyLocations = ["Location".localized()+" 1 - "+"Section ".localized()+"A - "+"Spot ".localized()+"2", "Location".localized()+" 2 - "+"Section ".localized()+"E - "+"Spot ".localized()+"3", "Location".localized()+" 3 - "+"Section ".localized()+"C - "+"Spot ".localized()+"11"]
    let historyTimes = ["11" + " minutes".localized() + " - ", "8" + " minutes".localized() + " + 5" + " minutes".localized() + " - ", "15" + " minutes".localized() + " + 10" + " minutes".localized() + " - "]
    let historyPrices = ["15 RON", "21 RON", "25 RON"]

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

}
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        cell.dateLbl.text = historyDates[indexPath.row]
        cell.placeLbl.text = historyLocations[indexPath.row]
        cell.timeLbl.text = historyTimes[indexPath.row]
        cell.priceLbl.text = historyPrices[indexPath.row]
        return cell
    }
}
