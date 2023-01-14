//
//  InviteViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit

class VoteViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
