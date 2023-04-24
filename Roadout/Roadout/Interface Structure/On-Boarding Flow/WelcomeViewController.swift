//
//  ViewController.swift
//  Roadout
//
//  Created by David Retegan on 25.10.2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let infoIcons = [UIImage(systemName: "car.fill"), UIImage(systemName: "signpost.right.and.left.fill"), UIImage(systemName: "parkingsign.circle.fill")]
    let infoColors = [UIColor.Roadout.mainYellow, UIColor.Roadout.darkYellow, UIColor.Roadout.secondOrange]
    let infoTitles = ["Parking Locations".localized(), "Live Occupancy".localized(), "Spot Reservation".localized()]
    let infoTexts = ["Easily find parking locations nearby and close to your destination".localized(),
                     "View the occupancy of any parking spot updated in real-time".localized(),
                     "Always have a spot waiting for you, reserve your parking and make sure it’s free when you arrive".localized()]
    
    
    let signInTitle = NSAttributedString(string: "Sign In".localized(),
                                                       attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let signUpTitle = NSAttributedString(string: "Sign Up".localized(),
                                                       attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let legalTitle = NSAttributedString(string: "Privacy Policy & Terms of Use".localized(),
                                                       attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .medium)])

    
    @IBOutlet weak var infoTableView: UITableView!
    
    @IBOutlet weak var signInBtn: UXButton!
    @IBOutlet weak var signUpBtn: UXButton!
    
    @IBOutlet weak var legalBtn: UIButton!
    
    @IBAction func signInTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func legalTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Settings", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LegalVC") as! LegalViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInBtn.layer.cornerRadius = 13.0
        signUpBtn.layer.cornerRadius = 13.0
        
        signInBtn.setAttributedTitle(signInTitle, for: .normal)
        signUpBtn.setAttributedTitle(signUpTitle, for: .normal)
        legalBtn.setAttributedTitle(legalTitle, for: .normal)
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
        }
    }


}
extension WelcomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoCell
        cell.titleLabel.text = infoTitles[indexPath.row]
        cell.infoLabel.text = infoTexts[indexPath.row]
        cell.iconImage.image = infoIcons[indexPath.row]
        cell.iconImage.tintColor = infoColors[indexPath.row]
        
        return cell
    }
}

