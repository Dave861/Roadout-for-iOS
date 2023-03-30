//
//  Tutorial .swift
//  Roadout
//
//  Created by David Retegan on 30.06.2022.
//

import Foundation
import UIKit

class TutorialView1: UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var explanationLbl: UILabel!
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        self.layer.cornerRadius = 12.0
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "_account".localized()))
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "_settings".localized()))
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "_User Guide".localized()))
        
        explanationLbl.set(textColor: UIColor.Roadout.mainYellow, range: explanationLbl.range(string: "_account".localized()))
        explanationLbl.set(textColor: UIColor.Roadout.mainYellow, range: explanationLbl.range(string: "_settings".localized()))
        explanationLbl.set(textColor: UIColor.Roadout.mainYellow, range: explanationLbl.range(string: "_User Guide".localized()))
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Tutorials", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

class TutorialView2: UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var explanationLbl: UILabel!
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        self.layer.cornerRadius = 12.0
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "_easiest".localized()))
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "_nearest".localized()))
        
        explanationLbl.set(textColor: UIColor.Roadout.greyish, range: explanationLbl.range(string: "_easiest".localized()))
        explanationLbl.set(textColor: UIColor.Roadout.greyish, range: explanationLbl.range(string: "_nearest".localized()))
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Tutorials", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }
}

class TutorialView3: UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var explanationLbl: UILabel!
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        self.layer.cornerRadius = 12.0
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "_free".localized()))
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "_favourite".localized()))
        
        explanationLbl.set(textColor: UIColor.Roadout.expressFocus, range: explanationLbl.range(string: "_free".localized()))
        explanationLbl.set(textColor: UIColor.Roadout.expressFocus, range: explanationLbl.range(string: "_favourite".localized()))
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Tutorials", bundle: nil).instantiate(withOwner: nil, options: nil)[2] as! UIView
    }
}

class TutorialView4: UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var explanationLbl: UILabel!
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        self.layer.cornerRadius = 12.0
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "_pay".localized()))
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "_location".localized()))
        
        explanationLbl.set(textColor: UIColor.Roadout.cashYellow, range: explanationLbl.range(string: "_pay".localized()))
        explanationLbl.set(textColor: UIColor.Roadout.cashYellow, range: explanationLbl.range(string: "_location".localized()))
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Tutorials", bundle: nil).instantiate(withOwner: nil, options: nil)[3] as! UIView
    }
}

class TutorialView5: UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var explanationLbl: UILabel!
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        self.layer.cornerRadius = 12.0
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "_future".localized()))
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "_worry".localized()))
        
        explanationLbl.set(textColor: UIColor.Roadout.icons, range: explanationLbl.range(string: "_future".localized()))
        explanationLbl.set(textColor: UIColor.Roadout.icons, range: explanationLbl.range(string: "_worry".localized()))
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Tutorials", bundle: nil).instantiate(withOwner: nil, options: nil)[4] as! UIView
    }
}
