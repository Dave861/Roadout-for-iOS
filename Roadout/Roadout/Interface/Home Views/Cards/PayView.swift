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
                        selectedSpotID = nil
                    case .failure(let err):
                        print(err)
                        self.manageServerSideErrors(error: err)
                }
            }
        }
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
                        selectedSpotID = nil
                    case .failure(let err):
                        print(err)
                        self.manageServerSideErrors(error: err)
                }
            }
        }
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
