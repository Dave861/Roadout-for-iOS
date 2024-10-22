//
//  PaymentViewController.swift
//  Roadout
//
//  Created by David Retegan on 28.10.2021.
//

import UIKit

class PaymentViewController: UIViewController {
    
    let buttonTitle = NSAttributedString(string: "Add Card".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor.Roadout.darkOrange])
            
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
            UserDefaults.roadout!.set(cardNumbers, forKey: "eu.roadout.paymentMethods")
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
        cardNumbers = UserDefaults.roadout!.stringArray(forKey: "eu.roadout.paymentMethods") ?? [String]()
        UserDefaults.roadout!.set(cardNumbers, forKey: "eu.roadout.paymentMethods")
        tableView.reloadData()
        
        if cardNumbers.count == 0 {
            addBtnOutline.isHidden = true
            placeholderView.isHidden = false
        } else {
            addBtnOutline.isHidden = false
            placeholderView.isHidden = true
        }
        
        if self.tableView.layer.mask == nil {
            let maskLayer: CAGradientLayer = CAGradientLayer()

            maskLayer.locations = [0.0, 0.2, 0.8, 1.0]
            let width = self.tableView.frame.size.width
            let height = self.tableView.frame.size.height
            maskLayer.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: height)
            maskLayer.anchorPoint = CGPoint.zero

            self.tableView.layer.mask = maskLayer
        }

        scrollViewDidScroll(self.tableView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let outerColor = UIColor(white: 1.0, alpha: 0.0).cgColor
        let innerColor = UIColor(white: 1.0, alpha: 1.0).cgColor

        var colors = [CGColor]()

        if scrollView.contentOffset.y + scrollView.contentInset.top <= 0 {
            colors = [innerColor, innerColor, innerColor, outerColor]
        } else if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
            colors = [outerColor, innerColor, innerColor, innerColor]
        } else {
            colors = [outerColor, innerColor, innerColor, outerColor]
        }

        if let mask = scrollView.layer.mask as? CAGradientLayer {
            mask.colors = colors

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            mask.position = CGPoint(x: 0.0, y: scrollView.contentOffset.y)
            CATransaction.commit()
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
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
        let deleteAction = UIContextualAction(style: .normal, title: "   Remove Card".localized()) { _, _, completion in
            let alert = UIAlertController(title: "Remove".localized(), message: "Do you want to remove this card?".localized(), preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Remove".localized(), style: .destructive) { action in
                cardNumbers.remove(at: indexPath.row)
                UserDefaults.roadout!.set(cardNumbers, forKey: "eu.roadout.paymentMethods")
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
            alert.view.tintColor = UIColor.Roadout.darkOrange
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
