//
//  VIPPlansViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.05.2023.
//

import UIKit

class VIPPlansViewController: UIViewController {
    
    enum VIPSubscriptionType {
        case month
        case year
    }
    
    var selectedSubscriptionType = VIPSubscriptionType.month
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var monthPriceLbl: UILabel!
    @IBOutlet weak var yearPriceLbl: UILabel!
    
    @IBOutlet weak var monthSelectedView: UIView!
    @IBOutlet weak var yearSelectedView: UIView!
    
    @IBAction func yearTapped(_ sender: Any) {
        selectedSubscriptionType = .year
        updateSubscriptionType()
    }
    
    @IBAction func monthTapped(_ sender: Any) {
        selectedSubscriptionType = .month
        updateSubscriptionType()
    }
    
    @IBOutlet weak var subscribeBtn: UXButton!
    @IBAction func subscribeTapped(_ sender: Any) {
    
    }
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSubscriptionType() {
        if selectedSubscriptionType == .month {
            descriptionLbl.text = "Plan automatically renews every month."
            monthSelectedView.isHidden = false
            yearSelectedView.isHidden = true
        } else {
            descriptionLbl.text = "Plan automatically renews every year."
            monthSelectedView.isHidden = true
            yearSelectedView.isHidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateSubscriptionType()
    }
    
}
