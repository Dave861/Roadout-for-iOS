//
//  NotificationCell.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBAction func switched(_ sender: UISwitch) {
    }
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var explanationLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 16.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
