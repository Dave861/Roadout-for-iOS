//
//  PrizesCell.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit

class PrizesCell: UITableViewCell {

    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var prizeImage: UIImageView!
    @IBOutlet weak var prizeLbl: UILabel!
    @IBOutlet weak var requirementLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 16.0
        prizeImage.layer.cornerRadius = 16.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
