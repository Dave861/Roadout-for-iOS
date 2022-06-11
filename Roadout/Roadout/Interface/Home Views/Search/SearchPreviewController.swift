//
//  SearchCard.swift
//  Roadout
//
//  Created by David Retegan on 07.06.2022.
//

import Foundation
import UIKit
import CoreLocation

class SearchPreviewController: UIViewController {
    
    var previewLocationName = ""
    var previewLocationDistance = ""
    var previewLocationFreeSpots = 0
    var previewLocationSections = 0
    var previewLocationColor = UIColor.label
    
    @IBOutlet weak var locationNameLbl: UILabel!
    
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var sectionsLbl: UILabel!
    @IBOutlet weak var spotsLbl: UILabel!
    
    @IBOutlet weak var distanceIcon: UIImageView!
    @IBOutlet weak var gridIcon: UIImageView!
    @IBOutlet weak var spotIcon: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        locationNameLbl.text = previewLocationName
        distanceLbl.text = previewLocationDistance
        spotsLbl.text = "\(previewLocationFreeSpots) " + "free spots".localized()
        sectionsLbl.text = "\(previewLocationSections) " + "sections".localized()
        
        distanceIcon.tintColor = previewLocationColor
        gridIcon.tintColor = previewLocationColor
        spotIcon.tintColor = previewLocationColor
        
    }
}
