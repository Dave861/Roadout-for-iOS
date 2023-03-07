//
//  AddFutureRoadViewController.swift
//  Roadout
//
//  Created by David Retegan on 16.01.2023.
//

import UIKit

class AddFutureRoadViewController: UIViewController {
    
    let doneTitle = NSAttributedString(string: "Done".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @objc func blurTapped() {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var doneBtn: UXButton!
    @IBAction func doneTapped(_ sender: Any) {
        var ok = true
        for futureReservation in futureReservations {
            if futureReservation.place == placeField.text {
                ok = false
            }
        }
        if ok == true {
            if placeField.text != "" {
                let futureReservation = FutureReservation(place: placeField.text!, date: datePicker.date, identifier: "ro.roadout.Roadout.FR.\(placeField.text!.replacingOccurrences(of: " ", with: ""))")
                if UserPrefsUtils.sharedInstance.futureNotificationsEnabled() {
                    NotificationHelper.sharedInstance.scheduleFutureReservation(futureReservation: futureReservation)
                }
                saveFutureReservation(futureReservation: futureReservation)
                
                NotificationCenter.default.post(name: .reloadFutureReservationsID, object: nil)
                UIView.animate(withDuration: 0.1) {
                    self.blurEffect.alpha = 0
                } completion: { done in
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error".localized(), message: "There is already an active future road for this location, please pick another location".localized(), preferredStyle: .alert)
            alert.view.tintColor = UIColor(named: "Icons")
            let okAction = UIAlertAction(title: "OK".localized(), style: .default) { action in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var placeField: PaddedTextField!
    
    @IBAction func cancelTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 20.0
        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addShadowToCardView()

        doneBtn.layer.cornerRadius = 13.0
        doneBtn.setAttributedTitle(doneTitle, for: .normal)
        
        datePicker.minimumDate = makeNextDate()
        
        placeField.layer.cornerRadius = 12.0
        placeField.attributedPlaceholder = NSAttributedString(
            string: "Reservation Place".localized(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
        )
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
        
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.alpha = 0.7
        } completion: { _ in
            self.placeField.becomeFirstResponder()
        }
    }
    
    func addShadowToCardView() {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 20.0
        cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
        cardView.layer.shouldRasterize = true
        cardView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    //MARK: - Logic Functions -
    
    func saveFutureReservation(futureReservation: FutureReservation) {
        futureReservations.append(futureReservation)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(futureReservations)
            UserDefaults.roadout!.set(data, forKey: "ro.roadout.Roadout.futureReservations")
        } catch {
            print("Unable to Encode Array of Future Reservations (\(error))")
        }
    }
    
    func makeNextDate() -> Date {
        let calendar = Calendar.current
        var nextDate = Date()
        let minutes = calendar.component(.minute, from: nextDate)
        let diff = 5 - (minutes % 5)
        nextDate = calendar.date(byAdding: .minute, value: diff, to: nextDate)!
        return nextDate
    }

}
