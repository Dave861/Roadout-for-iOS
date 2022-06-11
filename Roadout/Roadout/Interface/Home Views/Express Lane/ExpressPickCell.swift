//
//  ExpressPickCell.swift
//  Roadout
//
//  Created by David Retegan on 13.11.2021.
//

import UIKit

class ExpressPickCell: UICollectionViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var occupancyLbl: UILabel!
    
    @IBOutlet weak var distanceLbl: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 16.0
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 16.0
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ExpressPickCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
