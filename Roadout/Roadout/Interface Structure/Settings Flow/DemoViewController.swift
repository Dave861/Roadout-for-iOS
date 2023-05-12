//
//  DemoViewController.swift
//  Roadout
//
//  Created by David Retegan on 12.05.2023.
//

import UIKit

class DemoViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
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
