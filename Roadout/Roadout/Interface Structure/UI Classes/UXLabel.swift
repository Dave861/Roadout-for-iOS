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

class UXTextView: UITextView {
    
    override var text: String! {
        didSet {
            super.text = text!.localized()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.text = self.text!.localized()
    }
    
}

class UXPlainButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(titleLabel?.text?.localized(), for: .normal)
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title?.localized(), for: state)
    }
    
}
