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
    
    private var isAnimating = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(titleLabel?.text?.localized(), for: .normal)
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title?.localized(), for: state)
    }
    
    func startPulseAnimation() {
        guard !isAnimating else { return }
        
        isAnimating = true
        isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.7, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.alpha = 0.8
        }, completion: nil)
    }
    
    func stopPulseAnimation() {
        isAnimating = false
        isUserInteractionEnabled = true
        
        layer.removeAllAnimations()
        transform = CGAffineTransform.identity
        alpha = 1.0
    }
    
}

class UXResizeLabel: UILabel {
    
    @IBInspectable var longText: String? {
        didSet {
            longText = longText?.localized()
        }
    }
    @IBInspectable var mediumText: String? {
        didSet {
            mediumText = mediumText?.localized()
        }
    }
    @IBInspectable var shortText: String? {
        didSet {
            shortText = shortText?.localized()
        }
    }
    
    override var text: String? {
        didSet {
            resizeTextIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeTextIfNeeded()
    }
    
    private func resizeTextIfNeeded() {
        guard let currentText = text else { return }
        
        let availableWidth = bounds.width
        let longTextWidth = (longText! as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: bounds.height),
                                                                 options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                 attributes: [NSAttributedString.Key.font: font as Any],
                                                                 context: nil).width
        let mediumTextWidth = (mediumText! as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: bounds.height),
                                                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                     attributes: [NSAttributedString.Key.font: font as Any],
                                                                     context: nil).width
        let shortTextWidth = (shortText! as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: bounds.height),
                                                                   options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                   attributes: [NSAttributedString.Key.font: font as Any],
                                                                   context: nil).width
        
        if longTextWidth <= availableWidth {
            super.text = longText
        } else if mediumTextWidth <= availableWidth {
            super.text = mediumText
        } else if shortTextWidth <= availableWidth {
            super.text = shortText
        } else {
            super.text = ""
        }
    }
}
