//
//  AboutViewController.swift
//  Roadout
//
//  Created by David Retegan on 23.04.2022.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var easterEggLbl: UILabel!
    
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var websiteCard: UIView!
    @IBOutlet weak var appCard: UIView!
    
    @IBAction func websiteTapped(_ sender: Any) {
        if let url = URL(string: "https://www.roadout.live") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func facebookTapped(_ sender: Any) {
        if let url = URL(string: "https://www.facebook.com/roadout.ro") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func instagramTapped(_ sender: Any) {
        if let url = URL(string: "https://www.instagram.com/roadout.ro/") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func twitterTapped(_ sender: Any) {
        if let url = URL(string: "https://twitter.com/roadout_ro") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func youtubeTapped(_ sender: Any) {
        if let url = URL(string: "https://www.youtube.com/channel/UCGzqZVCYwuotgIolW6ip-Ug/featured") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var instagramBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var youtubeBtn: UIButton!
    
    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        websiteCard.layer.cornerRadius = 12.0
        appCard.layer.cornerRadius = 12.0
        
        logoImage.layer.cornerRadius = logoImage.frame.height * 10/45
        
        localizeLabels()
        
        facebookBtn.setTitle("", for: .normal)
        instagramBtn.setTitle("", for: .normal)
        twitterBtn.setTitle("", for: .normal)
        youtubeBtn.setTitle("", for: .normal)
        
        facebookBtn.layer.cornerRadius = facebookBtn.frame.height/2
        instagramBtn.layer.cornerRadius = instagramBtn.frame.height/2
        twitterBtn.layer.cornerRadius = twitterBtn.frame.height/2
        youtubeBtn.layer.cornerRadius = youtubeBtn.frame.height/2
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
        }
    }
    
    func localizeLabels() {
        self.titleLbl.text = "About".localized()
        self.easterEggLbl.text = "Roadout\nMade in Cluj :)".localized()
        self.backButton.setTitle("Back".localized(), for: .normal)
    }

}
