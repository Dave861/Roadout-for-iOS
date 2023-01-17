//
//  InviteViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit
import MessageUI



let voteOptions = [
    VoteOption(title: "Expand support for Siri", description: "Expand our Siri support with prompts for express reserve, pay parking and others", highlightedWords: ["express reserve", "pay parking"]),
    VoteOption(title: "Support more Assistants", description: "Add support for Alexa & Google Assistant on smart speakers and car systems", highlightedWords: ["smart speakers", "car systems"])
]

class VoteViewController: UIViewController {
    
    var selectedOptionIndex = 0

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var questionHeader: UILabel!
    @IBOutlet weak var optionsHeader: UILabel!
    
    @IBOutlet weak var questionCard: UIView!
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var questionDescription: UILabel!
    @IBOutlet weak var questionIcon: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var actionCard: UIView!
    @IBOutlet weak var actionBtn: UIButton!
    @IBAction func actionTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if !voteOptions.isEmpty {
            
        } else {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.view.tintColor = UIColor(named: "Icons")
                mail.setToRecipients(["suggestions@roadout.ro"])
                mail.setSubject("Roadout - Feature Suggestion".localized())
                mail.setMessageBody("Describe your idea here here - Roadout Team".localized(), isHTML: false)

                present(mail, animated: true)
            } else {
                let alert = UIAlertController(title: "Error".localized(), message: "This device cannot send emails, please check in settings your set email addresses, or send the email at roadout.ro@gmail.com".localized(), preferredStyle: .alert)
                alert.view.tintColor = UIColor(named: "Icons")
                let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    let submitTitle = NSAttributedString(string: "Submit".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
    let suggestTitle = NSAttributedString(string: "Suggest".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
    
    @objc func reloadOptionsTableView() {
        self.loadVoteOptions()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVoteOptions()
        tableView.delegate = self
        tableView.dataSource = self
        
        questionCard.layer.cornerRadius = 16.0
        actionCard.layer.cornerRadius = 12.0
    }
    
    func loadVoteOptions() {
        if voteOptions.isEmpty {
            optionsHeader.isHidden = true
            questionHeader.text = "No Active Question"
            questionTitle.text = "Exciting things are coming"
            questionDescription.text = "Currently we don’t have any votes for you, we are working on some exciting things in the meantime, stay tuned"
            questionIcon.image = UIImage(systemName: "wand.and.stars")
            
            questionDescription.set(font: .systemFont(ofSize: 17, weight: .medium), range: questionDescription.range(string: "stay tuned"))
            questionDescription.set(textColor: UIColor(named: "Icons")!, range: questionDescription.range(string: "stay tuned"))
            
            actionBtn.setAttributedTitle(suggestTitle, for: .normal)
        } else {
            optionsHeader.isHidden = false
            questionHeader.text = "Active Question"
            questionTitle.text = "What are we working on"
            questionDescription.text = "Currently we are looking to expand our voice assistants support, pick below"
            questionIcon.image = UIImage(systemName: "questionmark")
            
            questionDescription.set(font: .systemFont(ofSize: 17, weight: .medium), range: questionDescription.range(string: "pick below"))
            questionDescription.set(textColor: UIColor(named: "Icons")!, range: questionDescription.range(string: "pick below"))
            
            actionBtn.setAttributedTitle(submitTitle, for: .normal)
        }
    }
}
extension VoteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voteOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoteCell") as! VoteCell
        cell.titleLbl.text = voteOptions[indexPath.row].title
        cell.explanationLbl.text = voteOptions[indexPath.row].description
        cell.optionIcon.image = selectedOptionIndex == indexPath.row ? UIImage(systemName: "checkmark.seal.fill") : UIImage(systemName: "seal")
        
        for highlightedWord in voteOptions[indexPath.row].highlightedWords {
            cell.explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: cell.explanationLbl.range(string: highlightedWord))
            cell.explanationLbl.set(textColor: UIColor(named: "Icons")!, range: cell.explanationLbl.range(string: highlightedWord))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        selectedOptionIndex = indexPath.row
        tableView.reloadData()
    }
}
extension VoteViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
