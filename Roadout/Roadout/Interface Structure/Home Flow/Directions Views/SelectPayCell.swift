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
    @IBOutlet weak var currentLocationLbl: UILabel!
    
    @IBOutlet weak var distanceIcon: UIImageView!
    @IBOutlet weak var currentLocationIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 12.0
        distanceIcon.tintColor = UIColor.Roadout.cashYellow
        currentLocationIcon.tintColor = UIColor.Roadout.cashYellow
        
        currentLocationLbl.isHidden = true
        currentLocationIcon.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
