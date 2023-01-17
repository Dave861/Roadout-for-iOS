//
//  VoteCell.swift
//  Roadout
//
//  Created by David Retegan on 15.01.2023.
//

import UIKit

class VoteCell: UITableViewCell {
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var explanationLbl: UILabel!
    
    @IBOutlet weak var optionIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 16.0
    }

}
