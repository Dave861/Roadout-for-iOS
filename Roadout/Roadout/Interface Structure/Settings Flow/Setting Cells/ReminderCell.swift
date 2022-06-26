//
//  ReminderCell.swift
//  Roadout
//
//  Created by David Retegan on 28.10.2021.
//

import UIKit

class ReminderCell: UITableViewCell {

    @IBOutlet weak var reminderLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
