//
//  SpotView.swift
//  Roadout
//
//  Created by David Retegan on 31.10.2021.
//

import UIKit
import SPIndicator
import PusherSwift

class SpotView: UIView, PusherDelegate {

    var pusher: Pusher!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var infoCard: UIView!
    @IBOutlet weak var infoIcon: UIImageView!
    @IBOutlet weak var infoText: UILabel!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBAction func continueTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        continueBtn.isUserInteractionEnabled = false
        let clockImage = UIImage.init(systemName: "clock")!.withTintColor(UIColor(named: "Dark Orange")!, renderingMode: .alwaysOriginal)
        let checkImage = UIImage.init(systemName: "checkmark")!.withTintColor(UIColor(named: "Dark Yellow")!, renderingMode: .alwaysOriginal)
        let checkingIndicatorView = SPIndicatorView(title: "Confirming".localized(), message: "Checking...".localized(), preset: .custom(clockImage))
        checkingIndicatorView.backgroundColor = UIColor(named: "Background")!
        let confirmedIndicatorView = SPIndicatorView(title: "Confirmed".localized(), message: "Done".localized(), preset: .custom(checkImage))
        confirmedIndicatorView.backgroundColor = UIColor(named: "Background")!
        checkingIndicatorView.present(duration: 0.7, haptic: .none) {
            self.disconnectPusher()
            NotificationCenter.default.post(name: .addReserveCardID, object: nil)
            confirmedIndicatorView.present(duration: 0.7, haptic: .success)
        }
    }
    @IBAction func backTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        self.disconnectPusher()
        guard let selectedItems = collectionView.indexPathsForSelectedItems else {
            NotificationCenter.default.post(name: .removeSpotCardID, object: nil)
            return
        }
         for indexPath in selectedItems {
             collectionView.deselectItem(at: indexPath, animated:true)
         }
        NotificationCenter.default.post(name: .removeSpotCardID, object: nil)
    }
    @IBOutlet weak var backBtn: UIButton!
    
    let continueTitle = NSAttributedString(string: "Continue".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        setUpPusher()
        
        self.layer.cornerRadius = 19.0
        continueBtn.layer.cornerRadius = 12.0
        continueBtn.isUserInteractionEnabled = true
        backBtn.setTitle("", for: .normal)
        backBtn.layer.cornerRadius = 15.0
        continueBtn.setAttributedTitle(continueTitle, for: .normal)
        continueBtn.isEnabled = false
        continueBtn.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        
        
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
        
        layoutCollectionView()
        updateInfo(spotState: 100)
    }

    override func didMoveToSuperview() {
        layoutCollectionView()
    }

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Cards", bundle: nil).instantiate(withOwner: nil, options: nil)[2] as! UIView
    }
    
    func layoutCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = centerItemsInCollectionView(cellWidth: 35, numberOfItems: Double(parkLocations[selectedParkLocationIndex].sections[selectedSectionIndex].rows.max()!), spaceBetweenCell: 1, collectionView: collectionView)
        layout.itemSize = CGSize(width: 35, height: 50)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 7
        collectionView.collectionViewLayout = layout
        collectionView.layoutIfNeeded()
        let cvHeight = collectionView.frame.height
        let contentHeight = collectionView.contentSize.height
        collectionView.contentInset.top = max((cvHeight-contentHeight)/2, 0)
        collectionView.layoutIfNeeded()
        collectionView.reloadData()
    }
    
    
    func setUpPusher() {
        let options = PusherClientOptions(
                host: .cluster("eu")
              )
          pusher = Pusher(
            key: "3ca9033d239bcdc322bd",
            options: options
          )

          pusher.delegate = self

          let channel = pusher.subscribe("testSpots-channel")
        
          let _ = channel.bind(eventName: "spots-changed", eventCallback: { (event: PusherEvent) in
              if let data = event.data {
                  print(data.replacingOccurrences(of: "\"", with: ""))
                  
                let intData = self.getNumbers(data: data.replacingOccurrences(of: "\"", with: ""))
                  parkLocations[selectedParkLocationIndex].sections[selectedSectionIndex].spots[intData[1]-1].state = intData[0]
                self.collectionView.reloadData()
                self.updateInfo(spotState: 100)
              }
          })

          pusher.connect()
    }
    
    func disconnectPusher() {
        pusher.disconnect()
        pusher.unsubscribe("testSpots-channel")
        pusher = nil
    }
    
    
    func getNumbers(data: String) -> [Int] {
        let stringRecordedArr = data.components(separatedBy: ", ")
        return stringRecordedArr.map { Int($0)!}
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
            infoText.text = "Selected spot is free".localized()
        case 1:
            continueBtn.isEnabled = false
            continueBtn.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
            infoIcon.image = UIImage(systemName: "xmark")
            infoIcon.tintColor = UIColor(named: "Redish")
            infoText.text = "Selected spot is occupied".localized()
        case 2:
            continueBtn.isEnabled = false
            continueBtn.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
            infoIcon.image = UIImage(systemName: "clock")
            infoIcon.tintColor = UIColor(named: "Dark Orange")
            infoText.text = "Selected spot is about to be reserved".localized()
        case 3:
            continueBtn.isEnabled = false
            continueBtn.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
            infoIcon.image = UIImage(systemName: "hammer")
            infoIcon.tintColor = UIColor(named: "Dark Yellow")
            infoText.text = "Selected spot is under maintenance".localized()
        default:
            continueBtn.isEnabled = false
            continueBtn.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
            infoIcon.image = UIImage(systemName: "info.circle")
            infoIcon.tintColor = UIColor.label
            infoText.text = "Pick a spot to get info about it".localized()
        }
    }

}
extension SpotView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return parkLocations[selectedParkLocationIndex].sections[selectedSectionIndex].rows.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parkLocations[selectedParkLocationIndex].sections[selectedSectionIndex].rows[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpotCell", for: indexPath) as! SpotCell
    
        let index = (indexPath[0])*collectionView.numberOfItems(inSection: 0) + indexPath[1]
        switch parkLocations[selectedParkLocationIndex].sections[selectedSectionIndex].spots[index].state {
            case 0:
                cell.outlineView.backgroundColor = UIColor(named: "Main Yellow")
                cell.mainBtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
                cell.mainBtn.tintColor = UIColor(named: "Main Yellow")
                cell.mainBtn.backgroundColor = UIColor(named: "Background")
            case 1:
                cell.outlineView.backgroundColor = UIColor(named: "Redish")
                cell.mainBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
                cell.mainBtn.tintColor = UIColor(named: "Redish")
                cell.mainBtn.backgroundColor = UIColor(named: "Background")
            case 2:
                cell.outlineView.backgroundColor = UIColor(named: "Dark Orange")
                cell.mainBtn.setImage(UIImage(systemName: "clock"), for: .normal)
                cell.mainBtn.tintColor = UIColor(named: "Dark Orange")
                cell.mainBtn.backgroundColor = UIColor(named: "Background")
            default:
                cell.outlineView.backgroundColor = UIColor(named: "Dark Yellow")
                cell.mainBtn.setImage(UIImage(systemName: "hammer"), for: .normal)
                cell.mainBtn.tintColor = UIColor(named: "Dark Yellow")
                cell.mainBtn.backgroundColor = UIColor(named: "Background")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! SpotCell
        
        let index = (indexPath[0])*collectionView.numberOfItems(inSection: 0) + indexPath[1]
        updateInfo(spotState: parkLocations[selectedParkLocationIndex].sections[selectedSectionIndex].spots[index].state)
        
        selectedSpotID = parkLocations[selectedParkLocationIndex].sections[selectedSectionIndex].spots[index].rID
        
        switch parkLocations[selectedParkLocationIndex].sections[selectedSectionIndex].spots[index].state {
            case 0:
                cell.mainBtn.backgroundColor = UIColor(named: "Main Yellow")
                cell.mainBtn.tintColor = UIColor(named: "Background")
            case 1:
                cell.mainBtn.backgroundColor = UIColor(named: "Redish")
                cell.mainBtn.tintColor = UIColor(named: "Background")
            case 2:
                cell.mainBtn.backgroundColor = UIColor(named: "Dark Orange")
                cell.mainBtn.tintColor = UIColor(named: "Background")
            default:
                cell.mainBtn.backgroundColor = UIColor(named: "Dark Yellow")
                cell.mainBtn.tintColor = UIColor(named: "Background")
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SpotCell
        
        let index = (indexPath[0])*collectionView.numberOfItems(inSection: 0) + indexPath[1]
        
        switch parkLocations[selectedParkLocationIndex].sections[selectedSectionIndex].spots[index].state {
            case 0:
                cell.mainBtn.backgroundColor = UIColor(named: "Background")
                cell.mainBtn.tintColor = UIColor(named: "Main Yellow")
            case 1:
                cell.mainBtn.backgroundColor = UIColor(named: "Background")
                cell.mainBtn.tintColor = UIColor(named: "Redish")
            case 2:
                cell.mainBtn.backgroundColor = UIColor(named: "Background")
                cell.mainBtn.tintColor = UIColor(named: "Dark Orange")
            default:
                cell.mainBtn.backgroundColor = UIColor(named: "Background")
                cell.mainBtn.tintColor = UIColor(named: "Dark Yellow")
        }
    }
}