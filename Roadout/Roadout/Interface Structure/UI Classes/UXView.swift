//
//  UXView.swift
//  Roadout
//
//  Created by David Retegan on 15.04.2023.
//

import Foundation
import UIKit

class UXView: UIView {
    
    var accentColor: UIColor = UIColor.Roadout.mainYellow {
        didSet {
            layer.shadowColor = accentColor.cgColor
        }
    }

    private var glowIntensity: CGFloat = 0 {
        didSet {
            updateGlow()
        }
    }
    private var isPanning: Bool = false
    private var panStartLocation: CGPoint = .zero
    private var panLastLocation: CGPoint = .zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    

    private func setUp() {
        self.layer.cornerRadius = 10
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)

        layer.shadowColor = accentColor.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shadowOpacity = 0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }

    private func updateGlow() {
        layer.shadowOpacity = Float(glowIntensity)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            isPanning = true
            panStartLocation = gesture.location(in: self)
            panLastLocation = panStartLocation
        case .changed:
            let currentLocation = gesture.location(in: self)
            let distance = currentLocation.x - panLastLocation.x
            let maxDistance = bounds.width / 2.0

            var intensity = max(0, min(abs(distance) / maxDistance, 1.0))
            if distance < 0 {
                intensity *= -1 //Reverse the intensity for leftward movement
            }
            glowIntensity += intensity

            //Keep the glow intensity in the range [0, 1]
            glowIntensity = max(0, min(glowIntensity, 0.5))

            panLastLocation = currentLocation
        case .ended:
            isPanning = false
            let currentLocation = gesture.location(in: self)
            let distance = currentLocation.x - panStartLocation.x
            let maxDistance = bounds.width / 2.0

            if distance > 0 && abs(distance) > maxDistance {
                viewSwipedBack()
            }
            glowIntensity = 0
        default:
            isPanning = false
            glowIntensity = 0
        }
    }

    open func viewSwipedBack() {
        //Do required set up in view
    }
    
    open func excludePansFrom(touch: UITouch) -> Bool {
        //Do required set up in view
        return true
    }
}

extension UXView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Prevent the pan gesture recognizer from receiving touch events for the button's frame
        return excludePansFrom(touch: touch)
    }
}
