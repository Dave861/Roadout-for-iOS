//
//  CardCell.swift
//  Roadout
//
//  Created by David Retegan on 28.10.2021.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var cardNrLbl: UILabel!
    @IBOutlet weak var cardIcon: UIImageView!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var selectedImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 16.0
        cardIcon.layer.cornerRadius = 6.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}