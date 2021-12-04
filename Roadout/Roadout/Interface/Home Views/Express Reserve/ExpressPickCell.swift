//
//  ExpressPickCell.swift
//  Roadout
//
//  Created by David Retegan on 13.11.2021.
//

import UIKit

class ExpressPickCell: UIView {

    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var freeSpotsLbl: UILabel!
    
    @IBOutlet weak var freeLbl: UILabel!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 18.0
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ExpressPickCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
