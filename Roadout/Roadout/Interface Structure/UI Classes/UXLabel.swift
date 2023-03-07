//
//  UXLabel.swift
//  Roadout
//
//  Created by David Retegan on 04.03.2023.
//

import Foundation
import UIKit

class UXLabel: UILabel {
    
    override var text: String? {
        didSet {
            super.text = text?.localized()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.text = self.text?.localized()
    }
    
}
