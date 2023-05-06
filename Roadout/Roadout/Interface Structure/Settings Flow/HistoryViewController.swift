//
//  HistoryViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
        
    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
        }
    }
    
}
