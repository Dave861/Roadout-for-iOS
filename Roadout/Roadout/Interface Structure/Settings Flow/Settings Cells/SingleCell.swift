//
//  SingleCell.swift
//  Roadout
//
//  Created by David Retegan on 25.05.2023.
//

import UIKit

class SingleCell: UITableViewCell {

    @IBOutlet weak var card: UIView!

    @IBOutlet weak var icon: UIView!
    
    @IBOutlet weak var settingLbl: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.layer.cornerRadius = icon.frame.height/4
        card.layer.cornerRadius = 14.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
