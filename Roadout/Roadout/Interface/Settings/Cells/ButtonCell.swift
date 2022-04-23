//
//  ButtonCell.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit

class ButtonCell: UITableViewCell {

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var cellButton: UIButton!
    
    let buttonTitle = NSAttributedString(string: "Sign Out".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Kinda Red")])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 13.0
        cellButton.setAttributedTitle(buttonTitle, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
