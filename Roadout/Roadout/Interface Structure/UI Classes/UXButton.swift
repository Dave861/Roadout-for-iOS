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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(buttonHeld), for: .touchDown)
        self.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
    }

    
    @objc func buttonHeld() {
        if !self.showsMenuAsPrimaryAction {
            UIView.animate(withDuration: 0.1, animations: {
                self.color = self.backgroundColor
                self.backgroundColor = self.color.withAlphaComponent(0.8)
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
    
}
