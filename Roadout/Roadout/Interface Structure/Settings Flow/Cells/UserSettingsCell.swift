//
//  UserSettingsCell.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit

class UserSettingsCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
        
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var icon: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 16.0
        icon.layer.cornerRadius = icon.frame.height/4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
