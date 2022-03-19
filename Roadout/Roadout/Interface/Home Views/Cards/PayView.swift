//
//  PayView.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit

class PayView: UIView {
    
    var cardNumbers = [String]()
    let UserDefaultsSuite = UserDefaults.init(suiteName: "group.ro.roadout.Roadout")!
    var selectedCard: String?

    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if returnToDelay {
            returnToDelay = false
            NotificationCenter.default.post(name: .removePayDelayCardID, object: nil)
        } else if returnToFind {
            returnToFind = false
            NotificationCenter.default.post(name: .showFindCardID, object: nil)
        } else {
            NotificationCenter.default.post(name: .removePayCardID, object: nil)
        }
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var applePayBtn: UIButton!
    @IBOutlet weak var mainCardBtn: UIButton!
    @IBOutlet weak var differentPaymentBtn: UIButton!
    
    @IBAction func paidApplePay(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if returnToFind {
            returnToFind = false
        }
        
        if returnToDelay {
            returnToDelay = false
            timerSeconds += delaySeconds
            ReservationManager.sharedInstance.manageDelay()
        }
        
        ReservationManager.sharedInstance.saveReservationDate(Date().addingTimeInterval(TimeInterval(timerSeconds)))
        ReservationManager.sharedInstance.saveActiveReservation(true)
        
        if UserPrefsUtils.sharedInstance.reservationNotificationsEnabled() {
            NotificationHelper.sharedInstance.scheduleReservationNotification()
        }
        NotificationCenter.default.post(name: .showPaidBarID, object: nil)
    }
    
    @IBAction func payMainCard(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if returnToFind {
            returnToFind = false
        }
        
        if returnToDelay {
            returnToDelay = false
            timerSeconds += delaySeconds
            ReservationManager.sharedInstance.manageDelay()
        }
        
        ReservationManager.sharedInstance.saveReservationDate(Date().addingTimeInterval(TimeInterval(timerSeconds)))
        ReservationManager.sharedInstance.saveActiveReservation(true)
        
        if UserPrefsUtils.sharedInstance.reservationNotificationsEnabled() {
            NotificationHelper.sharedInstance.scheduleReservationNotification()
        }
        NotificationCenter.default.post(name: .showPaidBarID, object: nil)
    }
    
    @IBAction func selectDifferentPayment(_ sender: Any) {
        let sb = UIStoryboard(name: "Settings", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentViewController
        self.parentViewController().navigationController?.pushViewController(vc, animated: true)
    }
    
    
    let applePayTitle = NSAttributedString(string: " Apple Pay".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .regular)])
    var mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let diffPaymentTitle = NSAttributedString(string: "Different Payment Method".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        backBtn.setTitle("", for: .normal)
        
        applePayBtn.layer.cornerRadius = 12.0
        applePayBtn.setAttributedTitle(applePayTitle, for: .normal)
        mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        mainCardBtn.layer.cornerRadius = 12.0
        mainCardBtn.setAttributedTitle(mainCardTitle, for: .normal)
        differentPaymentBtn.layer.cornerRadius = 12.0
        differentPaymentBtn.setAttributedTitle(diffPaymentTitle, for: .normal)
        
        cardNumbers = UserDefaultsSuite.stringArray(forKey: "ro.roadout.paymentMethods") ?? ["**** **** **** 9000", "**** **** **** 7250", "**** **** **** 7784", "**** **** **** 9432"]
        selectedCard = UserPrefsUtils.sharedInstance.returnMainCard()
        
        if #available(iOS 14.0, *) {
            differentPaymentBtn.menu = UIMenu(title: "Choose a card".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
            differentPaymentBtn.showsMenuAsPrimaryAction = true
        }
        
        priceLbl.set(textColor: UIColor(named: "Dark Orange")!, range: priceLbl.range(after: " - "))
        priceLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: priceLbl.range(after: " - "))
        
        if returnToDelay {
            titleLbl.text = "Pay Delay".localized()
        } else {
            titleLbl.text = "Pay Spot".localized()
        }
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[4] as! UIView
    }

    func reloadMainCard() {
        print("HERE")
        mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        mainCardBtn.setAttributedTitle(mainCardTitle, for: .normal)
    }
    
    func makeMenuActions(cards: [String]) -> [UIAction] {
        var menuItems = [UIAction]()
        for card in cards {
            let action = UIAction(title: card, image: nil, handler: { (_) in
                self.UserDefaultsSuite.set(self.getIndexInArray(card, cards), forKey: "ro.roadout.defaultPaymentMethod")
                self.reloadMainCard()
            })
            menuItems.append(action)
        }
        
        return menuItems
    }
    
    func getIndexInArray(_ element: String, _ array: [String]) -> Int {
        var index = 0
        for el in array {
            if el == element {
                break
            }
            index += 1
        }
        print(index)
        return index
    }
    
}
