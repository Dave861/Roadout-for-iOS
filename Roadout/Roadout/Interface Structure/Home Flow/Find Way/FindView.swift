//
//  FindView.swift
//  Roadout
//
//  Created by David Retegan on 01.12.2021.
//

import UIKit
import WidgetKit

class FindView: UIView {
    
    var selectedCard: String?
    
    @IBOutlet weak var tipSourceView: UIView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeSpotMarkerID, object: nil)
        NotificationCenter.default.post(name: .returnToSearchBarID, object: nil)
    }
    
    @IBOutlet weak var chargeLbl: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func sliderChangedValue(_ sender: Any) {
        let roundedValue = round(slider.value/1.0)*1.0
        slider.value = roundedValue
        chargeLbl.text = "\(Int(slider.value))" + " Minute/s".localized() + " - \(Int(slider.value)) RON"
        chargeLbl.set(textColor: UIColor(named: "Greyish")!, range: chargeLbl.range(after: " - "))
        chargeLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: chargeLbl.range(after: " - "))
    }
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var spotSectionLbl: UILabel!
    
    @IBOutlet weak var payBtn: UXButton!
    @IBOutlet weak var chooseMethodBtn: UXButton!
        
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
        UserDefaults.roadout!.set(cardNumbers, forKey: "ro.roadout.paymentMethods")
        cardNumbers = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.paymentMethods") ?? [String]()
        
        chooseMethodBtn.menu = UIMenu(title: "Choose a Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        chooseMethodBtn.showsMenuAsPrimaryAction = true
        
        payBtn.menu = UIMenu(title: "Choose a Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        payBtn.showsMenuAsPrimaryAction = true
        payBtn.setAttributedTitle(choosePaymentTitle, for: .normal)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.shownTip2") == false {
            tipSourceView.tooltip(TutorialView2.instanceFromNib(), orientation: Tooltip.Orientation.top, configuration: { configuration in
                
                configuration.backgroundColor = UIColor(named: "Card Background")!
                configuration.shadowConfiguration.shadowOpacity = 0.1
                configuration.shadowConfiguration.shadowColor = UIColor.black.cgColor
                configuration.shadowConfiguration.shadowOffset = .zero
                
                return configuration
            })
            UserDefaults.roadout!.set(true, forKey: "ro.roadout.Roadout.shownTip2")
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
        payBtn.backgroundColor = UIColor(named: "Greyish")!
        
        chooseMethodBtn.layer.cornerRadius = 12.0
        chooseMethodBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        chooseMethodBtn.setTitle("", for: .normal)
        
        chargeLbl.set(textColor: UIColor(named: "Greyish")!, range: chargeLbl.range(after: " - "))
        chargeLbl.set(font: .systemFont(ofSize: 22.0, weight: .semibold), range: chargeLbl.range(after: " - "))
        
        cardNumbers = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.paymentMethods") ?? [String]()
        selectedCard = UserPrefsUtils.sharedInstance.returnMainCard()
                

        chooseMethodBtn.menu = UIMenu(title: "Choose a Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        chooseMethodBtn.showsMenuAsPrimaryAction = true
        
        payBtn.menu = UIMenu(title: "Choose a Payment Method".localized(), image: nil, identifier: nil, options: [], children: makeMenuActions(cards: cardNumbers))
        payBtn.showsMenuAsPrimaryAction = true
        
                
        locationLbl.text = FunctionsManager.sharedInstance.foundLocation.name
        spotSectionLbl.text = "Section ".localized() + FunctionsManager.sharedInstance.foundSection.name + " - Spot ".localized() + "\(FunctionsManager.sharedInstance.foundSpot.number)"
        
        spotSectionLbl.set(textColor: UIColor(named: "Greyish")!, range: spotSectionLbl.range(after: "Section ".localized(), before: " - Spot ".localized()))
        spotSectionLbl.set(textColor: UIColor(named: "Greyish")!, range: spotSectionLbl.range(after: " - Spot ".localized()))
        spotSectionLbl.set(font: UIFont.systemFont(ofSize: 19, weight: .medium), range: spotSectionLbl.range(after: "Section ".localized(), before: " - Spot ".localized()))
        spotSectionLbl.set(font: UIFont.systemFont(ofSize: 19, weight: .medium), range: spotSectionLbl.range(after: " - Spot ".localized()))
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Find", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func reloadMainCard() {
        payBtn.showsMenuAsPrimaryAction = false
        payBtn.menu = nil
        
        mainCardTitle = NSAttributedString(string: "Pay with ".localized() + "\(UserPrefsUtils.sharedInstance.returnMainCard())", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        payBtn.setAttributedTitle(mainCardTitle, for: .normal)
        payBtn.backgroundColor = UIColor(named: "Greyish")!
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
                UIView.animate(withDuration: 0.1, animations: {
                    self.payBtn.transform = CGAffineTransform.identity
                    self.chooseMethodBtn.transform = CGAffineTransform.identity
                })
            })
            menuItems.append(action)
        }
        
        let applePayAction = UIAction(title: "Apple Pay", image: UIImage(systemName: "applelogo")) { (_) in
            self.showApplePayBtn()
            UIView.animate(withDuration: 0.1, animations: {
                self.payBtn.transform = CGAffineTransform.identity
                self.chooseMethodBtn.transform = CGAffineTransform.identity
            })
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
