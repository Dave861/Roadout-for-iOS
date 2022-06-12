//
//  TutorialTableViewCell.swift
//  Roadout
//
//  Created by David Retegan on 12.06.2022.
//

import UIKit

class TutorialCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
