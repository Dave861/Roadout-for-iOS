//
//  ExpressPickView.swift
//  Roadout
//
//  Created by David Retegan on 07.11.2021.
//

import UIKit
import CoreLocation
import iCarousel

class ExpressPickView: UIView {
    
    let returnToSearchBarID = "ro.roadout.Roadout.returnToSearchBarID"
    let addExpressViewID = "ro.roadout.Roadout.addExpressViewID"
    
    @IBOutlet weak var carousel: iCarousel!
    
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: Notification.Name(returnToSearchBarID), object: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        
        backBtn.setTitle("", for: .normal)

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        carousel.type = .invertedCylinder
        carousel.clipsToBounds = true
        
        carousel.dataSource = self
        carousel.delegate = self
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Express", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    
}
extension ExpressPickView: iCarouselDataSource, iCarouselDelegate {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return parkLocations.count
    }
    
    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
        return 115
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = ExpressPickCell.instanceFromNib() as! ExpressPickCell
        view.nameLbl.text = parkLocations[index].name
        if index == carousel.currentItemIndex {
            view.backgroundColor = UIColor(named: "ExpressFocus")!
            view.nameLbl.textColor = UIColor.white
            view.freeSpotsLbl.textColor = UIColor.white
            view.freeLbl.textColor = UIColor.white
        } else {
            view.backgroundColor = UIColor(named: "ExpressSecond")!
            view.nameLbl.textColor = UIColor.black
            view.freeSpotsLbl.textColor = UIColor.black
            view.freeLbl.textColor = UIColor.black
        }
        view.freeSpotsLbl.text = String(describing: parkLocations[index].freeSpots)
        return view
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        selectedLocation = parkLocations[index].name
        selectedLocationColor = UIColor(named: "Dark Orange")!
        selectedLocationCoord = CLLocationCoordinate2DMake(parkLocations[index].latitude, parkLocations[index].longitude)
        NotificationCenter.default.post(name: Notification.Name(addExpressViewID), object: nil)
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        let index = carousel.currentItemIndex
        if index-1 >= 0 {
            let previousView = carousel.itemView(at: index-1) as! ExpressPickCell
            previousView.backgroundColor = UIColor(named: "ExpressSecond")!
            previousView.nameLbl.textColor = UIColor.black
            previousView.freeSpotsLbl.textColor = UIColor.black
            previousView.freeLbl.textColor = UIColor.black
        }
        if index+1 < parkLocations.count {
            let nextView = carousel.itemView(at: index+1) as! ExpressPickCell
            nextView.backgroundColor = UIColor(named: "ExpressSecond")!
            nextView.nameLbl.textColor = UIColor.black
            nextView.freeSpotsLbl.textColor = UIColor.black
            nextView.freeLbl.textColor = UIColor.black
        }
        if index == 0 {
            let previousView = carousel.itemView(at: parkLocations.count-1) as! ExpressPickCell
            previousView.backgroundColor = UIColor(named: "ExpressSecond")!
            previousView.nameLbl.textColor = UIColor.black
            previousView.freeSpotsLbl.textColor = UIColor.black
            previousView.freeLbl.textColor = UIColor.black
        } else if index == parkLocations.count-1 {
            let nextView = carousel.itemView(at: 0) as! ExpressPickCell
            nextView.backgroundColor = UIColor(named: "ExpressSecond")!
            nextView.nameLbl.textColor = UIColor.black
            nextView.freeSpotsLbl.textColor = UIColor.black
            nextView.freeLbl.textColor = UIColor.black
        }
        let view = carousel.currentItemView as! ExpressPickCell
        view.backgroundColor = UIColor(named: "ExpressFocus")!
        view.nameLbl.textColor = UIColor.white
        view.freeSpotsLbl.textColor = UIColor.white
        view.freeLbl.textColor = UIColor.white
    }
    
}