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
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "account"))
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "settings"))
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "Roadout Guide"))
        
        explanationLbl.set(textColor: UIColor(named: "GoldBrown")!, range: explanationLbl.range(string: "account"))
        explanationLbl.set(textColor: UIColor(named: "GoldBrown")!, range: explanationLbl.range(string: "settings"))
        explanationLbl.set(textColor: UIColor(named: "GoldBrown")!, range: explanationLbl.range(string: "Roadout Guide"))
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
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "easiest"))
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "nearest"))
        
        explanationLbl.set(textColor: UIColor(named: "GoldBrown")!, range: explanationLbl.range(string: "easiest"))
        explanationLbl.set(textColor: UIColor(named: "GoldBrown")!, range: explanationLbl.range(string: "nearest"))
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
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "free"))
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "favourite"))
        
        explanationLbl.set(textColor: UIColor(named: "GoldBrown")!, range: explanationLbl.range(string: "free"))
        explanationLbl.set(textColor: UIColor(named: "GoldBrown")!, range: explanationLbl.range(string: "favourite"))
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
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "pay"))
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "location"))
        
        explanationLbl.set(textColor: UIColor(named: "GoldBrown")!, range: explanationLbl.range(string: "pay"))
        explanationLbl.set(textColor: UIColor(named: "GoldBrown")!, range: explanationLbl.range(string: "location"))
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
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "future"))
        explanationLbl.set(font: .systemFont(ofSize: 17, weight: .medium), range: explanationLbl.range(string: "worry"))
        
        explanationLbl.set(textColor: UIColor(named: "GoldBrown")!, range: explanationLbl.range(string: "future"))
        explanationLbl.set(textColor: UIColor(named: "GoldBrown")!, range: explanationLbl.range(string: "worry"))
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Tutorials", bundle: nil).instantiate(withOwner: nil, options: nil)[4] as! UIView
    }
}
