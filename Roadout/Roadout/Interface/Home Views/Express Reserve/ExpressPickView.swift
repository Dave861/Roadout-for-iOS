//
//  ExpressPickView.swift
//  Roadout
//
//  Created by David Retegan on 07.11.2021.
//

import UIKit
import CoreLocation

class ExpressPickView: UIView {
    
    var focusedLocationIndex = 0
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        NotificationCenter.default.post(name: .returnToSearchBarID, object: nil)
    }
    
    @IBOutlet weak var statusLbl: UILabel!
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(showNoFreeSpotAlert), name: .showNoFreeSpotInLocationID, object: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        manageObs()
        
        self.layer.cornerRadius = 19.0
        
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        self.statusLbl.text = "Tap a location to find a free spot there"
        
        collectionView.register(UINib(nibName: "ExpressPickCell", bundle: nil), forCellWithReuseIdentifier: "ExpressPickCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        layoutCollectionView()
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Express", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
        
    func layoutCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 247, height: 70)
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.layoutIfNeeded()
        collectionView.reloadData()
    }
    
    @objc func showNoFreeSpotAlert() {
        DispatchQueue.main.async {
            self.statusLbl.text = "Tap a location to find a free spot there"
            let alert = UIAlertController(title: "Error".localized(), message: "It seems there are no free places in this location at the moment", preferredStyle: .alert)
            alert.view.tintColor = UIColor(named: "ExpressFocus")!
            alert.addAction(UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil))
            self.parentViewController().present(alert, animated: true, completion: nil)
        }
    }
    
}
extension ExpressPickView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parkLocations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpressPickCell", for: indexPath) as! ExpressPickCell
        cell.nameLbl.text = parkLocations[indexPath.row].name
        let occupancyPercent = 100 -  Int(Float(parkLocations[indexPath.row].freeSpots)/Float(parkLocations[indexPath.row].totalSpots)*100)
        cell.occupancyLbl.text = "\(occupancyPercent)% occupied"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        self.statusLbl.text = "Loading..."
        selectedParkLocationIndex = indexPath.row
        FunctionsManager.sharedInstance.foundSpot = nil
        FunctionsManager.sharedInstance.expressReserveInLocation(sectionIndex: 0, location: parkLocations[indexPath.row])
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.collectionView.scrollToNearestVisibleCollectionViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionView.scrollToNearestVisibleCollectionViewCell()
        }
    }
    
}
