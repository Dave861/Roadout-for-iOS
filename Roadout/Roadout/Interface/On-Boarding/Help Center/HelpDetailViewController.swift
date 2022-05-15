//
//  HelpDetailViewController.swift
//  Roadout
//
//  Created by David Retegan on 14.05.2022.
//

import UIKit

var selectedProblem: Problem!

class HelpDetailViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var tagLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var problemImage: UIImageView!
    @IBOutlet weak var solutionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.setTitle("", for: .normal)
        closeButton.layer.cornerRadius = closeButton.frame.height/2
        
        tagLbl.text = selectedProblem.tag
        titleLbl.text = selectedProblem.title
        problemImage.image = UIImage(named: "Header" + selectedProblem.image)
        
    }

}
