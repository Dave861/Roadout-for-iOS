//
//  UnlockedView.swift
//  Roadout
//
//  Created by David Retegan on 01.11.2021.
//

import UIKit

class UnlockedView: UIView {
    
    let buttonTitle = NSAttributedString(string: "Directions",
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Brownish")!])
    
    @IBOutlet weak var directionsBtn: UIButton!
    
    @IBAction func directionsTapped(_ sender: Any) {
        var link: String
        switch UserPrefsUtils.sharedInstance.returnPrefferedMapsApp() {
        case "Google Maps":
            link = "https://www.google.com/maps/search/?api=1&query=46.565645,32.65565"
        case "Waze":
            link = "https://www.waze.com/ul?ll=46.565645%2C-32.65565&navigate=yes&zoom=15"
        default:
            link = "http://maps.apple.com/?ll=46.565645,32.65565&q=Parking%20Location"
        }
        guard UIApplication.shared.canOpenURL(URL(string: link)!) else { return }
        UIApplication.shared.open(URL(string: link)!)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 12.0
        directionsBtn.setAttributedTitle(buttonTitle, for: .normal)
        timerSeconds = 0
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Bars", bundle: nil).instantiate(withOwner: nil, options: nil)[2] as! UIView
    }

}
