//
//  SearchCell.swift
//  Roadout
//
//  Created by David Retegan on 27.10.2021.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var spotsLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
