//
//  DeveloperViewController.swift
//  Roadout
//
//  Created by David Retegan on 25.02.2022.
//

import UIKit
import LocalConsole


class DeveloperViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var consoleSwitch: UISwitch!
    @IBAction func consoleSwitched(_ sender: Any) {
        if #available(iOS 14.0, *) {
            consoleManager.isVisible = consoleSwitch.isOn
        }
    }
    
    @IBOutlet weak var refreshBtn: UIButton!
    @IBAction func refreshTapped(_ sender: Any) {
        consoleManager.print("Trying")
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "GetDataVC") as! GetDataViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    let refreshTitle = NSAttributedString(string: "Refresh City Data".localized(),
                                          attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "DevBrown") as Any])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.cornerRadius = 16.0
        refreshBtn.setAttributedTitle(refreshTitle, for: .normal)
        if #available(iOS 14.0, *) {
            consoleSwitch.setOn(consoleManager.isVisible, animated: false)
        }
    }
    
}
