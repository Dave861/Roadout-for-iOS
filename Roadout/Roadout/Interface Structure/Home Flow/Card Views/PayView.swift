//
//  PayView.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit

class PayView: UIView {
    
    let UserDefaultsSuite = UserDefaults.init(suiteName: "group.ro.roadout.Roadout")!
    var selectedCard: String?

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
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
            if returnToFind {
                returnToFind = false
            }
            
            if returnToDelay {
                returnToDelay = false
                timerSeconds += delaySeconds
                let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
                ReservationManager.sharedInstance.delayReservation(Date(), minutes: delaySeconds/60, userID: id) { result in
                    switch result {
                        case .success():
                            print("WE DELAYED")
                        case .failure(let err):
                            print(err)
                            self.manageServerSideErrors(error: err)
                    }
                }
            } else {
                let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
                ReservationManager.sharedInstance.makeReservation(Date(), time: timerSeconds/60, spotID: selectedSpotID, payment: 10, userID: id) { result in
                    switch result {
                        case .success():
                            print("WE RESERVED")
                        case .failure(let err):
                            print(err)
                            self.manageServerSideErrors(error: err)
                    }
                }
            }
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
    }
    
    @objc func refreshCardsMenu() {
        self.UserDefaultsSuite.set(cardNumbers, forKey: "ro.roadout.paymentMethods")
        cardNumbers = UserDefaultsSuite.stringArray(forKey: "ro.roadout.paymentMethods") ?? [String]()

        chooseMethodBtn.menu = UIMenu(title: "Choose a Payment method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        chooseMethodBtn.showsMenuAsPrimaryAction = true
        
        if payBtn.titleLabel?.text == "Choose Payment Method".localized() {
            payBtn.menu = UIMenu(title: "Choose a Payment method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
            payBtn.showsMenuAsPrimaryAction = true
        }
    }
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        manageObs()
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        
        mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        payBtn.layer.cornerRadius = 12.0
        payBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        payBtn.setAttributedTitle(choosePaymentTitle, for: .normal)
        payBtn.backgroundColor = UIColor(named: "Dark Orange")!
        
        chooseMethodBtn.layer.cornerRadius = 12.0
        chooseMethodBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        chooseMethodBtn.setTitle("", for: .normal)
        
        cardNumbers = UserDefaultsSuite.stringArray(forKey: "ro.roadout.paymentMethods") ?? [String]()
        selectedCard = UserPrefsUtils.sharedInstance.returnMainCard()
        
        fillReservationData(for: selectedSpotID)
        
        chooseMethodBtn.menu = UIMenu(title: "Choose a Payment method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        chooseMethodBtn.showsMenuAsPrimaryAction = true
        
        payBtn.menu = UIMenu(title: "Choose a Payment method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        payBtn.showsMenuAsPrimaryAction = true
        
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
    
    func fillReservationData(for spotID: String) {
        
        let parkLocationName = EntityManager.sharedInstance.decodeSpotID(spotID)[0]
        let parkSectionName = EntityManager.sharedInstance.decodeSpotID(spotID)[1]
        let parkSpotNr = EntityManager.sharedInstance.decodeSpotID(spotID)[2]
        
        self.detailsLbl.text = parkLocationName + " - Section ".localized() + parkSectionName + " - Spot ".localized() + parkSpotNr
        
        self.detailsLbl.set(textColor: UIColor(named: "Dark Orange")!, range: self.detailsLbl.range(after: " - Section ".localized(), before: " - Spot ".localized()))
        self.detailsLbl.set(textColor: UIColor(named: "Dark Orange")!, range: self.detailsLbl.range(after: " - Spot ".localized()))
        self.detailsLbl.set(font: .systemFont(ofSize: 19.0, weight: .medium), range: self.detailsLbl.range(after: " - Section ".localized(), before: " - Spot ".localized()))
        self.detailsLbl.set(font: .systemFont(ofSize: 19.0, weight: .medium), range: self.detailsLbl.range(after: " - Spot ".localized()))
        
        if returnToDelay {
            self.timeLbl.text = "Delay for ".localized() + "\(Int(delaySeconds/60))" + " minutes".localized()
            self.timeLbl.set(textColor: UIColor(named: "Dark Orange")!, range: self.timeLbl.range(after: "Delay for ".localized()))
            self.timeLbl.set(font: .systemFont(ofSize: 19.0, weight: .medium), range: self.timeLbl.range(after: "Delay for ".localized()))
        } else {
            self.timeLbl.text = "Reserve for ".localized() + "\(Int(timerSeconds/60))" + " minutes".localized()
            self.timeLbl.set(textColor: UIColor(named: "Dark Orange")!, range: self.timeLbl.range(after: "Reserve for ".localized()))
            self.timeLbl.set(font: .systemFont(ofSize: 19.0, weight: .medium), range: self.timeLbl.range(after: "Reserve for ".localized()))
        }
    }

    func reloadMainCard() {
        payBtn.showsMenuAsPrimaryAction = false
        payBtn.menu = nil

        mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        payBtn.setAttributedTitle(mainCardTitle, for: .normal)
        payBtn.backgroundColor = UIColor(named: "Dark Orange")!
    }
    
    func showApplePayBtn() {
        payBtn.showsMenuAsPrimaryAction = false
        payBtn.menu = nil
        
        payBtn.setAttributedTitle(applePayTitle, for: .normal)
        payBtn.backgroundColor = UIColor.label
    }
    
    func makeMenuActions(cards: [String]) -> [UIAction] {
        var menuItems = [UIAction]()
        
        let addAction = UIAction(title: "Add Card", image: UIImage(systemName: "plus")) { (_) in
            let sb = UIStoryboard(name: "Settings", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardViewController
            self.parentViewController().present(vc, animated: true, completion: nil)
        }
        menuItems.append(addAction)
        
        for card in cards {
            let action = UIAction(title: card, image: UIImage(systemName: "creditcard.fill"), handler: { (_) in
                self.UserDefaultsSuite.set(self.getIndexInArray(card, cards), forKey: "ro.roadout.defaultPaymentMethod")
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
    
    func manageServerSideErrors(error: Error) {
        switch error {
        case ReservationManager.ReservationErrors.spotAlreadyTaken:
                let alert = UIAlertController(title: "Couldn't reserve".localized(), message: "Sorry, the 60 seconds have passed and it seems like someone already took the spot, hence we are not able to reserve it. We are sorry.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.networkError:
                let alert = UIAlertController(title: "Network Error".localized(), message: "Please check you network connection.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.databaseFailure:
                let alert = UIAlertController(title: "Internal Error".localized(), message: "There was an internal problem, please wait and try again a little later.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.unknownError:
                let alert = UIAlertController(title: "Unknown Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.errorWithJson:
                let alert = UIAlertController(title: "JSON Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)
            default:
                let alert = UIAlertController(title: "Unknown Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)
        }
    }
    
}
