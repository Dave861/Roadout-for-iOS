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
    private var isAnimating = false
    
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
    
    func startPulseAnimation() {
        guard !isAnimating else { return }
        
        isAnimating = true
        isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.7, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.color = self.backgroundColor
            if self.coloriseEffect {
                self.backgroundColor = self.tintColor.withAlphaComponent(0.4)
            } else {
                self.backgroundColor = self.color.withAlphaComponent(0.8)
            }
        }, completion: nil)
    }
    
    func stopPulseAnimation() {
        isAnimating = false
        isUserInteractionEnabled = true
        
        layer.removeAllAnimations()
        transform = CGAffineTransform.identity
        backgroundColor = self.color
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

class ZoneButton: UIButton {
    
    private var slashLayer: CAShapeLayer?
    
    var slashColor = UIColor.Roadout.icons
    
    override var isEnabled: Bool {
        didSet {
            updateSlashOverlay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSlashOverlay()
    }
    
    private func updateSlashOverlay() {
        slashLayer?.removeFromSuperlayer()
        slashLayer = nil
        
        if !isEnabled {
            let slashPath = UIBezierPath()
            slashPath.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            slashPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
            
            let newSlashLayer = CAShapeLayer()
            newSlashLayer.path = slashPath.cgPath
            newSlashLayer.strokeColor = self.slashColor.cgColor // Customize the color of the slash
            newSlashLayer.lineWidth = 3.0 // Customize the width of the slash
            newSlashLayer.lineCap = .round
            
            layer.addSublayer(newSlashLayer)
            slashLayer = newSlashLayer
            
            layer.cornerRadius = 17
        }
    }
}
