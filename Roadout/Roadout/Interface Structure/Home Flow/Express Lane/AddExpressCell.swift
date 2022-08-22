//
//  AddExpressCell.swift
//  Roadout
//
//  Created by David Retegan on 23.07.2022.
//

import UIKit

class AddExpressCell: UITableViewCell {

    @IBOutlet weak var locationNameLbl: UILabel!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var card: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 10.0
    }

}
