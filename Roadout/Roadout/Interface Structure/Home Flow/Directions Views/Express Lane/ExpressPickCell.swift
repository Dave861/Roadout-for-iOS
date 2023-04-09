//
//  ExpressChooseCell.swift
//  Roadout
//
//  Created by David Retegan on 13.11.2021.
//

import UIKit

class ExpressChooseCell: UITableViewCell {

    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    @IBOutlet weak var gaugeIcon: UIImageView!
    @IBOutlet weak var distanceIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 12.0
        gaugeIcon.image = gaugeIcon.image?.withRenderingMode(.alwaysTemplate)
        gaugeIcon.tintColor = UIColor.Roadout.expressFocus
        distanceIcon.tintColor = UIColor.Roadout.expressFocus
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellActionButtonLabel?.textColor = UIColor.Roadout.redish ?? .systemRed
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        cellActionButtonLabel?.textColor = UIColor.Roadout.redish ?? .systemRed
    }
}
