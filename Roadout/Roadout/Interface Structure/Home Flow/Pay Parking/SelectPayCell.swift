//
//  SelectPayCell.swift
//  Roadout
//
//  Created by David Retegan on 19.07.2022.
//

import UIKit

class SelectPayCell: UITableViewCell {

    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var spotLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    @IBOutlet weak var spotNumber: UILabel!
    
    @IBOutlet weak var spotBorder: UIImageView!
    @IBOutlet weak var spotBackground: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 12.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
