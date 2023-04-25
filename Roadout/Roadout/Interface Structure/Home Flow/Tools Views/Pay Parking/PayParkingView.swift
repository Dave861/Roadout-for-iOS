//
//  PayParkingView.swift
//  Roadout
//
//  Created by David Retegan on 20.07.2022.
//

import UIKit

class PayParkingView: UXView {

    var selectedCard: String?
    let applePayTitle = NSAttributedString(string: "Pay with Apple Pay".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .regular)])
    var mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let choosePaymentTitle = NSAttributedString(string: "Choose Payment Method".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removePayParkingCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: - Swipe Gesture Configuration -
    
    override func viewSwipedBack() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removePayParkingCardID, object: nil)
    }
    
    override func excludePansFrom(touch: UITouch) -> Bool {
        return !payBtn.bounds.contains(touch.location(in: payBtn)) && !chooseMethodBtn.bounds.contains(touch.location(in: chooseMethodBtn)) && !backBtn.bounds.contains(touch.location(in: backBtn))
    }
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var licensePlateLbl: UILabel!
    @IBOutlet weak var editLicensePlateBtn: UIButton!
    @IBAction func editLicensePlateTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "EditLicensePlateVC") as! EditLicensePlateViewController
        self.parentViewController().present(vc, animated: true)
    }
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var licensePlateCard: UIView!
    @IBOutlet weak var timeCard: UIView!
    
    @IBOutlet weak var timeBtn: UIButton!
    @IBAction func timeTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .removePayParkingCardID, object: nil)
    }
    
    @IBOutlet weak var payBtn: UXButton!
    @IBOutlet weak var chooseMethodBtn: UXButton!
    
    @IBAction func payTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if payBtn.titleLabel?.text != "Choose Payment Method".localized() {
            let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
            //API call for continuity when app is opened again (to prevent showing unlocked view and mark reservation as done)
            Task {
                do {
                    try await ReservationManager.sharedInstance.checkForReservationAsync(date: Date(), userID: id)
                } catch let err {
                    print(err)
                }
            }
            isPayFlow = false
            NotificationCenter.default.post(name: .showPaidParkingBarID, object: nil)
        }
    }
    
    @IBAction func chooseMethodTapped(_ sender: Any) {}
        
    //MARK: - View Configuration -
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCardsMenu), name: .refreshCardsMenuID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLicensePlate), name: .reloadLicensePlateID, object: nil)
    }
    
    @objc func refreshCardsMenu() {
        UserDefaults.roadout!.set(cardNumbers, forKey: "ro.roadout.paymentMethods")
        cardNumbers = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.paymentMethods") ?? [String]()

        chooseMethodBtn.menu = UIMenu(title: "Choose Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        chooseMethodBtn.showsMenuAsPrimaryAction = true
        
        payBtn.menu = UIMenu(title: "Choose Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        payBtn.showsMenuAsPrimaryAction = true
        payBtn.setAttributedTitle(choosePaymentTitle, for: .normal)
    }
    
    @objc func refreshLicensePlate() {
        self.licensePlateLbl.text = userLicensePlate != "" ? userLicensePlate : "ADD-PLATE".localized()
    }
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        manageObs()
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        
        timeBtn.setTitle("", for: .normal)
        editLicensePlateBtn.setTitle("", for: .normal)
        
        mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        payBtn.layer.cornerRadius = 12.0
        payBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        payBtn.setAttributedTitle(choosePaymentTitle, for: .normal)
        payBtn.backgroundColor = UIColor.Roadout.cashYellow
        
        chooseMethodBtn.layer.cornerRadius = 12.0
        chooseMethodBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        chooseMethodBtn.setTitle("", for: .normal)
        
        cardNumbers = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.paymentMethods") ?? [String]()
        selectedCard = UserPrefsUtils.sharedInstance.returnMainCard()
        
        fillPayData()
        
        chooseMethodBtn.menu = UIMenu(title: "Choose Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        chooseMethodBtn.showsMenuAsPrimaryAction = true
        
        payBtn.menu = UIMenu(title: "Choose Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        payBtn.showsMenuAsPrimaryAction = true
        
        priceLbl.set(textColor: UIColor.Roadout.cashYellow, range: priceLbl.range(after: " - "))
        priceLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: priceLbl.range(after: " - "))
        
        licensePlateCard.layer.cornerRadius = licensePlateCard.frame.height/5
        timeCard.layer.cornerRadius = timeCard.frame.height/5
        
        self.accentColor = UIColor.Roadout.cashYellow
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Pay", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }
    
    //MARK: - Payment Configuration -
    
    func fillPayData() {
        timeLbl.text = "\(paidTime)" + " hr/s".localized()
        licensePlateLbl.text = userLicensePlate != "" ? userLicensePlate : "ADD-PLATE".localized()
    }

    func reloadMainCard() {
        payBtn.showsMenuAsPrimaryAction = false
        payBtn.menu = nil

        mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        payBtn.setAttributedTitle(mainCardTitle, for: .normal)
        payBtn.backgroundColor = UIColor.Roadout.cashYellow
    }
    
    func showApplePayBtn() {
        payBtn.showsMenuAsPrimaryAction = false
        payBtn.menu = nil
        
        payBtn.setAttributedTitle(applePayTitle, for: .normal)
        payBtn.backgroundColor = UIColor.label
    }
    
    func makeMenuActions(cards: [String]) -> [UIAction] {
        var menuItems = [UIAction]()
        
        let addAction = UIAction(title: "Add Card".localized(), image: UIImage(systemName: "plus")) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.payBtn.transform = CGAffineTransform.identity
                self.chooseMethodBtn.transform = CGAffineTransform.identity
            })
            let sb = UIStoryboard(name: "Settings", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardViewController
            self.parentViewController().present(vc, animated: true, completion: nil)
        }
        menuItems.append(addAction)
        
        for card in cards {
            let action = UIAction(title: card, image: UIImage(systemName: "creditcard.fill"), handler: { (_) in
                UserDefaults.roadout!.set(self.getIndexInArray(card, cards), forKey: "ro.roadout.defaultPaymentMethod")
                self.reloadMainCard()
            })
            menuItems.append(action)
        }
        
        let applePayAction = UIAction(title: "Apple Pay", image: UIImage(systemName: "applelogo")) { (_) in
            self.showApplePayBtn()
        }
        menuItems.append(applePayAction)
        
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
        return index
    }

}
