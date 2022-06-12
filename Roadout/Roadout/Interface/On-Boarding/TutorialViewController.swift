//
//  TutorialViewController.swift
//  Roadout
//
//  Created by David Retegan on 15.01.2022.
//

import UIKit

struct TutorialItem {
    var title: String
    var description: String
    var icon: UIImage
    var tintColor: UIColor
}

class TutorialViewController: UIViewController {
        
    let tutorialSet = [
        TutorialItem(title: "Search Bar".localized(), description: "Use the Search Bar to find park locations near streets or places you need to get to.".localized(), icon: UIImage(systemName: "magnifyingglass")!, tintColor: UIColor(named: "Main Yellow")!),
        TutorialItem(title: "Markers".localized(), description: "Parking lots are highlighted on the map using markers, you can zoom in and select them to easily get more info.".localized(), icon: UIImage(systemName: "mappin.and.ellipse")!, tintColor: UIColor(named: "Second Orange")!),
        TutorialItem(title: "Find Way".localized(), description: "Find Way is the fastest way to find a free parking spot near you. Just tap find way and Roadout will go through all parking lots near you and search for a free spot to reserve.".localized(), icon: UIImage(systemName: "binoculars")!, tintColor: UIColor(named: "Greyish")!),
        TutorialItem(title: "Express Lane".localized(), description: "With Express Lane you can quickly find a free parking spot in a location you pick. Just tap a location in the Express Lane section and the first free spot will be presented to you.".localized(), icon: UIImage(systemName: "flag.2.crossed")!, tintColor: UIColor(named: "ExpressFocus")!),
        TutorialItem(title: "Settings".localized(), description: "In Settings you can customize Roadout and use Reminders to keep you from forgetting to make a reservation. You also have user control options here.".localized(), icon:UIImage(systemName: "gearshape.2")!, tintColor: UIColor(named: "Dark Yellow")!),
        TutorialItem(title: "About and Help", description: "Have any questions? Check out the FAQ & Support section. Additionally during an active reservation there also is the Help Center to assist you with any problems.".localized(), icon: UIImage(systemName: "questionmark.circle")!, tintColor: UIColor(named: "Icons")!)]
    
    let continueTitle = NSAttributedString(string: "Continue".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let skipTitle = NSAttributedString(
        string: "Skip".localized(),
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "Greyish")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
    )
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "Tutorial".localized()
        continueBtn.layer.cornerRadius = 13.0
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        skipBtn.setAttributedTitle(skipTitle, for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
  
   
}
extension TutorialViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutorialSet.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorialCell") as! TutorialCell
        cell.titleLabel.text = tutorialSet[indexPath.row].title
        cell.infoLabel.text = tutorialSet[indexPath.row].description
        cell.iconImage.image = tutorialSet[indexPath.row].icon
        cell.iconImage.tintColor = tutorialSet[indexPath.row].tintColor
        
        return cell
    }
    
}
