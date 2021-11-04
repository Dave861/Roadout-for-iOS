//
//  HomeViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit
import GoogleMaps
import CoreLocation

var selectedLocation = "Location"
var selectedLocationColor = UIColor(named: "Main Yellow")
var returnToDelay = false
var reservationTimer: Timer!

var startedTimers = 0

class HomeViewController: UIViewController {

    var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    let screenSize: CGRect = UIScreen.main.bounds
    
    //Card Views
    let addResultCardID = "ro.roadout.Roadout.addResultCardID"
    let removeResultCardID = "ro.roadout.Roadout.removeResultCardID"
    let resultView = ResultView.instanceFromNib()
    
    let addSectionCardID = "ro.roadout.Roadout.addSectionCardID"
    let removeSectionCardID = "ro.roadout.Roadout.removeSectionCardID"
    let sectionView = SectionView.instanceFromNib()
    
    let addSpotCardID = "ro.roadout.Roadout.addSpotCardID"
    let removeSpotCardID = "ro.roadout.Roadout.removeSpotCardID"
    let spotView = SpotView.instanceFromNib()
    
    let addReserveCardID = "ro.roadout.Roadout.addReserveCardID"
    let removeReserveCardID = "ro.roadout.Roadout.removeReserveCardID"
    let reserveView = ReserveView.instanceFromNib()
    
    let addPayCardID = "ro.roadout.Roadout.addPayCardID"
    let removePayCardID = "ro.roadout.Roadout.removePayCardID"
    let payView = PayView.instanceFromNib()
    
    let addReservationCardID = "ro.roadout.Roadout.addReservationCardID"
    let removeReservationCardID = "ro.roadout.Roadout.removeReservationCardID"
    let reservationView = ReservationView.instanceFromNib()
    
    let addDelayCardID = "ro.roadout.Roadout.addDelayCardID"
    let removeDelayCardID = "ro.roadout.Roadout.removeDelayCardID"
    let delayView = DelayView.instanceFromNib()
    
    let addPayDelayCardID = "ro.roadout.Roadout.addPayDelayCardID"
    let removePayDelayCardID = "ro.roadout.Roadout.removePayDelayCardID"
    
    
    
    let showPaidBarID = "ro.roadout.Roadout.showPaidBarID"
    let paidBar = PaidView.instanceFromNib()
    
    let showActiveBarID = "ro.roadout.Roadout.showActiveBarID"
    let activeBar = ActiveView.instanceFromNib()
    
    let showUnlockedBarID = "ro.roadout.Roadout.showUnlockedBarID"
    let unlockedBar = UnlockedView.instanceFromNib()
    
    let showCancelledBarID = "ro.roadout.Roadout.showCancelledBarID"
    let cancelledBar = CancelledView.instanceFromNib()
    
    let showNoWifiBarID = "ro.roadout.Roadout.showNoWifiBarID"
    let removeNoWifiBarID = "ro.roadout.Roadout.removeNoWifiBarID"
    let noWifiBar = NoWifiView.instanceFromNib()
    
    let returnToSearchBarID = "ro.roadout.Roadout.returnToSearchBarID"
    
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
    
    @IBOutlet weak var titleLbl: UILabel!
    
    //MARK: - Card Functions-
    //Result Card
    @objc func addResultCard() {
        searchBar.layer.shadowOpacity = 0.0
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
                print("YESS")
            }
            self.resultView.frame = CGRect(x: 13, y: self.screenSize.height-115-dif, width: self.screenSize.width - 26, height: 115)
            self.view.addSubview(self.resultView)
        }
    }
    @objc func removeResultCard() {
        DispatchQueue.main.async {
            self.searchBar.layer.shadowOpacity = 0.1
            self.resultView.removeFromSuperview()
        }
    }
    //Section Card
    @objc func addSectionCard() {
        resultView.removeFromSuperview()
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.sectionView.frame = CGRect(x: 13, y: self.screenSize.height-331-dif, width: self.screenSize.width - 26, height: 331)
            self.view.addSubview(self.sectionView)
        }
    }
    @objc func removeSectionCard() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
                print("YESS")
            }
            self.resultView.frame = CGRect(x: 13, y: self.screenSize.height-110-dif, width: self.screenSize.width - 26, height: 110)
            self.view.addSubview(self.resultView)
            self.sectionView.removeFromSuperview()
        }
    }
    //Spot Card
    @objc func addSpotCard() {
        sectionView.removeFromSuperview()
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.spotView.frame = CGRect(x: 13, y: self.screenSize.height-318-dif, width: self.screenSize.width - 26, height: 318)
            self.view.addSubview(self.spotView)
        }
    }
    @objc func removeSpotCard() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
                print("YESS")
            }
            self.sectionView.frame = CGRect(x: 13, y: self.screenSize.height-331-dif, width: self.screenSize.width - 26, height: 331)
            self.view.addSubview(self.sectionView)
            self.spotView.removeFromSuperview()
        }
    }
    //Reserve Card
    @objc func addReserveCard() {
        spotView.removeFromSuperview()
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.reserveView.frame = CGRect(x: 13, y: self.screenSize.height-270-dif, width: self.screenSize.width - 26, height: 270)
            self.view.addSubview(self.reserveView)
        }
    }
    @objc func removeReserveCard() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
                print("YESS")
            }
            self.spotView.frame = CGRect(x: 13, y: self.screenSize.height-318-dif, width: self.screenSize.width - 26, height: 318)
            self.view.addSubview(self.spotView)
            self.reserveView.removeFromSuperview()
        }
    }
    //Pay Card
    @objc func addPayCard() {
        reserveView.removeFromSuperview()
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.payView.frame = CGRect(x: 13, y: self.screenSize.height-270-dif, width: self.screenSize.width - 26, height: 270)
            self.view.addSubview(self.payView)
        }
    }
    @objc func removePayCard() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
                print("YESS")
            }
            self.reserveView.frame = CGRect(x: 13, y: self.screenSize.height-270-dif, width: self.screenSize.width - 26, height: 270)
            self.view.addSubview(self.reserveView)
            self.payView.removeFromSuperview()
        }
    }
    //Reservation Card
    @objc func addReservationCard() {
        activeBar.removeFromSuperview()
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.reservationView.frame = CGRect(x: 13, y: self.screenSize.height-190-dif, width: self.screenSize.width - 26, height: 190)
            self.view.addSubview(self.reservationView)
        }
    }
    @objc func removeReservationCard() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
                print("YESS")
            }
            self.activeBar.frame = CGRect(x: 13, y: self.screenSize.height-52-dif, width: self.screenSize.width - 26, height: 52)
            self.view.addSubview(self.activeBar)
            self.reservationView.removeFromSuperview()
        }
    }
    //Delay Card
    @objc func addDelayCard() {
        reservationView.removeFromSuperview()
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.delayView.frame = CGRect(x: 13, y: self.screenSize.height-205-dif, width: self.screenSize.width - 26, height: 205)
            self.view.addSubview(self.delayView)
        }
    }
    @objc func removeDelayCard() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
                print("YESS")
            }
            self.reservationView.frame = CGRect(x: 13, y: self.screenSize.height-190-dif, width: self.screenSize.width - 26, height: 190)
            self.view.addSubview(self.reservationView)
            self.delayView.removeFromSuperview()
        }
    }
    //Pay Delay Card
    @objc func addPayDelayCard() {
        delayView.removeFromSuperview()
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.payView.frame = CGRect(x: 13, y: self.screenSize.height-270-dif, width: self.screenSize.width - 26, height: 270)
            self.view.addSubview(self.payView)
        }
    }
    @objc func removePayDelayCard() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
                print("YESS")
            }
            self.delayView.frame = CGRect(x: 13, y: self.screenSize.height-205-dif, width: self.screenSize.width - 26, height: 205)
            self.view.addSubview(self.delayView)
            self.payView.removeFromSuperview()
        }
    }
    
    //MARK: -Bar functions-
    
    @objc func showPaidBar() {
        payView.removeFromSuperview()
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.paidBar.frame = CGRect(x: 13, y: self.screenSize.height-52-dif, width: self.screenSize.width - 26, height: 52)
            self.view.addSubview(self.paidBar)
        }
    }
    
    @objc func showActiveBar() {
        paidBar.removeFromSuperview()
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.activeBar.frame = CGRect(x: 13, y: self.screenSize.height-52-dif, width: self.screenSize.width - 26, height: 52)
            self.view.addSubview(self.activeBar)
        }
    }
    
    @objc func showUnlockedBar() {
        reservationView.removeFromSuperview()
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.unlockedBar.frame = CGRect(x: 13, y: self.screenSize.height-52-dif, width: self.screenSize.width - 26, height: 52)
            self.view.addSubview(self.unlockedBar)
        }
    }
    
    @objc func showCancelledBar() {
        reservationView.removeFromSuperview()
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.cancelledBar.frame = CGRect(x: 13, y: self.screenSize.height-52-dif, width: self.screenSize.width - 26, height: 52)
            self.view.addSubview(self.cancelledBar)
        }
    }
    
    @objc func showNoWifiBar() {
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.titleLbl && self.view.subviews.last != self.mapView {
            self.view.subviews.last!.removeFromSuperview()
        } else {
            self.searchBar.layer.shadowOpacity = 0.0
        }
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.noWifiBar.frame = CGRect(x: 13, y: self.screenSize.height-52-dif, width: self.screenSize.width - 26, height: 52)
            self.view.addSubview(self.noWifiBar)
        }
    }
    
    //MARK: -Return to Search Bar-
    @objc func returnToSearchBar() {
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.titleLbl && self.view.subviews.last != self.mapView {
            self.view.subviews.last!.removeFromSuperview()
        }
        self.searchBar.layer.shadowOpacity = 0.1
    }
    
    @objc func removeNoWifiBar() {
        if self.view.subviews.last == noWifiBar {
            self.view.subviews.last!.removeFromSuperview()
            self.searchBar.layer.shadowOpacity = 0.1
        }
    }
    
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addResultCard), name: Notification.Name(addResultCardID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeResultCard), name: Notification.Name(removeResultCardID), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(addSectionCard), name: Notification.Name(addSectionCardID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeSectionCard), name: Notification.Name(removeSectionCardID), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(addSpotCard), name: Notification.Name(addSpotCardID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeSpotCard), name: Notification.Name(removeSpotCardID), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(addReserveCard), name: Notification.Name(addReserveCardID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeReserveCard), name: Notification.Name(removeReserveCardID), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(addPayCard), name: Notification.Name(addPayCardID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removePayCard), name: Notification.Name(removePayCardID), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(addReservationCard), name: Notification.Name(addReservationCardID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeReservationCard), name: Notification.Name(removeReservationCardID), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(addDelayCard), name: Notification.Name(addDelayCardID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeDelayCard), name: Notification.Name(removeDelayCardID), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(addPayDelayCard), name: Notification.Name(addPayDelayCardID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removePayDelayCard), name: Notification.Name(removePayDelayCardID), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPaidBar), name: Notification.Name(showPaidBarID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showActiveBar), name: Notification.Name(showActiveBarID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showUnlockedBar), name: Notification.Name(showUnlockedBarID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showCancelledBar), name: Notification.Name(showCancelledBarID), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showNoWifiBar), name: Notification.Name(showNoWifiBarID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeNoWifiBar), name: Notification.Name(removeNoWifiBarID), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(returnToSearchBar), name: Notification.Name(returnToSearchBarID), object: nil)
    }
    
    func addMarkers() {
        var index = 0
        for parkName in parkNames {
            let markerPosition = CLLocationCoordinate2D(latitude: parkLatitudes[index], longitude: parkLongitudes[index])
            index += 1
            let marker = GMSMarker(position: markerPosition)
            marker.title = parkName
            marker.infoWindowAnchor = CGPoint()
            marker.icon = UIImage(named: "Marker")?.withResize(scaledToSize: CGSize(width: 36.0, height: 49.0))
            marker.map = mapView
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObs()
        
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
        mapView.delegate = self
        self.view.insertSubview(mapView, at: 0)
        
        addMarkers()
        
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
extension HomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if self.view.subviews.last != paidBar && self.view.subviews.last != activeBar && self.view.subviews.last != unlockedBar && self.view.subviews.last != reservationView && self.view.subviews.last != noWifiBar {
            selectedLocation = marker.title!
            selectedLocationColor = UIColor(named: "Dark Orange")!
            if self.view.subviews.last != searchBar && self.view.subviews.last != titleLbl && self.view.subviews.last != mapView {
                self.view.subviews.last?.removeFromSuperview()
            }
            addResultCard()
        }
        return true
    }
}
