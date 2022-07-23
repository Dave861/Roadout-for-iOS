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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        check.alpha = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            check.alpha = 1
        } else {
            check.alpha = 0
        }
    }

}
