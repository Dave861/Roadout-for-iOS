//
//  SettingCell.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var icon: UIView!
    @IBOutlet weak var settingLbl: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.layer.cornerRadius = icon.frame.height/4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
