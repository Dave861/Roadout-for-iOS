//
//  GuideCell.swift
//  Roadout
//
//  Created by David Retegan on 14.01.2023.
//

import UIKit

class GuideCell: UITableViewCell {
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var explanationLbl: UILabel!
    
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 16.0
    }

}
