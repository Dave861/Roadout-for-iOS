//
//  SelectPayCell.swift
//  Roadout
//
//  Created by David Retegan on 19.07.2022.
//

import UIKit

class SelectPayCell: UITableViewCell {

    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    @IBOutlet weak var gaugeIcon: UIImageView!
    @IBOutlet weak var distanceIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 12.0
        gaugeIcon.image = gaugeIcon.image?.withRenderingMode(.alwaysTemplate)
        gaugeIcon.tintColor = UIColor(named: "Cash Yellow")!
        distanceIcon.tintColor = UIColor(named: "Cash Yellow")!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
