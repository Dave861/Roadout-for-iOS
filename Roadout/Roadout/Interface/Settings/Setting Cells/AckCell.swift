//
//  AckCell.swift
//  Roadout
//
//  Created by David Retegan on 06.02.2022.
//

import UIKit

class AckCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var copyrightLbl: UILabel!
    @IBOutlet weak var linkLbl: UILabel!
    
    @IBOutlet weak var card: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 14.0
    }

}
