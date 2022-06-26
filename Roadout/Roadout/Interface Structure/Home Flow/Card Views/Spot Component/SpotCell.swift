//
//  SpotCell.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit

class SpotCell: UICollectionViewCell {
    
    @IBOutlet weak var outlineView: UIView!
    @IBOutlet weak var mainBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        outlineView.layer.cornerRadius = 6.0
        mainBtn.layer.cornerRadius = 4.0
        mainBtn.setTitle("", for: .normal)
    }

}
