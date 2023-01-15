//
//  InviteViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit
import MessageUI

struct VoteOption {
    var title: String
    var description: String
    var expandedDescription: String
    var highlightedWords: [String]
}

let voteOptions = [
    VoteOption(title: "Add more support for Siri", description: "Expand our Siri support with prompts for express reserve, pay parking and others, find out more", expandedDescription: "We are thinking of expanding our Siri support to cover more requests. Our proposed requests are Reserve a Spot in a certain location, Pay Parking & Future Reserve all through Siri.", highlightedWords: ["Reserve a Spot", "Pay Parking", "Future Reserve"]),
    VoteOption(title: "Support more Assistants", description: "Add support for Alexa & Google Assistant on smart speakers and car systems, find out more", expandedDescription: "We are thinking of adding the Find Way capability to Google Assitant and Alexa powered devices, such as smart speakers and car systems", highlightedWords: ["Find Way", "smart speakers", "car systems"])
]

var selectedOptionIndex = -1

class VoteViewController: UIViewController {

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
    
    @IBOutlet weak var submitCard: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBAction func submitTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
    }
    
    @IBOutlet weak var suggestCard: UIView!
    @IBOutlet weak var suggestBtn: UIButton!
    @IBAction func suggestTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
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
    
    let buttonTitle = NSAttributedString(string: "Submit".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Icons")!])
    
    func addObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadOptionsTableView), name: .refreshOptionsTableViewID, object: nil)
    }
    
    @objc func reloadOptionsTableView() {
        self.loadVoteOptions()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObs()
        loadVoteOptions()
        tableView.delegate = self
        tableView.dataSource = self
        questionCard.layer.cornerRadius = 16.0
        submitCard.layer.cornerRadius = 12.0
        suggestCard.layer.cornerRadius = 12.0
        submitBtn.setAttributedTitle(buttonTitle, for: .normal)
        suggestBtn.setTitle("", for: .normal)
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
        } else {
            optionsHeader.isHidden = false
            questionHeader.text = "Active Question"
            questionTitle.text = "What are we working on"
            questionDescription.text = "Currently we are looking to expand our voice assistants support, pick below"
            questionIcon.image = UIImage(systemName: "questionmark")
            
            questionDescription.set(font: .systemFont(ofSize: 17, weight: .medium), range: questionDescription.range(string: "pick below"))
            questionDescription.set(textColor: UIColor(named: "Icons")!, range: questionDescription.range(string: "pick below"))
        }
    }
    
}
extension VoteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voteOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoteCell") as! VoteCell
        cell.index = indexPath.row
        cell.titleLbl.text = voteOptions[indexPath.row].title
        cell.explanationLbl.text = voteOptions[indexPath.row].description
        cell.optionIcon.setImage(selectedOptionIndex == indexPath.row ? UIImage(systemName: "seal.fill") : UIImage(systemName: "seal"), for: .normal)
        
        cell.explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: cell.explanationLbl.range(string: "find out more"))
        cell.explanationLbl.set(textColor: UIColor(named: "Icons")!, range: cell.explanationLbl.range(string: "find out more"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MoreInfoVC") as! MoreInfoViewController
        vc.titleText = voteOptions[indexPath.row].title
        vc.descriptionText = voteOptions[indexPath.row].expandedDescription
        vc.highlightedWords = voteOptions[indexPath.row].highlightedWords
        vc.highlightColor = "Icons"
        
        self.present(vc, animated: true)
    }
}
extension VoteViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
