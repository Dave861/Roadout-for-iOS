//
//  HomeViewController.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit
import GoogleMaps
import CoreLocation
import SwiftUI

var selectedLocation = "Location"
var selectedLocationColor = UIColor(named: "Main Yellow")
var selectedLocationCoord: CLLocationCoordinate2D!
var currentLocationCoord: CLLocationCoordinate2D?

var returnToDelay = false
var returnToFind = false

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
    
    //MARK: -Express Reserve-
    let expressPickView = ExpressPickView.instanceFromNib()
    let expressView = ExpressView.instanceFromNib()
    
    let addExpressViewID = "ro.roadout.Roadout.addExpressViewID"
    let removeExpressViewID = "ro.roadout.Roadout.removeExpressViewID"
    
    let showFindCardID = "ro.roadout.Roadout.showFindCardID"
    
    @objc func addExpressView() {
        let camera = GMSCameraPosition.camera(withLatitude: (selectedLocationCoord!.latitude), longitude: (selectedLocationCoord!.longitude), zoom: 17.0)
        self.mapView?.animate(to: camera)
        expressPickView.removeFromSuperview()
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.expressView.frame = CGRect(x: 13, y: self.screenSize.height-334-dif, width: self.screenSize.width - 26, height: 334)
            self.view.addSubview(self.expressView)
        }
    }
    
    @objc func removeExpressView() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
                print("YESS")
            }
            self.expressPickView.frame = CGRect(x: 13, y: self.screenSize.height-195-dif, width: self.screenSize.width - 26, height: 195)
            self.view.addSubview(self.expressPickView)
            self.expressView.removeFromSuperview()
        }
    }
    
    //MARK: -Find me a spot-
    let findView = FindView.instanceFromNib()
    
    
    //MARK: -IBOutlets-
    
    @IBOutlet weak var searchBar: UIView!
    
    @IBAction func searchTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func settingsTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "What would you like to do?", preferredStyle: .actionSheet)
        let settingsAction = UIAlertAction(title: "Preferences", style: .default) { action in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        settingsAction.setValue(UIColor(named: "Icons")!, forKey: "titleTextColor")
        
        let findAction = UIAlertAction(title: "Find Spot", style: .default) { action in
            self.searchBar.layer.shadowOpacity = 0.0
            var dif = 15.0
            DispatchQueue.main.async {
                if (UIDevice.current.hasNotch) {
                    dif = 49.0
                    print("YESS")
                }
                self.findView.frame = CGRect(x: 13, y: self.screenSize.height-255-dif, width: self.screenSize.width - 26, height: 255)
                print(self.view.frame.height)
                self.view.addSubview(self.findView)
            }
        }
        findAction.setValue(UIColor(named: "Brownish")!, forKey: "titleTextColor")
        
        let expressAction = UIAlertAction(title: "Express Reserve", style: .default) { action in
            self.searchBar.layer.shadowOpacity = 0.0
            var dif = 15.0
            DispatchQueue.main.async {
                if (UIDevice.current.hasNotch) {
                    dif = 49.0
                    print("YESS")
                }
                self.expressPickView.frame = CGRect(x: 13, y: self.screenSize.height-195-dif, width: self.screenSize.width - 26, height: 195)
                print(self.view.frame.height)
                self.view.addSubview(self.expressPickView)
            }
        }
        expressAction.setValue(UIColor(named: "Dark Orange")!, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor(named: "Greyish")!, forKey: "titleTextColor")
        
        alert.addAction(settingsAction)
        alert.addAction(findAction)
        alert.addAction(expressAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var searchTapArea: UIButton!
    @IBOutlet weak var settingsTapArea: UIButton!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var shareplayView: UIView!
    
    
    
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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(addExpressView), name: Notification.Name(addExpressViewID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeExpressView), name: Notification.Name(removeExpressViewID), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPaidBar), name: Notification.Name(showPaidBarID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showActiveBar), name: Notification.Name(showActiveBarID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showUnlockedBar), name: Notification.Name(showUnlockedBarID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showCancelledBar), name: Notification.Name(showCancelledBarID), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showNoWifiBar), name: Notification.Name(showNoWifiBarID), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeNoWifiBar), name: Notification.Name(removeNoWifiBarID), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(returnToSearchBar), name: Notification.Name(returnToSearchBarID), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showFindCard), name: Notification.Name(showFindCardID), object: nil)
        
        if #available(iOS 15.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(showGroupReserveVC), name: Notification.Name("ro.roadout.Roadout.groupSessionStarted"), object: nil)
        }
    }
    
    func addMarkers() {
        var index = 0
        for parkLocation in parkLocations {
            let markerPosition = CLLocationCoordinate2D(latitude: parkLocation.latitude, longitude: parkLocation.longitude)
            index += 1
            let marker = GMSMarker(position: markerPosition)
            marker.title = parkLocation.name
            marker.infoWindowAnchor = CGPoint()
            marker.icon = UIImage(named: "Marker")?.withResize(scaledToSize: CGSize(width: 36.0, height: 49.0))
            marker.map = mapView
            
        }
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Preferences", image: UIImage(systemName: "gearshape.2"), handler: { (_) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            UIAction(title: "Find Spot", image: UIImage(systemName: "loupe"), handler: { (_) in
                self.searchBar.layer.shadowOpacity = 0.0
                var dif = 15.0
                DispatchQueue.main.async {
                    if (UIDevice.current.hasNotch) {
                        dif = 49.0
                        print("YESS")
                    }
                    self.findView.frame = CGRect(x: 13, y: self.screenSize.height-255-dif, width: self.screenSize.width - 26, height: 255)
                    print(self.view.frame.height)
                    self.view.addSubview(self.findView)
                }
            }),
            UIAction(title: "Express Reserve", image: UIImage(systemName: "flag.2.crossed"), handler: { (_) in
                self.searchBar.layer.shadowOpacity = 0.0
                var dif = 15.0
                DispatchQueue.main.async {
                    if (UIDevice.current.hasNotch) {
                        dif = 49.0
                        print("YESS")
                    }
                    self.expressPickView.frame = CGRect(x: 13, y: self.screenSize.height-195-dif, width: self.screenSize.width - 26, height: 195)
                    print(self.view.frame.height)
                    self.view.addSubview(self.expressPickView)
                }
            }),
        ]
    }
    var moreMenu: UIMenu {
        return UIMenu(title: "What would you like to do?", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    func addSharePlayButtonView() {
        if #available(iOS 15.0, *) {
            let host = UIHostingController(rootView: SharePlayButton())
            guard let hostView = host.view else { return }
            hostView.translatesAutoresizingMaskIntoConstraints = false
            self.shareplayView.addSubview(hostView)
            NSLayoutConstraint.activate([
                hostView.centerXAnchor.constraint(equalTo: self.shareplayView.centerXAnchor),
                hostView.centerYAnchor.constraint(equalTo: self.shareplayView.centerYAnchor),
                
                hostView.widthAnchor.constraint(equalTo: self.shareplayView.widthAnchor),
                hostView.heightAnchor.constraint(equalTo: self.shareplayView.heightAnchor),
                
                hostView.bottomAnchor.constraint(equalTo: self.shareplayView.bottomAnchor),
                hostView.topAnchor.constraint(equalTo: self.shareplayView.topAnchor),
                hostView.leftAnchor.constraint(equalTo: self.shareplayView.leftAnchor),
                hostView.rightAnchor.constraint(equalTo: self.shareplayView.rightAnchor)
            ])
        }
    }
    
    @available(iOS 15.0, *)
    @objc func showGroupReserveVC() {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupReserveVC") as! GroupReserveViewController
            self.present(vc, animated: true, completion: nil)
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
        
        if #available(iOS 14.0, *) {
            settingsTapArea.menu = moreMenu
            settingsTapArea.showsMenuAsPrimaryAction = true
        }
        
        if #available(iOS 15.0, *) {
            addSharePlayButtonView()
            SharePlayManager.sharedInstance.receiveSessions()
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
        if self.view.subviews.last == payView {
            let payV = payView as! PayView
            payV.reloadMainCard()
        }
    }
    
    
    //MARK: - Card Functions-
    //Result Card
    @objc func addResultCard() {
        let camera = GMSCameraPosition.camera(withLatitude: (selectedLocationCoord!.latitude), longitude: (selectedLocationCoord!.longitude), zoom: 17.0)
        self.mapView?.animate(to: camera)
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
            self.paidBar.frame = CGRect(x: 13, y: self.screenSize.height-52-dif, width: self.screenSize.width - 26, height: 52)
            self.view.addSubview(self.paidBar)
        }
    }
    
    @objc func showActiveBar() {
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
            self.activeBar.frame = CGRect(x: 13, y: self.screenSize.height-52-dif, width: self.screenSize.width - 26, height: 52)
            self.view.addSubview(self.activeBar)
        }
    }
    
    @objc func showUnlockedBar() {
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
            self.unlockedBar.frame = CGRect(x: 13, y: self.screenSize.height-52-dif, width: self.screenSize.width - 26, height: 52)
            self.view.addSubview(self.unlockedBar)
        }
    }
    
    @objc func showCancelledBar() {
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
    
    @objc func showFindCard() {
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.titleLbl && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.layer.shadowOpacity = 0.0
            }
            var dif = 15.0
            DispatchQueue.main.async {
                if (UIDevice.current.hasNotch) {
                    dif = 49.0
                    print("YESS")
                }
                self.findView.frame = CGRect(x: 13, y: self.screenSize.height-255-dif, width: self.screenSize.width - 26, height: 255)
                print(self.view.frame.height)
                self.view.addSubview(self.findView)
        }
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
        currentLocationCoord = location?.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.mapView?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
}

extension HomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if self.view.subviews.last != paidBar && self.view.subviews.last != activeBar && self.view.subviews.last != unlockedBar && self.view.subviews.last != reservationView && self.view.subviews.last != noWifiBar {
            selectedLocation = marker.title!
            selectedLocationColor = UIColor(named: "Dark Orange")!
            selectedLocationCoord = marker.position
            if self.view.subviews.last != searchBar && self.view.subviews.last != titleLbl && self.view.subviews.last != mapView {
                self.view.subviews.last?.removeFromSuperview()
            }
            addResultCard()
        }
        return true
    }
}