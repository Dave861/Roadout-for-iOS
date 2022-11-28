//
//  SearchCard.swift
//  Roadout
//
//  Created by David Retegan on 07.06.2022.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps

class SearchPreviewController: UIViewController {
    
    var mapView: GMSMapView!
    
    var previewLocationName = ""
    var previewLocationDistance = ""
    var previewLocationFreeSpots = 0
    var previewLocationSections = 0
    var previewLocationCoords: CLLocationCoordinate2D!
    var previewLocationColor = UIColor.label
    var previewLocationColorName = "Main Yellow"
    
    @IBOutlet weak var mapHostView: UIView!
    
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
            
        let camera = GMSCameraPosition.camera(withLatitude: previewLocationCoords.latitude, longitude: previewLocationCoords.longitude, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: self.mapHostView.frame, camera: camera)
       
        self.mapHostView.insertSubview(mapView, at: 0)
        
        self.addMarkerWithColor(previewLocationColorName)
        
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                self.applyStyleToMap(style: "lightStyle")
            case .dark:
                self.applyStyleToMap(style: "darkStyle")
            @unknown default:
                break
        }
        
        if selectedMapType == .roadout {
            mapView.mapType = .normal
        } else if selectedMapType == .satellite {
            mapView.mapType = .satellite
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = mapHostView.frame
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                self.applyStyleToMap(style: "lightStyle")
            case .dark:
                self.applyStyleToMap(style: "darkStyle")
        @unknown default:
            break
        }
    }
    
    func applyStyleToMap(style: String) {
        do {
          if let styleURL = Bundle.main.url(forResource: style, withExtension: "json") {
            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
          } else {
            print("Unable to find style.json")
          }
        } catch {
            print("One or more of the map styles failed to load. \(error)")
        }
    }
    
    func addMarkerWithColor(_ color: String) {
        mapView.clear()
        guard let markerPosition = previewLocationCoords else { return }
        let marker = GMSMarker(position: markerPosition)
        marker.title = previewLocationName
        marker.infoWindowAnchor = CGPoint()
        //Snippet used for marker color coordination
        marker.snippet = color
        marker.icon = UIImage(named: "Marker_\(color)")?.withResize(scaledToSize: CGSize(width: 20.0, height: 20.0))
        marker.map = mapView
    }
    
}
