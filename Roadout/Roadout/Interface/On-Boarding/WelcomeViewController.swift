//
//  ViewController.swift
//  Roadout
//
//  Created by David Retegan on 25.10.2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let infoIcons = [UIImage(systemName: "car.fill"), UIImage(systemName: "creditcard"), UIImage(systemName: "arrow.triangle.branch")]
    let infoColors = [UIColor(named: "Main Yellow"), UIColor(named: "Dark Yellow"), UIColor(named: "Second Orange")]
    let infoTitles = ["Parking Spots", "Instant Card Payment", "Live Directions"]
    let infoTexts = ["Check the vacancy of parking spots in real time.", "You can reserve a parking space by paying safely online in our app.", "Receive directions to the desired parking spot in your favourite maps app."]
    
    
    let signInTitle = NSAttributedString(string: "Sign In",
                                                       attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let signUpTitle = NSAttributedString(string: "Sign Up",
                                                       attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let legalTitle = NSAttributedString(string: "Privacy Policy & Terms of Use",
                                                       attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .medium)])

    
    @IBOutlet weak var infoTableView: UITableView!
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
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

