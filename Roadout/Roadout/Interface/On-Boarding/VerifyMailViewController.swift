//
//  VerifyMailViewController.swift
//  Roadout
//
//  Created by David Retegan on 08.01.2022.
//

import UIKit
import CHIOTPField

class VerifyMailViewController: UIViewController {

    @IBOutlet weak var codeField: AnyObject?
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func verifyTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PermissionsVC") as! PermissionsViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let continueTitle = NSAttributedString(string: "Verify", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let skipTitle = NSAttributedString(
        string: "Cancel",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "ExpressFocus")!, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 10.0
        cancelBtn.layer.cornerRadius = 13.0
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        cancelBtn.setAttributedTitle(skipTitle, for: .normal)
    }
    
}
