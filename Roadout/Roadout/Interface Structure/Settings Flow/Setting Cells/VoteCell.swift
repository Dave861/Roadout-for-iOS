//
//  VoteCell.swift
//  Roadout
//
//  Created by David Retegan on 15.01.2023.
//

import UIKit

class VoteCell: UITableViewCell {
    
    public var index: Int!

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var explanationLbl: UILabel!
    
    @IBOutlet weak var optionIcon: UIButton!
    @IBAction func optionTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        selectedOptionIndex = index
        NotificationCenter.default.post(name: .refreshOptionsTableViewID, object: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 16.0
        optionIcon.setTitle("", for: .normal)
    }

}
