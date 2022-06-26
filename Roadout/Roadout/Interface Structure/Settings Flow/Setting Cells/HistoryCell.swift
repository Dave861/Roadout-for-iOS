//
//  HistoryCell.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//
import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 16.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
