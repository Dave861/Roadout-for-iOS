//
//  UnlockView.swift
//  Roadout
//
//  Created by David Retegan on 20.03.2022.
//

import UIKit

class UnlockView: UXView {

    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeUnlockCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: - Swipe Gesture Configuration -
    
    override func viewSwipedBack() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .removeUnlockCardID, object: nil)
    }
    
    override func excludePansFrom(touch: UITouch) -> Bool {
        return !slidingBtn.bounds.contains(touch.location(in: slidingBtn)) && !backBtn.bounds.contains(touch.location(in: backBtn))
    }
    
    @IBOutlet weak var slidingBtn: SlidingButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    //MARK: - View Configuration -
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 19.0
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        
        slidingBtn.reset()
        slidingBtn.delegate = self

        titleLbl.text = "Unlock Spot".localized()
        
        self.accentColor = UIColor.Roadout.darkYellow
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
extension UnlockView: SlideButtonDelegate {
    func buttonStatus(status: String, sender: SlidingButton) {
        if status == "Unlocked" {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            let id = UserDefaults.roadout!.object(forKey: "eu.roadout.Roadout.userID") as! String
            Task {
                do {
                    try await ReservationManager.sharedInstance.unlockReservationAsync(userID: id, date: Date())
                    DispatchQueue.main.async {
                        if ReservationManager.sharedInstance.reservationTimer != nil {
                            ReservationManager.sharedInstance.reservationTimer.invalidate()
                        }
                        NotificationHelper.sharedInstance.cancelReservationNotification()
                        NotificationHelper.sharedInstance.cancelLocationNotification()
                        if #available(iOS 16.1, *) {
                            LiveActivityHelper.sharedInstance.endLiveActivity()
                        }
                        NotificationCenter.default.post(name: .showUnlockedViewID, object: nil)
                    }
                } catch let err {
                    self.manageServerSideErrors(error: err)
                }
            }
        }
    }
}
