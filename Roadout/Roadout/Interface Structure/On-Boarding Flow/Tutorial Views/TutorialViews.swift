//
//  Tutorial .swift
//  Roadout
//
//  Created by David Retegan on 30.06.2022.
//

import Foundation
import UIKit

class TutorialView1: UIView {
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        self.layer.cornerRadius = 12.0
        
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Tutorials", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

class TutorialView2: UIView {
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        self.layer.cornerRadius = 12.0
        
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Tutorials", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }
}

class TutorialView3: UIView {
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        self.layer.cornerRadius = 12.0
        
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Tutorials", bundle: nil).instantiate(withOwner: nil, options: nil)[2] as! UIView
    }
}
