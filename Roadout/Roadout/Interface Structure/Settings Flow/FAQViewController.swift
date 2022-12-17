//
//  DeveloperViewController.swift
//  Roadout
//
//  Created by David Retegan on 25.02.2022.
//

import UIKit
import MessageUI

class FAQViewController: UIViewController {
    
    let icons = ["parkingsign.circle.fill", "creditcard.fill", "car.2.fill", "clock.fill", "binoculars.fill"]
    let questions = ["What is a parking reservation?", "Why does it cost money?", "How is a spot being reserved?", "Why is it maximum 20 min?", "How will I find the parking spot?"]
    let answers = ["", "", "", "", ""]

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var supportCard: UIView!
    @IBOutlet weak var supportBtn: UIButton!
    
    @IBAction func supportTapped(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.view.tintColor = UIColor(named: "Kinda Red")
            mail.setToRecipients(["support@roadout.ro"])
            mail.setSubject("Roadout - Support Request".localized())
            mail.setMessageBody("Ask any questions here - Roadout Team".localized(), isHTML: false)

            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Error".localized(), message: "This device cannot send emails, please check in settings your set email addresses, or report your bug at roadout.ro@gmail.com".localized(), preferredStyle: .alert)
            alert.view.tintColor = UIColor(named: "Kinda Red")
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var faqTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        supportCard.layer.cornerRadius = 12.0
        
        faqTableView.delegate = self
        faqTableView.dataSource = self
        faqTableView.estimatedRowHeight = 48
        faqTableView.rowHeight = UITableView.automaticDimension
    }
    
}
extension FAQViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell") as! QuestionCell
        cell.iconImage.image = UIImage(systemName: icons[indexPath.row])
        cell.titleLabel.text = questions[indexPath.row]
        cell.infoLabel.text = "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate Duis aute irure dolor in reprehenderit in voluptate."
        
        return cell
    }
}
