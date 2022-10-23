//
//  UnlockView.swift
//  Roadout
//
//  Created by David Retegan on 20.03.2022.
//

import UIKit

class UnlockView: UIView {

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeUnlockCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var slidingBtn: SlidingButton!
    @IBOutlet weak var explainerLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        
        slidingBtn.reset()
        slidingBtn.delegate = self
        
        explainerLbl.text = "Unlocking the spot cannot be undone. Once unlocked anyone can park on the spot, make sure you are at the spot before unlocking it.".localized()
        titleLbl.text = "Unlock Spot".localized()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[7] as! UIView
    }
    
    func manageServerSideErrors(error: Error) {
        switch error {
            case ReservationManager.ReservationErrors.networkError:
                /*let alert = UIAlertController(title: "Network Error".localized(), message: "Please check you network connection.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)*/
                let alert = UXAlertController(alertTag: 0, alertTitle: "Network Error".localized(), alertMessage: "Please check you network connection.".localized(), alertImage: "ServerErrorsR", alertTintColor: UIColor(named: "Redish")!, alertPrimaryActionTitle: "OK".localized(), isSecondaryActionHidden: true, alertSecondaryActionTitle: "")
                self.parentViewController().present(alert, animated: true)
            case ReservationManager.ReservationErrors.databaseFailure:
                /*let alert = UIAlertController(title: "Internal Error".localized(), message: "There was an internal problem, please wait and try again a little later.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)*/
                let alert = UXAlertController(alertTag: 0, alertTitle: "Internal Error".localized(), alertMessage: "There was an internal problem, please wait and try again a little later.".localized(), alertImage: "ServerErrorsR", alertTintColor: UIColor(named: "Redish")!, alertPrimaryActionTitle: "OK".localized(), isSecondaryActionHidden: true, alertSecondaryActionTitle: "")
                self.parentViewController().present(alert, animated: true)
            case ReservationManager.ReservationErrors.unknownError:
                /*let alert = UIAlertController(title: "Unknown Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)*/
                let alert = UXAlertController(alertTag: 0, alertTitle: "Unknown Error".localized(), alertMessage: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), alertImage: "ServerErrorsR", alertTintColor: UIColor(named: "Redish")!, alertPrimaryActionTitle: "OK".localized(), isSecondaryActionHidden: true, alertSecondaryActionTitle: "")
                self.parentViewController().present(alert, animated: true)
            case ReservationManager.ReservationErrors.errorWithJson:
                /*let alert = UIAlertController(title: "JSON Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)*/
                let alert = UXAlertController(alertTag: 0, alertTitle: "JSON Error".localized(), alertMessage: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), alertImage: "ServerErrorsR", alertTintColor: UIColor(named: "Redish")!, alertPrimaryActionTitle: "OK".localized(), isSecondaryActionHidden: true, alertSecondaryActionTitle: "")
                self.parentViewController().present(alert, animated: true)
            default:
                /*let alert = UIAlertController(title: "Unknown Error".localized(), message: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.view.tintColor = UIColor(named: "Redish")
                self.parentViewController().present(alert, animated: true, completion: nil)*/
                let alert = UXAlertController(alertTag: 0, alertTitle: "Unknown Error".localized(), alertMessage: "There was an error with the server respone, please screenshot this and send a bug report to roadout.ro@gmail.com.".localized(), alertImage: "ServerErrorsR", alertTintColor: UIColor(named: "Redish")!, alertPrimaryActionTitle: "OK".localized(), isSecondaryActionHidden: true, alertSecondaryActionTitle: "")
                self.parentViewController().present(alert, animated: true)
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
