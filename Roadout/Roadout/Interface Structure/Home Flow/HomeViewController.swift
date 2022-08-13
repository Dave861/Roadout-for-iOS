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
import SPIndicator
import GeohashKit

class HomeViewController: UIViewController {

    var mapView: GMSMapView!
    var centerMapCoordinate: CLLocationCoordinate2D!
    let locationManager = CLLocationManager()
    let screenSize: CGRect = UIScreen.main.bounds
    var selectedMarker: GMSMarker!
    var markers = [GMSMarker]()
    var spotMarker: GMSMarker!
    
    //Card Views
    let resultView = ResultView.instanceFromNib()
    let sectionView = SectionView.instanceFromNib()
    let spotView = SpotView.instanceFromNib()
    let reserveView = ReserveView.instanceFromNib()
    let payView = PayView.instanceFromNib()
    let reservationView = ReservationView.instanceFromNib()
    let delayView = DelayView.instanceFromNib()
    let unlockView = UnlockView.instanceFromNib()
    let unlockedView = UnlockedView.instanceFromNib()
    let payDurationView = DurationView.instanceFromNib()
    let payParkingView = PayParkingView.instanceFromNib()
    
    let paidBar = PaidView.instanceFromNib()
    let activeBar = ActiveView.instanceFromNib()
    let cancelledBar = CancelledView.instanceFromNib()
    let noWifiBar = NoWifiView.instanceFromNib()
    let paidParkingBar = PaidParkingBar.instanceFromNib()
    
    //MARK: -Express Reserve-
    let expressView = ExpressView.instanceFromNib()
    
    @objc func addExpressView() {
        let camera = GMSCameraPosition.camera(withLatitude: (selectedLocationCoord!.latitude), longitude: (selectedLocationCoord!.longitude), zoom: 17.0)
        self.mapView?.animate(to: camera)
        
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
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
    
    
    //MARK: -Find me a spot-
    let findView = FindView.instanceFromNib()
        
    @objc func showFindCard() {
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
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
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var searchBar: UIView!
    
    @IBAction func searchTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        guard let coord = self.mapView.myLocation?.coordinate else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
            self.present(vc, animated: false, completion: nil)
            return
        }
        currentLocationCoord = coord
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
        self.present(vc, animated: false, completion: nil)
    }
    @IBAction func settingsTapped(_ sender: Any) {
        //Handled by menu
    }
    
    @IBOutlet weak var searchTapArea: UIButton!
    
    @IBOutlet weak var settingsTapArea: UIButton!
    
    @IBOutlet weak var shareplayView: UIView!
    
    
    @IBOutlet weak var mapControlsView: UIView!
    
    @IBOutlet weak var mapTypeButton: UIButton!
    
    @IBOutlet weak var userLocationButton: UIButton!
    
    @IBAction func mapTypeTapped(_ sender: Any) {
        if selectedMapType == MapType.roadout {
            mapTypeButton.setImage(UIImage(systemName: "globe.europe.africa.fill"), for: .normal)
            mapTypeButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 14), forImageIn: .normal)
            
            satelliteFilter.alpha = 1.0
            mapView.mapType = .satellite
            self.addShadowToTitle()
            titleLbl.textColor = .white
            
            selectedMapType = .satellite
        } else {
            mapTypeButton.setImage(UIImage(systemName: "map.fill"), for: .normal)
            mapTypeButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 13), forImageIn: .normal)
            
            satelliteFilter.alpha = 0
            mapView.mapType = .normal
            self.removeShadowFromTitle()
            titleLbl.textColor = .label
            
            selectedMapType = .roadout
        }
    }
    
    @IBAction func userLocationTapped(_ sender: Any) {
        guard let coord = self.mapView.myLocation?.coordinate else { return }
        let camera = GMSCameraPosition.camera(withLatitude: coord.latitude, longitude: coord.longitude, zoom: 15.0)
        mapView.animate(to: camera)
        
        userLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
    }
    
    @IBOutlet weak var satelliteFilter: UIView!
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(addPayDurationCard), name: .addPayDurationCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removePayDurationCard), name: .removePayDurationCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addPayParkingCard), name: .addPayParkingCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removePayParkingCard), name: .removePayParkingCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addExpressView), name: .addExpressViewID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPaidBar), name: .showPaidBarID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showActiveBar), name: .showActiveBarID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showUnlockedView), name: .showUnlockedViewID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showCancelledBar), name: .showCancelledBarID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showNoWifiBar), name: .showNoWifiBarID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeNoWifiBar), name: .removeNoWifiBarID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPaidParkingBar), name: .showPaidParkingBarID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(returnToSearchBar), name: .returnToSearchBarID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showFindCard), name: .showFindCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateCameraToFoundLocation), name: .animateCameraToFoundID, object: nil)
                
        if #available(iOS 15.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(showGroupReserveVC), name: .groupSessionStartedID, object: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(showRateReservation), name: .showRateReservationID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocation), name: .updateLocationID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addMarkers), name: .addMarkersID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addSpotMarker), name: .addSpotMarkerID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeSpotMarker), name: .removeSpotMarkerID, object: nil)
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
    
    @objc func addSpotMarker() {
        if spotMarker != nil {
            spotMarker.map = nil
        }
        let hashComponents = selectedSpotHash.components(separatedBy: "-") //[hash, fNR, hNR, pNR]
        let markerPosition = CLLocationCoordinate2D(latitude: Geohash(geohash: hashComponents[0])!.coordinates.latitude, longitude: Geohash(geohash: hashComponents[0])!.coordinates.longitude)
        //"SpotMarker_" + parkLocations[selectedParkLocationIndex].accentColor
        spotMarker = GMSMarker(position: markerPosition)
        spotMarker.title = "Selected Spot Marker"
        spotMarker.infoWindowAnchor = CGPoint()
        
        spotMarker.icon = UIImage(named: "SpotMarker_" + selectedSpotColor)?.withResize(scaledToSize: CGSize(width: 35.0, height: 45.15))
        spotMarker.map = mapView
    }
    
    @objc func removeSpotMarker() {
        if spotMarker != nil {
            spotMarker.map = nil
        }
    }
    
    //Menu
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Settings".localized(), image: UIImage(systemName: "gearshape.2"), handler: { (_) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            UIAction(title: "Pay Parking".localized(), image: UIImage(systemName: "dollarsign.circle"), handler: { (_) in
                guard let coord = self.mapView.myLocation?.coordinate else {
                    
                    let alert = UIAlertController(title: "Error", message: "Roadout can't access your location to show nearby spots, please enable it in Settings.", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                    alert.addAction(cancelAction)
                    alert.view.tintColor = UIColor(named: "Cash Yellow")!
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                currentLocationCoord = coord
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectPayVC") as! SelectPayViewController
                self.present(vc, animated: true, completion: nil)
            }),
            UIAction(title: "Express Lane".localized(), image: UIImage(systemName: "flag.2.crossed"), handler: { (_) in
                guard let coord = self.mapView.myLocation?.coordinate else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExpressPickVC") as! ExpressPickViewController
                    self.present(vc, animated: true, completion: nil)
                    return
                }
                currentLocationCoord = coord
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExpressPickVC") as! ExpressPickViewController
                self.present(vc, animated: true, completion: nil)
            }),
            UIAction(title: "Find Way".localized(), image: UIImage(systemName: "binoculars"), handler: { (_) in
                DispatchQueue.main.async {
                    let indicatorIcon = UIImage.init(systemName: "binoculars")!.withTintColor(UIColor(named: "Greyish")!, renderingMode: .alwaysOriginal)
                    let indicatorView = SPIndicatorView(title: "Finding...".localized(), message: "Please wait".localized(), preset: .custom(indicatorIcon))
                    indicatorView.dismissByDrag = false
                    indicatorView.backgroundColor = UIColor(named: "Background")!
                    indicatorView.present(duration: 1.0, haptic: .none, completion: nil)
                }
                FunctionsManager.sharedInstance.foundSpot = nil
                guard let coord = self.mapView.myLocation?.coordinate else {
                    self.showFindLocationAlert()
                    return
                }
                FunctionsManager.sharedInstance.sortLocations(currentLocation: coord) { success in
                    if success {
                        FunctionsManager.sharedInstance.findSpot { success in
                            if success {
                                if FunctionsManager.sharedInstance.foundSpot != nil {
                                    DispatchQueue.main.async {
                                        self.showFindCard()
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.showFindLocationAlert()
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showFindLocationAlert()
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showFindLocationAlert()
                        }
                    }
                }
            })
        ]
    }
    var moreMenu: UIMenu {
        return UIMenu(title: "What would you like to do?".localized(), image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    func showFindLocationAlert() {
        let alert = UIAlertController(title: "Error".localized(), message: "There was an error, location may not be enabled for Roadout or there aren't any free spots. Please enable it in Settings if you want to use Find Spot".localized(), preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.view.tintColor = UIColor(named: "DevBrown")
        self.present(alert, animated: true, completion: nil)
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
    
    //MARK: -View Configuration-
        
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    
        if self.view.subviews.last == payView {
            let payV = payView as! PayView
            payV.reloadMainCard()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if parkLocations.count < 10 {
            self.manageGettingData()
        } else if parkLocations.count == 10 {
            self.addMarkers()
        }
        
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        AuthManager.sharedInstance.checkIfUserExists(with: id) { result in
            switch result {
                case .success():
                    print("User exists.")
                case .failure(let err):
                    print(err)
                    self.userNotFoundAbort()
            }
        }
        
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.shownTip1") == false {
            settingsTapArea.tooltip(TutorialView1.instanceFromNib(), orientation: Tooltip.Orientation.top, configuration: { configuration in
                
                configuration.backgroundColor = UIColor(named: "Card Background")!
                configuration.shadowConfiguration.shadowOpacity = 0.1
                configuration.shadowConfiguration.shadowColor = UIColor.black.cgColor
                configuration.shadowConfiguration.shadowOffset = .zero
                
                return configuration
            })
            UserDefaults.roadout!.set(true, forKey: "ro.roadout.Roadout.shownTip1")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageObs()
            
        //Search Bar
        searchTapArea.setTitle("", for: .normal)
        settingsTapArea.setTitle("", for: .normal)
        
        searchBar.layer.cornerRadius = 17.0
        
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOpacity = 0.1
        searchBar.layer.shadowOffset = .zero
        searchBar.layer.shadowRadius = 17
        searchBar.layer.shadowPath = UIBezierPath(rect: searchBar.bounds).cgPath
        searchBar.layer.shouldRasterize = true
        searchBar.layer.rasterizationScale = UIScreen.main.scale
        
        settingsTapArea.menu = moreMenu
        settingsTapArea.showsMenuAsPrimaryAction = true
        
        //Map Controls
        mapControlsView.layer.cornerRadius = 9.0
        
        mapControlsView.layer.shadowColor = UIColor.black.cgColor
        mapControlsView.layer.shadowOpacity = 0.1
        mapControlsView.layer.shadowOffset = .zero
        mapControlsView.layer.shadowRadius = 9.0
        mapControlsView.layer.shadowPath = UIBezierPath(rect: mapControlsView.bounds).cgPath
        mapControlsView.layer.shouldRasterize = true
        mapControlsView.layer.rasterizationScale = UIScreen.main.scale
        
        mapTypeButton.setTitle("", for: .normal)
        userLocationButton.setTitle("", for: .normal)
        
        let camera = GMSCameraPosition.camera(withLatitude: 46.7712, longitude: 23.6236, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.delegate = self
        self.view.insertSubview(mapView, at: 0)
        let mapInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 65.0, right: 0.0)
        mapView.padding = mapInsets
        
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                self.applyStyleToMap(style: "lightStyle")
            case .dark:
                self.applyStyleToMap(style: "darkStyle")
            @unknown default:
                break
        }
        
        locationManager.delegate = self
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
        }
        
        //RE-ADD THIS WHEN GROUP RESERVE IS DONE
        /*
         setUpSharePlay()
         */
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
    
    func addShadowToTitle() {
        titleLbl.layer.shadowColor = UIColor.black.cgColor
        titleLbl.layer.shadowOpacity = 0.1
        titleLbl.layer.shadowOffset = .zero
        titleLbl.layer.shadowPath = UIBezierPath(rect: titleLbl.bounds).cgPath
        titleLbl.layer.shouldRasterize = true
        titleLbl.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func removeShadowFromTitle() {
        titleLbl.layer.shadowOpacity = 0
    }
    
    //MARK: -Data & Map Configuration-
    
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
    }
    
    @objc func showRateReservation() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RateVC") as! RateViewController
        self.present(vc, animated: true, completion: nil)
    }
  
    func setUpSharePlay() {
        if #available(iOS 15.0, *) {
            addSharePlayButtonView()
            SharePlayManager.sharedInstance.receiveSessions()
        }
    }
    
}
extension HomeViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
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
        animation.values = [ 0, -15 * .pi / 180.0, 15 * .pi / 180.0 , 0]
        animation.keyTimes = [0, 0.33 , 0.66 , 1]
        animation.duration = 0.6
        animation.isAdditive = false
        animation.isRemovedOnCompletion = true
        animation.repeatCount = 1
        
        marker.iconView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        //100, 90
        let imageView = UIImageView(frame: CGRect(x: (marker.iconView?.frame.width)!/2 - 14.625, y: (marker.iconView?.frame.height)! - 37.5, width: 29.52, height: 37.5))
        //29.25 75 58.5 75
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "SelectedMarker_" + marker.snippet!)
        imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        imageView.layer.frame = CGRect(x: (marker.iconView?.frame.width)!/2 - 14.625, y: (marker.iconView?.frame.height)! - 37.5, width: 29.52, height: 37.5)
        
        marker.iconView?.addSubview(imageView)
        marker.iconView!.subviews[0].layer.add(animation, forKey: "shakeAnimation")
        UIView.animate(withDuration: 0.3) {
            marker.iconView?.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }
        
    }
    
}

extension HomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if self.view.subviews.last != paidBar && self.view.subviews.last != activeBar && self.view.subviews.last != unlockedView && self.view.subviews.last != reservationView && self.view.subviews.last != noWifiBar {
            selectedLocationName = marker.title!
            let colorSnippet = marker.snippet!
            selectedLocationColor = UIColor(named: colorSnippet)!
            selectedLocationCoord = marker.position
            if self.view.subviews.last != searchBar && self.view.subviews.last != mapView {
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
        
        if mapView.isMyLocationEnabled {
            if centerMapCoordinate.latitude.rounded(toPlaces: 4) != mapView.myLocation?.coordinate.latitude.rounded(toPlaces: 4) || centerMapCoordinate.longitude.rounded(toPlaces: 4) != mapView.myLocation?.coordinate.longitude.rounded(toPlaces: 4) {
                
                userLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
            } else {
                userLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
            }
        }
    }
    
}

extension HomeViewController {
    
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
        
        guard let coord = self.mapView.myLocation?.coordinate else {
            var dif = 15.0
            DispatchQueue.main.async {
                if (UIDevice.current.hasNotch) {
                    dif = 49.0
                }
                self.resultView.frame = CGRect(x: 13, y: self.screenSize.height-142-dif, width: self.screenSize.width - 26, height: 142)
                self.view.addSubview(self.resultView)
            }
            return
        }
        currentLocationCoord = coord
        
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.resultView.frame = CGRect(x: 13, y: self.screenSize.height-142-dif, width: self.screenSize.width - 26, height: 142)
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
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
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
            self.resultView.frame = CGRect(x: 13, y: self.screenSize.height-142-dif, width: self.screenSize.width - 26, height: 142)
            self.view.addSubview(self.resultView)
            self.sectionView.removeFromSuperview()
        }
    }
    //Spot Card
    @objc func addSpotCard() {
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
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
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
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
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
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
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
            self.view.subviews.last!.removeFromSuperview()
        } else {
            self.searchBar.layer.shadowOpacity = 0.0
        }
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.reservationView.frame = CGRect(x: 13, y: self.screenSize.height-292-dif, width: self.screenSize.width - 26, height: 292)
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
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
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
            self.reservationView.frame = CGRect(x: 13, y: self.screenSize.height-292-dif, width: self.screenSize.width - 26, height: 292)
            self.view.addSubview(self.reservationView)
            self.delayView.removeFromSuperview()
        }
    }
    //Pay Delay Card
    @objc func addPayDelayCard() {
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
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
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
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
            self.reservationView.frame = CGRect(x: 13, y: self.screenSize.height-292-dif, width: self.screenSize.width - 26, height: 292)
            self.view.addSubview(self.reservationView)
            self.unlockView.removeFromSuperview()
        }
    }
    
    @objc func showUnlockedView() {
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
            self.view.subviews.last!.removeFromSuperview()
        } else {
            self.searchBar.layer.shadowOpacity = 0.0
        }
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.unlockedView.frame = CGRect(x: 13, y: self.screenSize.height-155-dif, width: self.screenSize.width - 26, height: 155)
            self.view.addSubview(self.unlockedView)
        }
    }
    
    @objc func addPayDurationCard() {
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
            self.view.subviews.last!.removeFromSuperview()
        } else {
            self.searchBar.layer.shadowOpacity = 0.0
        }
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.payDurationView.frame = CGRect(x: 13, y: self.screenSize.height-206-dif, width: self.screenSize.width - 26, height: 206)
            self.view.addSubview(self.payDurationView)
        }
    }
    @objc func removePayDurationCard() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.unlockedView.frame = CGRect(x: 13, y: self.screenSize.height-155-dif, width: self.screenSize.width - 26, height: 155)
            self.view.addSubview(self.unlockedView)
            self.payDurationView.removeFromSuperview()
        }
    }
    
    @objc func addPayParkingCard() {
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
            self.view.subviews.last!.removeFromSuperview()
        } else {
            self.searchBar.layer.shadowOpacity = 0.0
        }
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.payParkingView.frame = CGRect(x: 13, y: self.screenSize.height-271-dif, width: self.screenSize.width - 26, height: 271)
            self.view.addSubview(self.payParkingView)
        }
    }
    @objc func removePayParkingCard() {
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.payDurationView.frame = CGRect(x: 13, y: self.screenSize.height-206-dif, width: self.screenSize.width - 26, height: 206)
            self.view.addSubview(self.payDurationView)
            self.payParkingView.removeFromSuperview()
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
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
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
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
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
    
    @objc func showCancelledBar() {
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
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
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
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
    
    @objc func showPaidParkingBar() {
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
            self.view.subviews.last!.removeFromSuperview()
        } else {
            self.searchBar.layer.shadowOpacity = 0.0
        }
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.paidParkingBar.frame = CGRect(x: 13, y: self.screenSize.height-52-dif, width: self.screenSize.width - 26, height: 52)
            self.view.addSubview(self.paidParkingBar)
        }
    }
    
    //MARK: -Return to Search Bar-
    @objc func returnToSearchBar() {
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
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
