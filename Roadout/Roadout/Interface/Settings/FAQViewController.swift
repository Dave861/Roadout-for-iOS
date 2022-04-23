//
//  DeveloperViewController.swift
//  Roadout
//
//  Created by David Retegan on 25.02.2022.
//

import UIKit
import MessageUI

class FAQViewController: UIViewController {
    
    let questions = ["What is question one?", "How does question two work?", "Can I question three?", "What if I question four?", "How much does question five?"]
    let answers = ["", "", "", "", ""]
    var isExpandedQuestions = [true, true, true, true, true]

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
        cell.questionLbl.text = questions[indexPath.row]
        cell.answerTextView.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate Duis aute irure dolor in reprehenderit in voluptate."
        
        cell.bottomView.isHidden = isExpandedQuestions[indexPath.row]
        cell.bottomSpacerView.isHidden = isExpandedQuestions[indexPath.row]
        cell.spacerView.isHidden = !(isExpandedQuestions[indexPath.row])
        
        if isExpandedQuestions[indexPath.row] {
            cell.arrowView.image = UIImage(systemName: "chevron.down")
            cell.topView.layer.cornerRadius = 12.0
            cell.topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.arrowView.image = UIImage(systemName: "chevron.up")
            
            cell.topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.topView.layer.cornerRadius = 12.0
            
            cell.bottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.bottomView.layer.cornerRadius = 12.0
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isExpandedQuestions[indexPath.row] = !(self.isExpandedQuestions[indexPath.row])
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
