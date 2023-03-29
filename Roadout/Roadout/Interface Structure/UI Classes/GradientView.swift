//
//  GradientView.swift
//  Roadout
//
//  Created by David Retegan on 15.05.2022.
//

import Foundation
import UIKit

class GradientView: UIView {
    
    @IBInspectable var maskCorners: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        gradientLayer.colors = [UIColor.Roadout.icons.withAlphaComponent(0.45).cgColor, UIColor.Roadout.icons.withAlphaComponent(0.77).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradientLayer.cornerRadius = 16.0
        gradientLayer.masksToBounds = true
        
        layer.cornerRadius = 16.0
        layer.masksToBounds = true
        
        if maskCorners {
            gradientLayer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        
        layer.addSublayer(gradientLayer)
        
    }
}

