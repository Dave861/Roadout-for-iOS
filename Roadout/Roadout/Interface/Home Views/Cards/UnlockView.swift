//
//  UnlockView.swift
//  Roadout
//
//  Created by David Retegan on 20.03.2022.
//

import UIKit

class UnlockView: UIView {

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeUnlockCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var slidingBtn: SlidingButton!
    @IBOutlet weak var explainerLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        
        slidingBtn.reset()
        slidingBtn.delegate = self
        
        explainerLbl.text = "Unlocking the spot cannot be undone. Once unlocked anyone can park on the spot, make sure you are at the spot before unlocking it.".localized()
        titleLbl.text = "Unlock Spot".localized()
        
        explainerLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: explainerLbl.range(string: "Unlocking ".localized()))
        explainerLbl.set(font: .systemFont(ofSize: 16.0, weight: .medium), range: explainerLbl.range(string: "Unlocking ".localized()))
        explainerLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: explainerLbl.range(string: " cannot".localized()))
        explainerLbl.set(font: .systemFont(ofSize: 16.0, weight: .medium), range: explainerLbl.range(string: " cannot".localized()))
        explainerLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: explainerLbl.range(string: " anyone".localized()))
        explainerLbl.set(font: .systemFont(ofSize: 16.0, weight: .medium), range: explainerLbl.range(string: " anyone".localized()))
        explainerLbl.set(textColor: UIColor(named: "Dark Yellow")!, range: explainerLbl.range(string: "before ".localized()))
        explainerLbl.set(font: .systemFont(ofSize: 16.0, weight: .medium), range: explainerLbl.range(string: "before ".localized()))
        
       
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[7] as! UIView
    }
    
    func manageServerSideErrors(error: Error) {
        switch error {
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
extension UnlockView: SlideButtonDelegate {
    func buttonStatus(status: String, sender: SlidingButton) {
        print(status)
        if status == "Unlocked" {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
            ReservationManager.sharedInstance.unlockReservation(id, date: Date()) { result in
                switch result {
                    case .success():
                        print("UNLOCKED")
                    case .failure(let err):
                        print(err)
                        self.manageServerSideErrors(error: err)
                }
            }
        }
    }
}
