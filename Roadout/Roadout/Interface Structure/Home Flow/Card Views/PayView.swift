//
//  PayView.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit

class PayView: UIView {
    
    var selectedCard: String?
    let applePayTitle = NSAttributedString(string: "Pay with Apple Pay".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .regular)])
    var mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let choosePaymentTitle = NSAttributedString(string: "Choose Payment Method".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        if returnToDelay {
            returnToDelay = false
            NotificationCenter.default.post(name: .removePayDelayCardID, object: nil)
        } else {
            NotificationCenter.default.post(name: .removePayCardID, object: nil)
        }
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var actionTypeLbl: UXResizeLabel!
    
    @IBOutlet weak var detailsCard: UIView!
    @IBOutlet weak var timeCard: UIView!
    
    @IBOutlet weak var payBtn: UXButton!
    @IBOutlet weak var chooseMethodBtn: UXButton!
    
    @IBAction func payTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        NotificationCenter.default.post(name: .removeSpotMarkerID, object: nil)
        
        if payBtn.titleLabel?.text != "Choose Payment Method".localized() {
            if returnToDelay {
                returnToDelay = false
                reservationTime += delayTime
                let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
                Task {
                    do {
                        try await ReservationManager.sharedInstance.delayReservationAsync(date: Date(), minutes: delayTime/60, userID: id)
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .showPaidBarID, object: nil)
                        }
                    } catch let err {
                        self.manageServerSideErrors(error: err)
                    }
                }
            } else {
                let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
                Task {
                    do {
                        try await ReservationManager.sharedInstance.makeReservationAsync(date: Date(), time: reservationTime/60, spotID: selectedSpot.rID, payment: 10, userID: id)
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .showPaidBarID, object: nil)
                        }
                    } catch let err {
                        self.manageServerSideErrors(error: err)
                    }
                }
            }
        }
    }
    
    @IBAction func chooseMethodTapped(_ sender: Any) {}
    
    //MARK: - View Configuration -
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCardsMenu), name: .refreshCardsMenuID, object: nil)
    }
    
    @objc func refreshCardsMenu() {
        UserDefaults.roadout!.set(cardNumbers, forKey: "ro.roadout.paymentMethods")
        cardNumbers = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.paymentMethods") ?? [String]()

        chooseMethodBtn.menu = UIMenu(title: "Choose Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        chooseMethodBtn.showsMenuAsPrimaryAction = true
        
        payBtn.menu = UIMenu(title: "Choose Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        payBtn.backgroundColor = UIColor(named: selectedLocation.accentColor)
        payBtn.showsMenuAsPrimaryAction = true
        payBtn.setAttributedTitle(choosePaymentTitle, for: .normal)
    }
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        manageObs()
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        
        preparePayButtons()
        fillReservationData(for: selectedSpot.rID)
        
        priceLbl.set(textColor: UIColor.Roadout.darkOrange, range: priceLbl.range(after: " - "))
        priceLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: priceLbl.range(after: " - "))
        
        if returnToDelay {
            titleLbl.text = "Pay Delay".localized()
        } else {
            titleLbl.text = "Pay Spot".localized()
        }
        
        detailsCard.layer.cornerRadius = detailsCard.frame.height/5
        timeCard.layer.cornerRadius = timeCard.frame.height/5
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[4] as! UIView
    }
    
    func fillReservationData(for spotID: String) {
        
        let parkLocationName = EntityManager.sharedInstance.decodeSpotID(spotID)[0]
        let parkSectionName = EntityManager.sharedInstance.decodeSpotID(spotID)[1]
        let parkSpotNr = EntityManager.sharedInstance.decodeSpotID(spotID)[2]
        
        self.detailsLbl.text = parkLocationName + " - " + "Section ".localized() + parkSectionName + " - " + "Spot ".localized() + parkSpotNr
        
        self.detailsLbl.set(textColor: UIColor.Roadout.darkOrange, range: self.detailsLbl.range(after: " - " + "Section ".localized(), before: " - " + "Spot ".localized()))
        self.detailsLbl.set(textColor: UIColor.Roadout.darkOrange, range: self.detailsLbl.range(after: " - " + "Spot ".localized()))
        self.detailsLbl.set(font: .systemFont(ofSize: 19, weight: .medium), range: self.detailsLbl.range(after: " - " + "Section ".localized(), before: " - " + "Spot ".localized()))
        self.detailsLbl.set(font: .systemFont(ofSize: 19, weight: .medium), range: self.detailsLbl.range(after: " - " + "Spot ".localized()))
        
        
        if returnToDelay {
            self.timeLbl.text = "\(Int(delayTime/60))" + " min".localized()
            self.actionTypeLbl.text = "Delay reservation for".localized()
            self.actionTypeLbl.longText = "Delay reservation for".localized()
            self.actionTypeLbl.mediumText = "Delay for".localized()
            self.actionTypeLbl.shortText = "Delay".localized()
        } else {
            self.timeLbl.text = "\(Int(reservationTime/60))" + " min".localized()
            self.actionTypeLbl.text = "Reserve parking for".localized()
            self.actionTypeLbl.longText = "Reserve parking for".localized()
            self.actionTypeLbl.mediumText = "Reserve for".localized()
            self.actionTypeLbl.shortText = "Reserve".localized()
        }
    }
    
    //MARK: - Payment Configuration -

    func preparePayButtons() {
        mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        payBtn.layer.cornerRadius = 12.0
        payBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        payBtn.setAttributedTitle(choosePaymentTitle, for: .normal)
        payBtn.backgroundColor = UIColor.Roadout.darkOrange
        
        chooseMethodBtn.layer.cornerRadius = 12.0
        chooseMethodBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        chooseMethodBtn.setTitle("", for: .normal)
        
        cardNumbers = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.paymentMethods") ?? [String]()
        selectedCard = UserPrefsUtils.sharedInstance.returnMainCard()
        
        chooseMethodBtn.menu = UIMenu(title: "Choose Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        chooseMethodBtn.showsMenuAsPrimaryAction = true
        
        payBtn.menu = UIMenu(title: "Choose Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        payBtn.showsMenuAsPrimaryAction = true
    }
    
    func reloadMainCard() {
        payBtn.showsMenuAsPrimaryAction = false
        payBtn.menu = nil

        mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        payBtn.setAttributedTitle(mainCardTitle, for: .normal)
        payBtn.backgroundColor = UIColor.Roadout.darkOrange
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
    
    //MARK: - Error Management -
    
    func manageServerSideErrors(error: Error) {
        switch error {
        case ReservationManager.ReservationErrors.spotAlreadyTaken:
                let alert = UIAlertController(title: "Couldn't reserve".localized(), message: "Something went wrong, it seems like someone already took the spot, hence we are not able to reserve it. We are sorry.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.networkError:
                let alert = UIAlertController(title: "Network Error".localized(), message: "Please check you network connection.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.databaseFailure:
                let alert = UIAlertController(title: "Internal Error".localized(), message: "There was an internal problem, please wait and try again a little later.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.unknownError:
                let alert = UIAlertController(title: "Unknown Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                self.parentViewController().present(alert, animated: true, completion: nil)
            case ReservationManager.ReservationErrors.errorWithJson:
                let alert = UIAlertController(title: "JSON Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                self.parentViewController().present(alert, animated: true, completion: nil)
            default:
                let alert = UIAlertController(title: "Unknown Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor.Roadout.redish
                self.parentViewController().present(alert, animated: true, completion: nil)
        }
    }
}
