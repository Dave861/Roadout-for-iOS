//
//  PayParkingView.swift
//  Roadout
//
//  Created by David Retegan on 20.07.2022.
//

import UIKit

class PayParkingView: UIView {

    var selectedCard: String?

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removePayParkingCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var licensePlateLbl: UILabel!
    @IBOutlet weak var editLicensePlateBtn: UIButton!
    @IBAction func editLicensePlateTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "EditLicensePlateVC") as! EditLicensePlateViewController
        self.parentViewController().present(vc, animated: true)
    }
    
    let editPlateTitle = NSAttributedString(string: "EDIT".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .semibold)])
    let addPlateTitle = NSAttributedString(string: "ADD".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .semibold)])
    
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var chooseMethodBtn: UIButton!
    
    @IBAction func payTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if payBtn.titleLabel?.text == "Choose Payment Method".localized() {
            //Handled by menu
        } else {
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
    
    @IBAction func chooseMethodTapped(_ sender: Any) {
        //Handled by menu
    }
        
    let applePayTitle = NSAttributedString(string: "Pay with Apple Pay".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .regular)])
    var mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let choosePaymentTitle = NSAttributedString(string: "Choose Payment Method".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCardsMenu), name: .refreshCardsMenuID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLicensePlate), name: .reloadLicensePlateID, object: nil)
    }
    
    @objc func refreshCardsMenu() {
        UserDefaults.roadout!.set(cardNumbers, forKey: "ro.roadout.paymentMethods")
        cardNumbers = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.paymentMethods") ?? [String]()

        chooseMethodBtn.menu = UIMenu(title: "Choose a Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        chooseMethodBtn.showsMenuAsPrimaryAction = true
        
        payBtn.menu = UIMenu(title: "Choose a Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        payBtn.showsMenuAsPrimaryAction = true
        payBtn.setAttributedTitle(choosePaymentTitle, for: .normal)
    }
    
    @objc func refreshLicensePlate() {
        self.licensePlateLbl.text = userLicensePlate
        if userLicensePlate == "NO-PLATE" {
            self.editLicensePlateBtn.setAttributedTitle(addPlateTitle, for: .normal)
        } else {
            self.editLicensePlateBtn.setAttributedTitle(editPlateTitle, for: .normal)
        }
    }
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        manageObs()
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        editLicensePlateBtn.layer.cornerRadius = editLicensePlateBtn.frame.height/2
        
        licensePlateLbl.text = userLicensePlate
        if userLicensePlate == "NO-PLATE" {
            editLicensePlateBtn.setAttributedTitle(addPlateTitle, for: .normal)
        } else {
            editLicensePlateBtn.setAttributedTitle(editPlateTitle, for: .normal)
        }
        
        mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        payBtn.layer.cornerRadius = 12.0
        payBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        payBtn.setAttributedTitle(choosePaymentTitle, for: .normal)
        payBtn.backgroundColor = UIColor(named: "Cash Yellow")!
        
        chooseMethodBtn.layer.cornerRadius = 12.0
        chooseMethodBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        chooseMethodBtn.setTitle("", for: .normal)
        
        cardNumbers = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.paymentMethods") ?? [String]()
        selectedCard = UserPrefsUtils.sharedInstance.returnMainCard()
        
        fillPayData()
        
        chooseMethodBtn.menu = UIMenu(title: "Choose a Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        chooseMethodBtn.showsMenuAsPrimaryAction = true
        
        payBtn.menu = UIMenu(title: "Choose a Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        payBtn.showsMenuAsPrimaryAction = true
        
        priceLbl.set(textColor: UIColor(named: "Cash Yellow")!, range: priceLbl.range(after: " - "))
        priceLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: priceLbl.range(after: " - "))
        
        titleLbl.text = "Pay Parking".localized()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Pay", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }
    
    func fillPayData() {
        self.detailsLbl.text = selectedPayLocation.name
        
        self.timeLbl.text = "Pay for ".localized() + "\(paidHours)" + " hours".localized()
        self.timeLbl.set(textColor: UIColor(named: "Cash Yellow")!, range: self.timeLbl.range(after: "Pay for ".localized()))
        self.timeLbl.set(font: .systemFont(ofSize: 19.0, weight: .medium), range: self.timeLbl.range(after: "Pay for ".localized()))
    }

    func reloadMainCard() {
        payBtn.showsMenuAsPrimaryAction = false
        payBtn.menu = nil

        mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        payBtn.setAttributedTitle(mainCardTitle, for: .normal)
        payBtn.backgroundColor = UIColor(named: "Cash Yellow")!
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
        print(index)
        return index
    }
    

}
