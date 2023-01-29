//
//  ARHelpViewController.swift
//  Roadout
//
//  Created by David Retegan on 17.12.2022.
//

import UIKit
import MessageUI

class ARHelpViewController: UIViewController {

    let infoIcons = [UIImage(systemName: "hammer.fill"), UIImage(systemName: "gyroscope")]
    let infoTitles = ["How does this work?".localized(), "How accurate is this?".localized()]
    let infoTexts = ["If you have arrived at the parking location, you can start an AR Session and you will be shown an overlay of where your spot is".localized(), "AR Directions have limited accuracy as the GPS data provided by your device may not always be optimal, everything is processed locally, your location is NOT sent anywhere.".localized()]
    
    let questionIcons = [UIImage(systemName: "arkit"), UIImage(systemName: "eye.fill"), UIImage(systemName: "move.3d"), UIImage(systemName: "xmark.circle.fill")]
    let questionTitles = ["What is this?".localized(), "Why can't I see my spot?".localized(), "Why is the marker moving?".localized(), "How do I exit?".localized()]
    let questionTexts = ["AR Directions help you find your parking spot by showing an approximate marker overlay in the real world location if the spot.".localized(),
        "AR Markers scale depending on how far you are from them, if you are further than 150-200 m, you may not see the marker.".localized(),
        "Open in AR is not 100% accurate and we recalibrate every second, this is meant just to guide you in the general direction of the spot.".localized(),
        "You can tap the x button in the left corner of the information card.".localized()]
    
    let doneTitle = NSAttributedString(string: "Thanks! Done".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let helpTitle = NSAttributedString(
        string: "I still need help".localized(),
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Kinda Red")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
    )
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var doneBtn: UXButton!
    @IBOutlet weak var helpBtn: UIButton!
    
    @IBAction func doneTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func helpTapped(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.view.tintColor = UIColor(named: "Kinda Red")
            mail.setToRecipients(["roadout.ro@gmail.com"])
            mail.setSubject("Roadout for iOS - AR Help Request".localized())
            mail.setMessageBody("Ask any questions about AR Directions here and we will respond as fast as we can - Roadout Team".localized(), isHTML: false)

            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Error".localized(), message: "This device cannot send emails, please check in settings your set email addresses, or ask your questions at roadout.ro@gmail.com".localized(), preferredStyle: .alert)
            alert.view.tintColor = UIColor(named: "Kinda Red")
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBtn.layer.cornerRadius = 13.0
        doneBtn.setAttributedTitle(doneTitle, for: .normal)
        helpBtn.setAttributedTitle(helpTitle, for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
    }

}
extension ARHelpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ARManager.sharedInstance.helpMode == .info {
            return infoTitles.count
        } else {
            return questionTitles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ARHelpCell") as! ARHelpCell
        if ARManager.sharedInstance.helpMode == .info {
            cell.titleLabel.text = infoTitles[indexPath.row]
            cell.infoLabel.text = infoTexts[indexPath.row]
            cell.iconImage.image = infoIcons[indexPath.row]
        } else {
            cell.titleLabel.text = questionTitles[indexPath.row]
            cell.infoLabel.text = questionTexts[indexPath.row]
            cell.iconImage.image = questionIcons[indexPath.row]
        }

        return cell
    }
}
extension ARHelpViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
