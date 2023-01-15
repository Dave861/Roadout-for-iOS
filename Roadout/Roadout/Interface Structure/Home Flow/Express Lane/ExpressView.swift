//
//  ExpressView.swift
//  Roadout
//
//  Created by David Retegan on 07.11.2021.
//

import UIKit
import WidgetKit

class ExpressView: UIView {
    
    let UserDefaultsSuite = UserDefaults.init(suiteName: "group.ro.roadout.Roadout")!
    var selectedCard: String?
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var chargeLbl: UILabel!
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeSpotMarkerID, object: nil)
        NotificationCenter.default.post(name: .returnToSearchBarID, object: nil)
    }
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func sliderChangedValue(_ sender: Any) {
        let roundedValue = round(slider.value/1.0)*1.0
        slider.value = roundedValue
        chargeLbl.text = "\(Int(slider.value))" + " Minute/s".localized() + " - \(Int(slider.value)) RON"
        chargeLbl.set(textColor: UIColor(named: "ExpressFocus")!, range: chargeLbl.range(after: " - "))
        chargeLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: chargeLbl.range(after: " - "))
    }
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var spotSectionLbl: UILabel!
    
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var chooseMethodBtn: UIButton!
        
    @IBAction func payBtnTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        timerSeconds = Int(slider.value*60)
        
        if payBtn.titleLabel?.text == "Choose Payment Method".localized() {
            //Handled by menu
        } else {
            NotificationCenter.default.post(name: .removeSpotMarkerID, object: nil)
            
            let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
            Task {
                do {
                    try await ReservationManager.sharedInstance.makeReservationAsync(date: Date(),
                                                                                     time: timerSeconds/60,
                                                                                     spotID: selectedSpotID,
                                                                                     payment: 10,
                                                                                     userID: id)
                    DispatchQueue.main.async {
                        WidgetCenter.shared.reloadAllTimelines()
                        NotificationCenter.default.post(name: .showPaidBarID, object: nil)
                    }
                } catch let err {
                    self.manageServerSideErrors(error: err)
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
        
        chooseMethodBtn.menu = UIMenu(title: "Choose a Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        chooseMethodBtn.showsMenuAsPrimaryAction = true
        
        if payBtn.titleLabel?.text == "Choose Payment Method".localized() {
            payBtn.menu = UIMenu(title: "Choose a Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
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
        payBtn.backgroundColor = UIColor(named: "ExpressFocus")!
        
        chooseMethodBtn.layer.cornerRadius = 12.0
        chooseMethodBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        chooseMethodBtn.setTitle("", for: .normal)
        
        chargeLbl.set(textColor: UIColor(named: "ExpressFocus")!, range: chargeLbl.range(after: " - "))
        chargeLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: chargeLbl.range(after: " - "))
        
        cardNumbers = UserDefaultsSuite.stringArray(forKey: "ro.roadout.paymentMethods") ?? [String]()
        selectedCard = UserPrefsUtils.sharedInstance.returnMainCard()
                

        chooseMethodBtn.menu = UIMenu(title: "Choose a Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        chooseMethodBtn.showsMenuAsPrimaryAction = true
        
        payBtn.menu = UIMenu(title: "Choose a Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        payBtn.showsMenuAsPrimaryAction = true
        
                
        locationLbl.text = parkLocations[selectedParkLocationIndex].name
        spotSectionLbl.text = "Section ".localized() + FunctionsManager.sharedInstance.foundSection.name + " - Spot ".localized() + "\(FunctionsManager.sharedInstance.foundSpot.number)"
        
        spotSectionLbl.set(textColor: UIColor(named: "ExpressFocus")!, range: spotSectionLbl.range(after: "Section ".localized(), before: " - Spot ".localized()))
        spotSectionLbl.set(textColor: UIColor(named: "ExpressFocus")!, range: spotSectionLbl.range(after: " - Spot ".localized()))
        spotSectionLbl.set(font: UIFont.systemFont(ofSize: 19, weight: .medium), range: spotSectionLbl.range(after: "Section ".localized(), before: " - Spot ".localized()))
        spotSectionLbl.set(font: UIFont.systemFont(ofSize: 19, weight: .medium), range: spotSectionLbl.range(after: " - Spot ".localized()))
        
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Express", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func reloadMainCard() {
        payBtn.showsMenuAsPrimaryAction = false
        payBtn.menu = nil
        
        mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        payBtn.setAttributedTitle(mainCardTitle, for: .normal)
        payBtn.backgroundColor = UIColor(named: "ExpressFocus")!
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
