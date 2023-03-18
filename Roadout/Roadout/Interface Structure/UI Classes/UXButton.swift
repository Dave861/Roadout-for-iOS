//
//  UXButton.swift
//  Roadout
//
//  Created by David Retegan on 29.01.2023.
//

import Foundation
import UIKit

class UXButton: UIButton {
    
    private var color: UIColor!
    
    @IBInspectable var hasShimmer: Bool = false {
        didSet {
            if hasShimmer {
                setupShimmerLayer()
            }
        }
    }
    
    @IBInspectable var adjustFontSizeToWidth: Bool = false {
        didSet {
            if adjustFontSizeToWidth {
                self.titleLabel?.numberOfLines = 1
                self.titleLabel?.adjustsFontSizeToFitWidth = true
                self.titleLabel?.lineBreakMode = .byClipping
                self.titleLabel?.baselineAdjustment = .alignCenters
            }
        }
    }
    
    @IBInspectable var coloriseEffect: Bool = false
    
    @IBInspectable var translateTitle: Bool = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(buttonHeld), for: .touchDown)
        self.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
    }

    
    @objc func buttonHeld() {
        if !self.showsMenuAsPrimaryAction {
            UIView.animate(withDuration: 0.1, animations: {
                self.color = self.backgroundColor
                if self.coloriseEffect {
                    self.backgroundColor = self.tintColor.withAlphaComponent(0.4)
                } else {
                    self.backgroundColor = self.color.withAlphaComponent(0.8)
                }
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            })
        }
    }

    @objc func buttonReleased() {
        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = self.color
            self.transform = CGAffineTransform.identity
        })
    }
    
    private func setupShimmerLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
    
}
