//
//  FutureReserveCell.swift
//  Roadout
//
//  Created by David Retegan on 16.01.2023.
//

import UIKit

class FutureReserveCell: UITableViewCell {

    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 12.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cellActionButtonLabel?.textColor = UIColor(named: "Redish") ?? .systemRed
    }
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        cellActionButtonLabel?.textColor = UIColor(named: "Redish") ?? .systemRed
    }
    
}