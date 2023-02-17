//
//  HistoryViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit

var historyItems = [
    HistoryItem(parkingSpotID: "Cluj.Eroilor.A.10", time: 12, price: 8.7, date: Date()),
    HistoryItem(parkingSpotID: "Cluj.Marasti.B.2", time: 11, price: 7.6, date: Date()),
    HistoryItem(parkingSpotID: "Cluj.OldTown.C.1", time: 17, price: 11.5, date: Date()),
    HistoryItem(parkingSpotID: "Cluj.Manastur.D.5", time: 20, price: 16.0, date: Date())
]

class HistoryViewController: UIViewController {
    
    let dates = ["12.01.2023", "10.01.2023", "02.01.2023", "29.12.2022"]
    var weekHistoryItems = [HistoryItem]()
    var olderHistoryItems = [HistoryItem]()

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var placeholderView: UIView!
    
    @IBOutlet weak var clearCard: UIView!
    @IBOutlet weak var clearBtn: UIButton!
    @IBAction func clearTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        historyItems = [HistoryItem]()
        weekHistoryItems = [HistoryItem]()
        olderHistoryItems = [HistoryItem]()
        loadTableViewData()
    }
    
    let buttonTitle = NSAttributedString(string: "Clear".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Dark Yellow")!])
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        clearBtn.setAttributedTitle(buttonTitle, for: .normal)
        clearCard.layer.cornerRadius = 12.0
        loadTableViewData()
    }
    
    func loadHistoryItems() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        
        for index in 0...historyItems.count-1 {
            var historyItem = historyItems[index]
            historyItem.date = dateFormatter.date(from: dates[index])!
            if historyItem.date >= lastWeek {
                weekHistoryItems.append(historyItem)
            } else {
                olderHistoryItems.append(historyItem)
            }
        }
        tableView.reloadData()
    }
    
    func loadTableViewData() {
        if historyItems.count > 0 {
            placeholderView.isHidden = true
            clearCard.isHidden = false
            loadHistoryItems()
        } else {
            placeholderView.isHidden = false
            clearCard.isHidden = true
            tableView.reloadData()
        }
    }

}
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historyItems.count != 0 {
            if weekHistoryItems.isEmpty {
                return historyItems.count + 1
            } else {
                return historyItems.count + 2
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if weekHistoryItems.isEmpty {
           //We only have older
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryHeaderCell") as! HeaderCell
                cell.titleLbl.text = "Older"
                return cell
            } else {
                let currentIndex = indexPath.row-1
                let locationName = EntityManager.sharedInstance.decodeSpotID(olderHistoryItems[currentIndex].parkingSpotID)[0]
                let sectionLetter = EntityManager.sharedInstance.decodeSpotID(olderHistoryItems[currentIndex].parkingSpotID)[1]
                let spotNumber = EntityManager.sharedInstance.decodeSpotID(olderHistoryItems[currentIndex].parkingSpotID)[2]
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
                cell.placeLbl.text = locationName + " - Section " + sectionLetter + " - Spot " + spotNumber
                cell.placeLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: cell.placeLbl.range(string: sectionLetter))
                cell.placeLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: cell.placeLbl.range(string: spotNumber))
                cell.placeLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: cell.placeLbl.range(string: sectionLetter))
                cell.placeLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: cell.placeLbl.range(string: spotNumber))
                
                cell.timePriceLbl.text = "\(olderHistoryItems[currentIndex].time) min - \(olderHistoryItems[currentIndex].price) RON"
                cell.timePriceLbl.set(font: .systemFont(ofSize: 16, weight: .medium), range: cell.timePriceLbl.range(string: "\(olderHistoryItems[currentIndex].price) RON"))
                cell.timePriceLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: cell.timePriceLbl.range(string: "\(olderHistoryItems[currentIndex].price) RON"))
                return cell
            }
        } else {
            //We have all three
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryHeaderCell") as! HeaderCell
                cell.titleLbl.text = "This Week"
                return cell
            } else if indexPath.row <= weekHistoryItems.count {
                let currentIndex = indexPath.row-1
                let locationName = EntityManager.sharedInstance.decodeSpotID(weekHistoryItems[currentIndex].parkingSpotID)[0]
                let sectionLetter = EntityManager.sharedInstance.decodeSpotID(weekHistoryItems[currentIndex].parkingSpotID)[1]
                let spotNumber = EntityManager.sharedInstance.decodeSpotID(weekHistoryItems[currentIndex].parkingSpotID)[2]
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
                cell.placeLbl.text = locationName + " - Section " + sectionLetter + " - Spot " + spotNumber
                cell.placeLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: cell.placeLbl.range(string: sectionLetter))
                cell.placeLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: cell.placeLbl.range(string: spotNumber))
                cell.placeLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: cell.placeLbl.range(string: sectionLetter))
                cell.placeLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: cell.placeLbl.range(string: spotNumber))
                
                cell.timePriceLbl.text = "\(weekHistoryItems[currentIndex].time) min - \(weekHistoryItems[currentIndex].price) RON"
                cell.timePriceLbl.set(font: .systemFont(ofSize: 16, weight: .medium), range: cell.timePriceLbl.range(string: "\(weekHistoryItems[currentIndex].price) RON"))
                cell.timePriceLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: cell.timePriceLbl.range(string: "\(weekHistoryItems[currentIndex].price) RON"))
                return cell
                
            } else if indexPath.row == weekHistoryItems.count+1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryHeaderCell") as! HeaderCell
                cell.titleLbl.text = "Older"
                return cell
            } else {
                let currentIndex = indexPath.row-weekHistoryItems.count-2
                let locationName = EntityManager.sharedInstance.decodeSpotID(olderHistoryItems[currentIndex].parkingSpotID)[0]
                let sectionLetter = EntityManager.sharedInstance.decodeSpotID(olderHistoryItems[currentIndex].parkingSpotID)[1]
                let spotNumber = EntityManager.sharedInstance.decodeSpotID(olderHistoryItems[currentIndex].parkingSpotID)[2]
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
                cell.placeLbl.text = locationName + " - Section " + sectionLetter + " - Spot " + spotNumber
                cell.placeLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: cell.placeLbl.range(string: sectionLetter))
                cell.placeLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: cell.placeLbl.range(string: spotNumber))
                cell.placeLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: cell.placeLbl.range(string: sectionLetter))
                cell.placeLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: cell.placeLbl.range(string: spotNumber))
                
                cell.timePriceLbl.text = "\(olderHistoryItems[currentIndex].time) min - \(olderHistoryItems[currentIndex].price) RON"
                
                return cell
            }
        }
    }
}
