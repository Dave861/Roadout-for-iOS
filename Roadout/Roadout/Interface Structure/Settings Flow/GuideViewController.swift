//
//  PrizesViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit

class GuideViewController: UIViewController {
    
    let buttonTitle = NSAttributedString(string: "Reach Out".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor.Roadout.kindaRed])
        
    struct GuideTip {
        var title: String
        var icon: String
        var description: String
        var expandedDescription: String
        var highlightedWords: [String]
        var expandedHighlightedWords: [String]
    }
    
    let guideTips = [
        GuideTip(title: "What is this?", icon: "magazine.fill", description: "This is the User Guide, here you will find any information you need regarding this app, tap any item for details", expandedDescription: "This is the User Guide, here you will find any information you need regarding this app, everything from the basics to power features is explained here, scroll down the list and tap any item", highlightedWords: ["tap any item"], expandedHighlightedWords: ["information", "basics", "explained"]),
        
        GuideTip(title: "Roadout Basics", icon: "", description: "", expandedDescription: "", highlightedWords: [String](), expandedHighlightedWords: [String]()),
        
        GuideTip(title: "What is a Reservation?", icon: "transmission", description: "A reservation is a period of time of up to 30 minutes for which you pay to have a parking spot saved for you", expandedDescription: "A reservation is a period of time of up to 30 minutes for which you pay to have a parking spot saved for you. When you make a reservation, the barrier assigned to your spot gets raised and blocks the spot until the time runs out or you decide to unlock it from the app. During an active reservation, the search bar will be hidden and you will have actions regarding said reservation", highlightedWords: ["30 minutes", "pay"], expandedHighlightedWords: ["30 minutes", "pay", "time runs out", "active"]),
        
        GuideTip(title: "The Search Bar", icon: "magnifyingglass", description: "The Search Bar is front and centered in Roadout, you can search streets or addresses and find parking near", expandedDescription: "The Search Bar is front and centered in Roadout, you can search streets or addresses and find parking near. Just tap and start typing the top result will be the nearest parking to what we believe you are looking for, hold down on any item in search to see a live map preview", highlightedWords: ["streets", "addresses", "parking"], expandedHighlightedWords: ["streets", "addresses", "parking", "live", "nearest"]),
        
        GuideTip(title: "Picking a Spot", icon: "rectangle.portrait", description: "You can select any individual free spot to reserve, or tap continue and let Roadout find one for you", expandedDescription: "You can select any individual free spot to reserve, or tap continue and let Roadout find one for you. When picking a spot from the spots screen, each rectangle represents an individual spot which is updated in real time with its status. From the moment you select it, the barrier raises and you have one minute to complete the transaction for the reservation", highlightedWords: ["any", "reserve", "continue"], expandedHighlightedWords: ["any", "reserve", "continue", "rectangle", "raises", "complete"]),
        
        GuideTip(title: "Parking Sections", icon: "grid", description: "A parking section is a smaller zone of a parking, from which you can see and select individual spots", expandedDescription: "A parking section is a smaller zone of a parking, from which you can see and select individual spots, you can tap any of the letters displayed on the contour of the parking and select a section", highlightedWords: ["smaller", "parking", "individual"], expandedHighlightedWords: ["smaller", "parking", "individual", "letters", "contour"]),
        
        GuideTip(title: "Useful Features", icon: "", description: "", expandedDescription: "", highlightedWords: [String](), expandedHighlightedWords: [String]()),
        
        GuideTip(title: "Pay Parking", icon: "p.circle.fill", description: "Pay Parking lets you do just that, pay right after your reservation, or without a reservation at all right from the app", expandedDescription: "Pay Parking lets you do just that, pay right after your reservation, or without a reservation at all right from the app. You always benefit from the best price there is and the app can automatically detect the location you are at", highlightedWords: ["just that", "app"], expandedHighlightedWords: ["just that", "app", "best price", "automatically"]),
        
        GuideTip(title: "Reservation Delays", icon: "clock.fill", description: "If your reservation is about to end but you still need time to get to the parking, you can add up to 10 min to a reservation and make it there in time", expandedDescription: "If your reservation is about to end but you still need time to get to the parking, you can add up to 10 min to a reservation and make it there in time. You can only delay once and delay minutes will be 25% more expensive that regular minutes, this is to help us prevent abuse", highlightedWords: ["end", "time", "add", "10 min"], expandedHighlightedWords: ["end", "time", "add", "10 min", "delay once", "25% more", "abuse"]),
        
        GuideTip(title: "Find Way", icon: "binoculars.fill", description: "Find Way searches for the nearest free parking spot and gives you the option to reserve in a second", expandedDescription: "Find Way searches for the nearest free parking spot and gives you the option to reserve in a second, you can also use Find Way through Siri, see the Car section for details", highlightedWords: ["nearest", "option", "reserve"], expandedHighlightedWords: ["nearest", "option", "reserve", "Siri"]),
        
        GuideTip(title: "World View", icon: "globe.desk.fill", description: "World View shows you a real world image of the reserved spot", expandedDescription: "World View shows you a real world image of the reserved spot. The image may or may not be up to date, Google Street View holds all copyrights to them", highlightedWords: ["real world"], expandedHighlightedWords: ["real world", "Google Street View"])
    ]
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var reachOutCard: UIView!
    @IBOutlet weak var reachOutBtn: UIButton!
    @IBAction func reachOutTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HelpContactVC") as! HelpContactViewController
        vc.tintColor = UIColor.Roadout.kindaRed
        self.present(vc, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        reachOutBtn.setAttributedTitle(buttonTitle, for: .normal)
        reachOutCard.layer.cornerRadius = 12.0
        
        if self.tableView.layer.mask == nil {
            let maskLayer: CAGradientLayer = CAGradientLayer()

            maskLayer.locations = [0.0, 0.2, 0.8, 1.0]
            let width = self.tableView.frame.size.width
            let height = self.tableView.frame.size.height
            maskLayer.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: height)
            maskLayer.anchorPoint = CGPoint.zero

            self.tableView.layer.mask = maskLayer
        }

        scrollViewDidScroll(self.tableView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let outerColor = UIColor(white: 1.0, alpha: 0.0).cgColor
        let innerColor = UIColor(white: 1.0, alpha: 1.0).cgColor

        var colors = [CGColor]()

        if scrollView.contentOffset.y + scrollView.contentInset.top <= 0 {
            colors = [innerColor, innerColor, innerColor, outerColor]
        } else if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
            colors = [outerColor, innerColor, innerColor, innerColor]
        } else {
            colors = [outerColor, innerColor, innerColor, outerColor]
        }

        if let mask = scrollView.layer.mask as? CAGradientLayer {
            mask.colors = colors

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            mask.position = CGPoint(x: 0.0, y: scrollView.contentOffset.y)
            CATransaction.commit()
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
        }
    }

}
extension GuideViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guideTips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if guideTips[indexPath.row].icon == "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuideHeaderCell") as! HeaderCell
            cell.titleLbl.text = guideTips[indexPath.row].title
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GuideCell") as! GuideCell
            cell.titleLbl.text = guideTips[indexPath.row].title
            cell.explanationLbl.text = guideTips[indexPath.row].description
            
            cell.leftIcon.image = UIImage(systemName: guideTips[indexPath.row].icon) ?? UIImage(named: guideTips[indexPath.row].icon)
            
            for highlightedWord in guideTips[indexPath.row].highlightedWords {
                cell.explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: cell.explanationLbl.range(string: highlightedWord))
                cell.explanationLbl.set(textColor: UIColor.Roadout.kindaRed, range: cell.explanationLbl.range(string: highlightedWord))
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if guideTips[indexPath.row].icon != "" {
            let vc = storyboard?.instantiateViewController(withIdentifier: "MoreInfoVC") as! MoreInfoViewController
            vc.titleText = guideTips[indexPath.row].title
            vc.descriptionText = guideTips[indexPath.row].expandedDescription
            vc.highlightedWords = guideTips[indexPath.row].expandedHighlightedWords
            vc.highlightColor = "Kinda Red"
            
            self.present(vc, animated: true)
        }
    }
}
