//
//  SearchCell.swift
//  Roadout
//
//  Created by David Retegan on 27.10.2021.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var card: UIView!
    
    //@IBOutlet weak var numberLbl: UILabel!
    //@IBOutlet weak var spotsLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    @IBOutlet weak var gaugeIcon: UIImageView!
    @IBOutlet weak var gaugeCircle: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 12.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
