//
//  SpotView.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit

class SpotView: UIView {
    
    let removeSpotCardID = "ro.roadout.Roadout.removeSpotCardID"
    let addReserveCardID = "ro.roadout.Roadout.addReserveCardID"
    let spotStates = [0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 2, 0]

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var infoCard: UIView!
    @IBOutlet weak var infoIcon: UIImageView!
    @IBOutlet weak var infoText: UILabel!
    
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: Notification.Name(addReserveCardID), object: nil)
        
    }
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        NotificationCenter.default.post(name: Notification.Name(removeSpotCardID), object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    let continueTitle = NSAttributedString(string: "Continue", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.layer.cornerRadius = 13.0
        continueBtn.layer.cornerRadius = 12.0
        backBtn.setTitle("", for: .normal)
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        continueBtn.isEnabled = false
        continueBtn.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        let selectedItem = collectionView.indexPathsForSelectedItems?.first
        if selectedItem != nil {
            let index = (selectedItem![0])*collectionView.numberOfItems(inSection: 0) + selectedItem![1]
            if spotStates[index] == 0 {
                continueBtn.isEnabled = true
                continueBtn.backgroundColor = UIColor(named: "Main Yellow")?.withAlphaComponent(1.0)
            }
        }
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        infoCard.layer.cornerRadius = 9.0
        
        collectionView.register(UINib(nibName: "SpotCell", bundle: nil), forCellWithReuseIdentifier: "SpotCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = centerItemsInCollectionView(cellWidth: 35, numberOfItems: 9, spaceBetweenCell: 1, collectionView: collectionView)
        layout.itemSize = CGSize(width: 35, height: 50)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 7
        collectionView.collectionViewLayout = layout
        collectionView.layoutIfNeeded()
        let cvHeight = collectionView.frame.height
        let contentHeight = collectionView.contentSize.height
        collectionView.contentInset.top = max((cvHeight-contentHeight)/2, 0)
        collectionView.layoutIfNeeded()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = centerItemsInCollectionView(cellWidth: 35, numberOfItems: 9, spaceBetweenCell: 1, collectionView: collectionView)
        layout.itemSize = CGSize(width: 35, height: 50)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 7
        collectionView.collectionViewLayout = layout
        collectionView.layoutIfNeeded()
        let cvHeight = collectionView.frame.height
        let contentHeight = collectionView.contentSize.height
        collectionView.contentInset.top = max((cvHeight-contentHeight)/2, 0)
        collectionView.layoutIfNeeded()
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[2] as! UIView
    }
    
    func centerItemsInCollectionView(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
        let totalWidth = cellWidth * numberOfItems
        let totalSpacingWidth = spaceBetweenCell * (numberOfItems - 1)
        let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: max(leftInset, 0), bottom: 7, right: max(rightInset, 0))
    }
    
    func updateInfo(spotState: Int) {
        switch spotState {
        case 0:
            continueBtn.isEnabled = true
            continueBtn.backgroundColor = UIColor(named: "Main Yellow")?.withAlphaComponent(1.0)
            infoIcon.image = UIImage(systemName: "checkmark")
            infoIcon.tintColor = UIColor(named: "Main Yellow")
            infoText.text = "Selected spot is free"
        case 1:
            continueBtn.isEnabled = false
            continueBtn.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
            infoIcon.image = UIImage(systemName: "xmark")
            infoIcon.tintColor = UIColor(named: "Redish")
            infoText.text = "Selected spot is occupied"
        default:
            continueBtn.isEnabled = false
            continueBtn.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
            infoIcon.image = UIImage(systemName: "hammer")
            infoIcon.tintColor = UIColor(named: "Dark Yellow")
            infoText.text = "Selected spot is under maintenance"
        }
    }

}
extension SpotView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpotCell", for: indexPath) as! SpotCell
    
        let index = (indexPath[0])*collectionView.numberOfItems(inSection: 0) + indexPath[1]
        
        switch spotStates[index] {
            case 0:
                cell.outlineView.backgroundColor = UIColor(named: "Main Yellow")
                cell.mainBtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
                cell.mainBtn.tintColor = UIColor(named: "Main Yellow")
            case 1:
                cell.outlineView.backgroundColor = UIColor(named: "Redish")
                cell.mainBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
                cell.mainBtn.tintColor = UIColor(named: "Redish")
            default:
                cell.outlineView.backgroundColor = UIColor(named: "Dark Yellow")
                cell.mainBtn.setImage(UIImage(systemName: "hammer"), for: .normal)
                cell.mainBtn.tintColor = UIColor(named: "Dark Yellow")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SpotCell
        
        let index = (indexPath[0])*collectionView.numberOfItems(inSection: 0) + indexPath[1]
        updateInfo(spotState: spotStates[index])
        
        switch spotStates[index] {
            case 0:
                cell.mainBtn.backgroundColor = UIColor(named: "Main Yellow")
                cell.mainBtn.tintColor = UIColor(named: "Background")
            case 1:
                cell.mainBtn.backgroundColor = UIColor(named: "Redish")
                cell.mainBtn.tintColor = UIColor(named: "Background")
            default:
                cell.mainBtn.backgroundColor = UIColor(named: "Dark Yellow")
                cell.mainBtn.tintColor = UIColor(named: "Background")
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SpotCell
        
        let index = (indexPath[0])*collectionView.numberOfItems(inSection: 0) + indexPath[1]
        
        switch spotStates[index] {
            case 0:
                cell.mainBtn.backgroundColor = UIColor(named: "Background")
                cell.mainBtn.tintColor = UIColor(named: "Main Yellow")
            case 1:
                cell.mainBtn.backgroundColor = UIColor(named: "Background")
                cell.mainBtn.tintColor = UIColor(named: "Redish")
            default:
                cell.mainBtn.backgroundColor = UIColor(named: "Background")
                cell.mainBtn.tintColor = UIColor(named: "Dark Yellow")
        }
    }
}
