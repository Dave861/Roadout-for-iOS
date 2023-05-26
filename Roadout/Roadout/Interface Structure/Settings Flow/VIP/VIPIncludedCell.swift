//
//  VIPIncludedCell.swift
//  Roadout
//
//  Created by David Retegan on 26.05.2023.
//

import UIKit

class VIPIncludedCell: UITableViewCell {
    
    @IBOutlet weak var featureLbl: UILabel!
    @IBOutlet weak var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
