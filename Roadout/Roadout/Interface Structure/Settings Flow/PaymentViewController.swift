//
//  PaymentViewController.swift
//  Roadout
//
//  Created by David Retegan on 28.10.2021.
//

import UIKit

class PaymentViewController: UIViewController {
    
    let buttonTitle = NSAttributedString(string: "Add Card".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Dark Orange")!])
            
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderText: UILabel!
    @IBOutlet weak var placeholderAddBtn: UIButton!
    
    @IBAction func placeholderAddTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var addBtnOutline: UIView!
    @IBOutlet weak var addCardBtn: UIButton!
    @IBAction func addCardTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - View Configuration -
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView), name: .refreshCardsID, object: nil)
    }
    
    @objc func refreshTableView() {
        DispatchQueue.main.async {
            UserDefaults.roadout!.set(cardNumbers, forKey: "ro.roadout.paymentMethods")
            self.tableView.reloadData()
            if cardNumbers.count == 0 {
                self.addBtnOutline.isHidden = true
                self.placeholderView.isHidden = false
            } else {
                self.addBtnOutline.isHidden = false
                self.placeholderView.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObs()
        tableView.delegate = self
        tableView.dataSource = self
        addCardBtn.setAttributedTitle(buttonTitle, for: .normal)
        addBtnOutline.layer.cornerRadius = 12.0
        cardNumbers = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.paymentMethods") ?? [String]()
        UserDefaults.roadout!.set(cardNumbers, forKey: "ro.roadout.paymentMethods")
        tableView.reloadData()
        if cardNumbers.count == 0 {
            addBtnOutline.isHidden = true
            placeholderView.isHidden = false
        } else {
            addBtnOutline.isHidden = false
            placeholderView.isHidden = true
        }
    }
    
    func decideColor(for index: Int) -> Int {
        if index%4 == 0 {
            return 4
        } else if index%3 == 0 {
            return 3
        } else if index%2 == 0 {
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
        let colorNr = decideColor(for: indexPath.row+1)
        cell.cardNrLbl.textColor = UIColor(named: "Card\(colorNr)")
        cell.cardIcon.image = UIImage(named: "Card\(colorNr)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "  Delete Card".localized()) { _, _, completion in
            let alert = UIAlertController(title: "Delete".localized(), message: "Do you want to delete this card?".localized(), preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Delete".localized(), style: .destructive) { action in
                cardNumbers.remove(at: indexPath.row)
                UserDefaults.roadout!.set(cardNumbers, forKey: "ro.roadout.paymentMethods")
                tableView.reloadData()
                if cardNumbers.count == 0 {
                    self.addBtnOutline.isHidden = true
                    self.placeholderView.isHidden = false
                } else {
                    self.addBtnOutline.isHidden = false
                    self.placeholderView.isHidden = true
                }
                NotificationCenter.default.post(name: .refreshCardsMenuID, object: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
            alert.view.tintColor = UIColor(named: "Dark Orange")
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            completion(true)
        }
        deleteAction.backgroundColor = UIColor(named: "Second Background")!
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
}
