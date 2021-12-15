//
//  LegalViewController.swift
//  Roadout
//
//  Created by David Retegan on 30.10.2021.
//

import UIKit

class LegalViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
