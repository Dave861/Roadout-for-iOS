//
//  HomeViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit
import GoogleMaps
import CoreLocation

class HomeViewController: UIViewController {

    var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var searchBar: UIView!
    
    @IBAction func searchTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func settingsTapped(_ sender: Any) {
        print("Settings")
    }
    
    @IBOutlet weak var searchTapArea: UIButton!
    @IBOutlet weak var settingsTapArea: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTapArea.setTitle("", for: .normal)
        settingsTapArea.setTitle("", for: .normal)
        
        searchBar.layer.cornerRadius = 13.0
        
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOpacity = 0.1
        searchBar.layer.shadowOffset = .zero
        searchBar.layer.shadowRadius = 10
        searchBar.layer.shadowPath = UIBezierPath(rect: searchBar.bounds).cgPath
        searchBar.layer.shouldRasterize = true
        searchBar.layer.rasterizationScale = UIScreen.main.scale
        
        let camera = GMSCameraPosition.camera(withLatitude: 46.7712, longitude: 23.6236, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.insertSubview(mapView, at: 0)
        
        switch traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    do {
                      if let styleURL = Bundle.main.url(forResource: "lightStyle", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                      } else {
                        print("Unable to find style.json")
                      }
                    } catch {
                        print("One or more of the map styles failed to load. \(error)")
                    }
                case .dark:
                    do {
                      if let styleURL = Bundle.main.url(forResource: "darkStyle", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                      } else {
                        print("Unable to find style.json")
                      }
                    } catch {
                        print("One or more of the map styles failed to load. \(error)")
                    }
        @unknown default:
            break
        }
        
        locationManager.distanceFilter = 100
        locationManager.delegate = self
        if #available(iOS 14.0, *) {
            if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
                mapView.isMyLocationEnabled = true
            }
        } else {
            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
                mapView.isMyLocationEnabled = true
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        switch traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    do {
                      if let styleURL = Bundle.main.url(forResource: "lightStyle", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                      } else {
                        print("Unable to find style.json")
                      }
                    } catch {
                        print("One or more of the map styles failed to load. \(error)")
                    }
                case .dark:
                    do {
                      if let styleURL = Bundle.main.url(forResource: "darkStyle", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                      } else {
                        print("Unable to find style.json")
                      }
                    } catch {
                        print("One or more of the map styles failed to load. \(error)")
                    }
        @unknown default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

}
extension HomeViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
                mapView.isMyLocationEnabled = true
            }
        } else {
            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
                mapView.isMyLocationEnabled = true
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last

        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)

        self.mapView?.animate(to: camera)

            //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
}
