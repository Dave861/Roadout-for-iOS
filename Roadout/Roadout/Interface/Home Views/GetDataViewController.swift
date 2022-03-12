//
//  DataViewController.swift
//  Roadout
//
//  Created by David Retegan on 19.02.2022.
//

import UIKit

class GetDataViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurButton: UIButton!
    
    @IBAction func dismissTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.blurButton.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    
    @IBOutlet weak var icn1: UIImageView!
    @IBOutlet weak var icn2: UIImageView!
    @IBOutlet weak var icn3: UIImageView!
    
    @IBOutlet weak var sublbl1: UILabel!
    @IBOutlet weak var sublbl2: UILabel!
    @IBOutlet weak var sublbl3: UILabel!
    
    @IBOutlet weak var cityLbl: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 16.0
        print("Showing")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.blurButton.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 1.1) {
                self.line1.alpha = 1.0
                self.lbl1.alpha = 1.0
                self.icn1.alpha = 1.0
                self.sublbl2.alpha = 1.0
            } completion: { _ in
                UIView.animate(withDuration: 1.1) {
                    self.line2.alpha = 1.0
                    self.lbl2.alpha = 1.0
                    self.icn2.alpha = 1.0
                    self.sublbl3.alpha = 1.0
                } completion: { _ in
                    UIView.animate(withDuration: 1.1) {
                        self.line3.alpha = 1.0
                        self.lbl3.alpha = 1.0
                        self.icn3.alpha = 1.0
                    } completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            self.blurButton.alpha = 0
                        } completion: { done in
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }

    }
    
    
}
