//
//  SquigglyView.swift
//  Roadout
//
//  Created by David Retegan on 04.04.2023.
//

import Foundation
import UIKit

class SquigglyView: UIView {
    
    let extraHeight = 4.0

    override func draw(_ rect: CGRect) {
        let viewWidth = rect.size.width

        //Making path for squiggle
        let squigglyPath = UIBezierPath()

        //Move to starting point
        squigglyPath.move(to: CGPoint(x: 0, y: extraHeight))

        //Make series of curves to create the squiggles
        for i in stride(from: 0, to: viewWidth, by: 30) {
            squigglyPath.addQuadCurve(
                to: CGPoint(x: i+15, y: extraHeight+10),
                controlPoint: CGPoint(x: i+7.5, y: extraHeight+5)
            )
            squigglyPath.addQuadCurve(
                to: CGPoint(x: i+30, y: extraHeight),
                controlPoint: CGPoint(x: i+22.5, y: extraHeight+5)
            )

        }

        //Make the shape layer for the squiggly line
        let squigglyLayer = CAShapeLayer()
        squigglyLayer.path = squigglyPath.cgPath
        squigglyLayer.strokeColor = UIColor.systemGray3.cgColor
        squigglyLayer.lineWidth = 2
        squigglyLayer.fillColor = UIColor.clear.cgColor

        //Add the shape layer to the layer of the view
        layer.addSublayer(squigglyLayer)
    }
}
