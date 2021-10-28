//
//  PaymentViewController.swift
//  Roadout
//
//  Created by David Retegan on 28.10.2021.
//

import UIKit

var cardNumbers = ["**** **** **** 9000", "**** **** **** 7250", "**** **** **** 7784", "**** **** **** 9432"]

class PaymentViewController: UIViewController {
    
    var cardIndex = 0
    var indexNr = 0
    
    let refreshCardsID = "ro.codebranch.Roadout.refreshCards"
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableView: ContentSizedTableView!
    
    @IBOutlet weak var addBtnOutline: UIView!
    @IBOutlet weak var addCardBtn: UIButton!
    @IBAction func addCardTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    let buttonTitle = NSAttributedString(string: "Add Card",
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Dark Orange")!])
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView), name: Notification.Name(refreshCardsID), object: nil)
    }
    
    @objc func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObs()
        tableView.delegate = self
        tableView.dataSource = self
        backButton.setTitle("", for: .normal)
        addCardBtn.setAttributedTitle(buttonTitle, for: .normal)
        addBtnOutline.layer.cornerRadius = 12.0
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func decideColor() -> Int {
        if indexNr%4 == 0 {
            return 4
        } else if indexNr%3 == 0 {
            return 3
        } else if indexNr%2 == 0 {
            return 2
        } else {
            return 1
        }
    }

    
}
extension PaymentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell") as! CardCell
        cell.cardNrLbl.text = cardNumbers[indexPath.row]
        indexNr = indexPath.row
        let randomNr = decideColor()
        cell.cardNrLbl.textColor = UIColor(named: "Card\(randomNr)")
        cell.cardIcon.image = UIImage(named: "Card\(randomNr)")
        if cardIndex == indexPath.row {
            cell.selectedImg.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            cell.selectedImg.image = UIImage(systemName: "circle")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        cardIndex = indexPath.row
        tableView.reloadData()
    }
}
