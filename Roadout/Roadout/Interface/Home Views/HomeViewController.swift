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

var returnToDelay = false
var returnToFind = false

class HomeViewController: UIViewController {

    var mapView: GMSMapView!
    var centerMapCoordinate: CLLocationCoordinate2D!
    let locationManager = CLLocationManager()
    let screenSize: CGRect = UIScreen.main.bounds
    var selectedMarker: GMSMarker!
    var markers = [GMSMarker]()
    
    //Card Views
    let resultView = ResultView.instanceFromNib()
    let sectionView = SectionView.instanceFromNib()
    let spotView = SpotView.instanceFromNib()
    let reserveView = ReserveView.instanceFromNib()
    let payView = PayView.instanceFromNib()
    let reservationView = ReservationView.instanceFromNib()
    let delayView = DelayView.instanceFromNib()
    let unlockView = UnlockView.instanceFromNib()
    
    let paidBar = PaidView.instanceFromNib()
    let activeBar = ActiveView.instanceFromNib()
    let unlockedBar = UnlockedView.instanceFromNib()
    let cancelledBar = CancelledView.instanceFromNib()
    let noWifiBar = NoWifiView.instanceFromNib()
    
    //MARK: -Express Reserve-
    let expressPickView = ExpressPickView.instanceFromNib()
    let expressView = ExpressView.instanceFromNib()
    
    @objc func addExpressView() {
        let camera = GMSCameraPosition.camera(withLatitude: (selectedLocationCoord!.latitude), longitude: (selectedLocationCoord!.longitude), zoom: 17.0)
        self.mapView?.animate(to: camera)
        
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
            self.expressView.frame = CGRect(x: 13, y: self.screenSize.height-280-dif, width: self.screenSize.width - 26, height: 280)
            self.view.addSubview(self.expressView)
        }
    }
    
    @objc func addExpressPickView() {
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
            self.expressPickView.frame = CGRect(x: 13, y: self.screenSize.height-195-dif, width: self.screenSize.width - 26, height: 195)
            self.view.addSubview(self.expressPickView)
        }
    }
    
    //MARK: -Find me a spot-
    let findView = FindView.instanceFromNib()
    
    var findRequested = false
    
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
                }
                self.findView.frame = CGRect(x: 13, y: self.screenSize.height-310-dif, width: self.screenSize.width - 26, height: 310)
                print(self.view.frame.height)
                self.view.addSubview(self.findView)
        }
    }
    
    @objc func animateCameraToFoundLocation() {
        let camera = GMSCameraPosition.camera(withLatitude: (selectedLocationCoord!.latitude), longitude: (selectedLocationCoord!.longitude), zoom: 17.0)
        self.mapView?.animate(to: camera)
    }
    
    
    //MARK: -IBOutlets-
    
    @IBOutlet weak var searchBar: UIView!
    
    @IBAction func searchTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func settingsTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "What would you like to do?".localized(), preferredStyle: .actionSheet)
        let settingsAction = UIAlertAction(title: "Preferences".localized(), style: .default) { action in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        settingsAction.setValue(UIColor(named: "Icons")!, forKey: "titleTextColor")
        
        let findAction = UIAlertAction(title: "Find Spot".localized(), style: .default) { action in
            guard let coord = self.mapView.myLocation?.coordinate else {
                let alert = UIAlertController(title: "Error".localized(), message: "There was an error, location may not be enabled for Roadout. Please enable it in Settings if you want to use Find Spot".localized(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                alert.addAction(action)
                alert.view.tintColor = UIColor(named: "DevBrown")
                self.present(alert, animated: true, completion: nil)
                return
            }
            FunctionsManager.sharedInstance.findSpot(coord) { success in
                if success {
                    self.showFindCard()
                } else {
                    let alert = UIAlertController(title: "Error".localized(), message: "There was an error, location may not be enabled for Roadout or there aren't any free spots. Please enable it in Settings if you want to use Find Spot".localized(), preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(action)
                    alert.view.tintColor = UIColor(named: "DevBrown")
                    self.present(alert, animated: true, completion: nil)
                }
            }

        }
        findAction.setValue(UIColor(named: "Brownish")!, forKey: "titleTextColor")
        
        let expressAction = UIAlertAction(title: "Express Reserve".localized(), style: .default) { action in
            self.addExpressPickView()
        }
        expressAction.setValue(UIColor(named: "Dark Orange")!, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
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
    
    //MARK: -OBSERVERS-
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addResultCard), name: .addResultCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeResultCard), name: .removeResultCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addSectionCard), name: .addSectionCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeSectionCard), name: .removeSectionCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addSpotCard), name: .addSpotCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeSpotCard), name: .removeSpotCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addReserveCard), name: .addReserveCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeReserveCard), name: .removeReserveCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addPayCard), name: .addPayCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removePayCard), name: .removePayCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addReservationCard), name: .addReservationCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeReservationCard), name: .removeReservationCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addDelayCard), name: .addDelayCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeDelayCard), name: .removeDelayCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addUnlockCard), name: .addUnlockCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeUnlockCard), name: .removeUnlockCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addPayDelayCard), name: .addPayDelayCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removePayDelayCard), name: .removePayDelayCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addExpressView), name: .addExpressViewID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addExpressPickView), name: .addExpressPickViewID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPaidBar), name: .showPaidBarID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showActiveBar), name: .showActiveBarID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showUnlockedBar), name: .showUnlockedBarID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showCancelledBar), name: .showCancelledBarID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showNoWifiBar), name: .showNoWifiBarID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeNoWifiBar), name: .removeNoWifiBarID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(returnToSearchBar), name: .returnToSearchBarID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showFindCard), name: .showFindCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateCameraToFoundLocation), name: .animateCameraToFoundID, object: nil)
                
        if #available(iOS 15.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(showGroupReserveVC), name: .groupSessionStartedID, object: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocation), name: .updateLocationID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addMarkers), name: .addMarkersID, object: nil)
    }
   //MARK: -Markers-
    
    @objc func addMarkers() {
        mapView.clear()
        var index = 0
        for parkLocation in parkLocations {
            let markerPosition = CLLocationCoordinate2D(latitude: parkLocation.latitude, longitude: parkLocation.longitude)
            index += 1
            let marker = GMSMarker(position: markerPosition)
            marker.title = parkLocation.name
            marker.infoWindowAnchor = CGPoint()
            //Snippet used for marker color coordination
            marker.snippet = parkLocation.accentColor
            marker.icon = UIImage(named: "Marker_\(parkLocation.accentColor)")?.withResize(scaledToSize: CGSize(width: 20.0, height: 20.0))
            marker.map = mapView
            markers.append(marker)
            
        }
    }
    
    //Menu
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Preferences".localized(), image: UIImage(systemName: "gearshape.2"), handler: { (_) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            UIAction(title: "Find Spot".localized(), image: UIImage(systemName: "loupe"), handler: { (_) in
                guard let coord = self.mapView.myLocation?.coordinate else {
                    let alert = UIAlertController(title: "Error".localized(), message: "There was an error, location may not be enabled for Roadout. Please enable it in Settings if you want to use Find Spot".localized(), preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
                    alert.addAction(action)
                    alert.view.tintColor = UIColor(named: "DevBrown")
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                FunctionsManager.sharedInstance.findSpot(coord) { success in
                    if success {
                        self.showFindCard()
                    } else {
                        let alert = UIAlertController(title: "Error".localized(), message: "There was an error, location may not be enabled for Roadout or there aren't any free spots. Please enable it in Settings if you want to use Find Spot".localized(), preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(action)
                        alert.view.tintColor = UIColor(named: "DevBrown")
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }),
            UIAction(title: "Express Reserve".localized(), image: UIImage(systemName: "flag.2.crossed"), handler: { (_) in
                self.addExpressPickView()
            }),
        ]
    }
    var moreMenu: UIMenu {
        return UIMenu(title: "What would you like to do?".localized(), image: nil, identifier: nil, options: [], children: menuItems)
    }
  //SharePlay
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
    
    func manageTutorial() {
        if UserDefaults.roadout?.bool(forKey: "ro.roadout.Roadout.launchedBefore") == false {
        
            let alert = UIAlertController(title: "Tutorial".localized(), message: "Would you like a quick tutorial of the app?".localized(), preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes".localized(), style: .default) { action in
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "TutorialVC") as! TutorialViewController
                self.present(vc, animated: true, completion: nil)
            }
            let noAction = UIAlertAction(title: "No".localized(), style: .cancel, handler: nil)
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            alert.view.tintColor = UIColor(named: "Greyish")
            self.present(alert, animated: true) {
                UserDefaults.roadout?.set(true, forKey: "ro.roadout.Roadout.launchedBefore")
            }
        }
    }
    
    //MARK: -ViewDidLoad-
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        AuthManager.sharedInstance.checkIfUserExists(with: id) { result in
            switch result {
            case .success():
                print(id)
            case .failure(let err):
                print(err)
                self.userNotFoundAbort()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObs()
        
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        AuthManager.sharedInstance.checkIfUserExists(with: id) { result in
            switch result {
            case .success():
                print(id)
            case .failure(let err):
                print(err)
                self.userNotFoundAbort()
            }
        }
        
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
        let mapInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 65.0, right: 0.0)
        mapView.padding = mapInsets
        
        if parkLocations.count < 10 {
            self.manageGettingData()
        } else if parkLocations.count == 10 {
            self.addMarkers()
        }
        
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
        //RE-ADD THIS WHEN GROUP RESERVE IS DONE
        /*
        if #available(iOS 15.0, *) {
            addSharePlayButtonView()
            SharePlayManager.sharedInstance.receiveSessions()
        }*/
        manageTutorial()
        UserManager.sharedInstance.getUserName(id) { result in
            print(result)
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
                        print("Unable to find lightStyle.json")
                      }
                    } catch {
                        print("One or more of the map styles failed to load. \(error)")
                    }
                case .dark:
                    do {
                      if let styleURL = Bundle.main.url(forResource: "darkStyle", withExtension: "json") {
                        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                      } else {
                        print("Unable to find darkStyle.json")
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
    
    func manageGettingData() {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "GetDataVC") as! GetDataViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    func userNotFoundAbort() {
        UserDefaults.roadout!.set(false, forKey: "ro.roadout.Roadout.isUserSigned")
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
    
    @objc func updateLocation() {
        if #available(iOS 14.0, *) {
            if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
                if centerMapCoordinate == nil  {
                    locationManager.startUpdatingLocation()
                    mapView.isMyLocationEnabled = true
                } else {
                    let centerLocation = CLLocation(latitude: centerMapCoordinate.latitude, longitude: centerMapCoordinate.longitude)
                    let cityLocation = CLLocation(latitude: 46.775351, longitude: 23.608280)
                    if centerLocation.distance(from: cityLocation) >= 7000 {
                        locationManager.startUpdatingLocation()
                        mapView.isMyLocationEnabled = true
                    }
                }
            }
        } else {
            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                if centerMapCoordinate == nil  {
                    locationManager.startUpdatingLocation()
                    mapView.isMyLocationEnabled = true
                } else {
                    let centerLocation = CLLocation(latitude: centerMapCoordinate.latitude, longitude: centerMapCoordinate.longitude)
                    let cityLocation = CLLocation(latitude: 46.775351, longitude: 23.608280)
                    if centerLocation.distance(from: cityLocation) >= 7000 {
                        locationManager.startUpdatingLocation()
                        mapView.isMyLocationEnabled = true
                    }
                }
            }
        }
    }

    
    //MARK: - Card Functions-
    //Result Card
    @objc func addResultCard() {
        let camera = GMSCameraPosition.camera(withLatitude: (selectedLocationCoord!.latitude), longitude: (selectedLocationCoord!.longitude), zoom: 17.0)
        self.mapView?.animate(to: camera)
        
        var index = 0
        for location in parkLocations {
            if location.name == selectedLocationName {
                selectedParkLocationIndex = index
                break
            }
            index += 1
        }
        
        for marker in markers {
            if marker.position.latitude == selectedLocationCoord!.latitude && marker.position.longitude == selectedLocationCoord!.longitude {
                self.shakeMarkerView(marker: marker)
                self.selectedMarker = marker
            }
        }
    
        searchBar.layer.shadowOpacity = 0.0
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.resultView.frame = CGRect(x: 13, y: self.screenSize.height-115-dif, width: self.screenSize.width - 26, height: 115)
            self.view.addSubview(self.resultView)
        }
    }
    @objc func removeResultCard() {
        DispatchQueue.main.async {
            self.searchBar.layer.shadowOpacity = 0.1
            self.resultView.removeFromSuperview()
            if self.selectedMarker != nil {

                self.selectedMarker.iconView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(named: "Marker_" + self.selectedMarker.snippet!)?.withResize(scaledToSize: CGSize(width: 20.0, height: 20.0))
                self.selectedMarker.iconView?.addSubview(imageView)
                
            }
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
            self.reserveView.frame = CGRect(x: 13, y: self.screenSize.height-310-dif, width: self.screenSize.width - 26, height: 310)
            self.view.addSubview(self.reserveView)
        }
    }
    @objc func removeReserveCard() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
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
            self.payView.frame = CGRect(x: 13, y: self.screenSize.height-237-dif, width: self.screenSize.width - 26, height: 237)
            self.view.addSubview(self.payView)
        }
    }
    @objc func removePayCard() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.reserveView.frame = CGRect(x: 13, y: self.screenSize.height-310-dif, width: self.screenSize.width - 26, height: 310)
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
            self.reservationView.frame = CGRect(x: 13, y: self.screenSize.height-209-dif, width: self.screenSize.width - 26, height: 209)
            self.view.addSubview(self.reservationView)
        }
    }
    @objc func removeReservationCard() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
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
            }
            self.reservationView.frame = CGRect(x: 13, y: self.screenSize.height-209-dif, width: self.screenSize.width - 26, height: 209)
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
            self.payView.frame = CGRect(x: 13, y: self.screenSize.height-237-dif, width: self.screenSize.width - 26, height: 237)
            self.view.addSubview(self.payView)
        }
    }
    @objc func removePayDelayCard() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.delayView.frame = CGRect(x: 13, y: self.screenSize.height-205-dif, width: self.screenSize.width - 26, height: 205)
            self.view.addSubview(self.delayView)
            self.payView.removeFromSuperview()
        }
    }
    //Unlock Card
    @objc func addUnlockCard() {
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
            self.unlockView.frame = CGRect(x: 13, y: self.screenSize.height-221-dif, width: self.screenSize.width - 26, height: 221)
            self.view.addSubview(self.unlockView)
        }
    }
    @objc func removeUnlockCard() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.reservationView.frame = CGRect(x: 13, y: self.screenSize.height-209-dif, width: self.screenSize.width - 26, height: 209)
            self.view.addSubview(self.reservationView)
            self.unlockView.removeFromSuperview()
        }
    }
    
    //MARK: -Bar functions-
    
    @objc func showPaidBar() {
        if self.selectedMarker != nil {
            self.selectedMarker.iconView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "Marker_" + self.selectedMarker.snippet!)?.withResize(scaledToSize: CGSize(width: 20.0, height: 20.0))
            self.selectedMarker.iconView?.addSubview(imageView)
        }
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
    
    func shakeMarkerView(marker: GMSMarker) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.values = [ 0, -30 * .pi / 180.0, 30 * .pi / 180.0 , 0]
        animation.keyTimes = [0, 0.33 , 0.66 , 1]
        animation.duration = 1;
        animation.isAdditive = false;
        animation.isRemovedOnCompletion = true
        animation.repeatCount = 1
        
        marker.iconView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 90))
        let imageView = UIImageView(frame: CGRect(x: (marker.iconView?.frame.width)!/2 - 29.25, y: (marker.iconView?.frame.height)! - 75, width: 58.5, height: 75))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "SelectedMarker_" + marker.snippet!)
        imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        imageView.layer.frame = CGRect(x: (marker.iconView?.frame.width)!/2 - 29.25, y: (marker.iconView?.frame.height)! - 75, width: 58.5, height: 75)
        
        marker.iconView?.addSubview(imageView)
        marker.iconView!.subviews[0].layer.add(animation, forKey: "shakeAnimation")
    }
}

extension HomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if self.view.subviews.last != paidBar && self.view.subviews.last != activeBar && self.view.subviews.last != unlockedBar && self.view.subviews.last != reservationView && self.view.subviews.last != noWifiBar {
            selectedLocationName = marker.title!
            let colorSnippet = marker.snippet!
            selectedLocationColor = UIColor(named: colorSnippet)!
            selectedLocationCoord = marker.position
            if self.view.subviews.last != searchBar && self.view.subviews.last != titleLbl && self.view.subviews.last != mapView {
                self.view.subviews.last?.removeFromSuperview()
            }
            if self.selectedMarker != nil {
                self.selectedMarker.iconView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageView.contentMode = .scaleAspectFit
                imageView.image = UIImage(named: "Marker_" + self.selectedMarker.snippet!)?.withResize(scaledToSize: CGSize(width: 20.0, height: 20.0))
                self.selectedMarker.iconView?.addSubview(imageView)
            }
            self.selectedMarker = marker
            addResultCard()
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
   
}
