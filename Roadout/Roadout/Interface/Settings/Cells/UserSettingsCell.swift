//
//  UserSettingsCell.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit

class UserSettingsCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    
    @IBAction func editTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var card: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 16.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
