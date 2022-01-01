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
    
    let UserDefaultsSuite = UserDefaults.init(suiteName: "group.ro.roadout.Roadout")!
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableView: ContentSizedTableView!
    
    @IBOutlet weak var addBtnOutline: UIView!
    @IBOutlet weak var addCardBtn: UIButton!
    @IBAction func addCardTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    let buttonTitle = NSAttributedString(string: "Add Card",
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Dark Orange")!])
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView), name: .refreshCardsID, object: nil)
    }
    
    @objc func refreshTableView() {
        DispatchQueue.main.async {
            self.UserDefaultsSuite.set(cardNumbers, forKey: "ro.roadout.paymentMethods")
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObs()
        tableView.delegate = self
        tableView.dataSource = self
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        addCardBtn.setAttributedTitle(buttonTitle, for: .normal)
        addBtnOutline.layer.cornerRadius = 12.0
        cardNumbers = UserDefaultsSuite.stringArray(forKey: "ro.roadout.paymentMethods") ?? ["**** **** **** 9000", "**** **** **** 7250", "**** **** **** 7784", "**** **** **** 9432"]
        UserDefaultsSuite.set(cardNumbers, forKey: "ro.roadout.paymentMethods")
        cardIndex = UserDefaultsSuite.integer(forKey: "ro.roadout.defaultPaymentMethod")
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                let alert = UIAlertController(title: "Delete", message: "Do you want to delete this card?", preferredStyle: .actionSheet)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                    cardNumbers.remove(at: indexPath.row)
                    if self.cardIndex == indexPath.row {
                        self.cardIndex = 0
                        self.UserDefaultsSuite.set(indexPath.row, forKey: "ro.roadout.defaultPaymentMethod")
                    }
                    self.UserDefaultsSuite.set(cardNumbers, forKey: "ro.roadout.paymentMethods")
                    self.tableView.reloadData()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.view.tintColor = UIColor(named: "Dark Orange")
                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
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
        UserDefaultsSuite.set(indexPath.row, forKey: "ro.roadout.defaultPaymentMethod")
        tableView.reloadData()
    }
    
}
