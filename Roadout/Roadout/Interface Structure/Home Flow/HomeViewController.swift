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
import GeohashKit

class HomeViewController: UIViewController {

    //Map Utilities
    var mapView: GMSMapView!
    var centerMapCoordinate: CLLocationCoordinate2D!
    let locationManager = CLLocationManager()
    let screenSize: CGRect = UIScreen.main.bounds
    var selectedMarker: GMSMarker!
    var markers = [GMSMarker]()
    var spotMarker: GMSMarker!
    var isMarkerInteractive = true
    
    //Card Views
    let toolsView = ParkingToolsView.instanceFromNib()
    let resultView = ResultView.instanceFromNib()
    let sectionView = SectionView.instanceFromNib()
    let spotView = SpotView.instanceFromNib()
    let timeView = TimeView.instanceFromNib()
    let payView = PayView.instanceFromNib()
    let reservationView = ReservationView.instanceFromNib()
    let delayView = DelayView.instanceFromNib()
    let unlockView = UnlockView.instanceFromNib()
    let unlockedView = UnlockedView.instanceFromNib()
    let payDurationView = DurationView.instanceFromNib()
    let payParkingView = PayParkingView.instanceFromNib()
    
    let paidBar = PaidView.instanceFromNib()
    let activeBar = ActiveView.instanceFromNib()
    let endedBar = EndedView.instanceFromNib()
    let cancelledBar = CancelledView.instanceFromNib()
    let noWifiBar = NoWifiView.instanceFromNib()
    let paidParkingBar = PaidParkingBar.instanceFromNib()
    
    //MARK: - Express Lane -
    
    let expressView = ExpressView.instanceFromNib()
    
    @objc func addExpressView() {
        let camera = GMSCameraPosition.camera(withLatitude: selectedLocation.latitude, longitude: selectedLocation.longitude, zoom: 16.0)
        self.mapView?.animate(to: camera)
        
        var index = 0
        for location in parkLocations {
            if location.name == selectedLocation.name {
                selectedParkLocationIndex = index
                break
            }
            index += 1
        }
        
        for marker in markers {
            if marker.position.latitude == selectedLocation.latitude && marker.position.longitude == selectedLocation.longitude {
                self.shakeMarkerView(marker: marker)
                self.selectedMarker = marker
            }
        }
        
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
            self.view.subviews.last!.removeFromSuperview()
        } else {
            self.searchBar.alpha = 0.0
        }
        self.updateBackgroundViewHeight(with: 285)
        //Clear saved car park
        UserDefaults.roadout!.setValue("roadout_carpark_clear", forKey: "ro.roadout.Roadout.carParkHash")
        carParkHash = "roadout_carpark_clear"
        NotificationCenter.default.post(name: .refreshMarkedSpotID, object: nil)
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.expressView.frame = CGRect(x: 10, y: self.screenSize.height-285-dif, width: self.screenSize.width - 20, height: 285)
            self.view.addSubview(self.expressView)
        }
    }
    
    
    //MARK: - Find Way -
    
    let findView = FindView.instanceFromNib()
        
    @objc func showFindCard() {
        let camera = GMSCameraPosition.camera(withLatitude: selectedLocation.latitude, longitude: selectedLocation.longitude, zoom: 16.0)
        self.mapView?.animate(to: camera)

        var index = 0
        for location in parkLocations {
            if location.name == selectedLocation.name {
                selectedParkLocationIndex = index
                break
            }
            index += 1
        }

        for marker in markers {
            if marker.position.latitude == selectedLocation.latitude && marker.position.longitude == selectedLocation.longitude {
                self.shakeMarkerView(marker: marker)
                self.selectedMarker = marker
            }
        }
        
        if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
            self.view.subviews.last!.removeFromSuperview()
        } else {
            self.searchBar.alpha = 0.0
        }
        
        self.updateBackgroundViewHeight(with: 285)
        //Clear saved car park
        UserDefaults.roadout!.setValue("roadout_carpark_clear", forKey: "ro.roadout.Roadout.carParkHash")
        carParkHash = "roadout_carpark_clear"
        NotificationCenter.default.post(name: .refreshMarkedSpotID, object: nil)
        var dif = 15.0
        DispatchQueue.main.async {
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.findView.frame = CGRect(x: 10, y: self.screenSize.height-285-dif, width: self.screenSize.width - 20, height: 285)
            self.view.addSubview(self.findView)
        }
    }
    
    func showFindLocationAlert() {
        let alert = UIAlertController(title: "Error".localized(), message: "There was an error, location may not be enabled for Roadout or there aren't any free spots. Please enable it in Settings if you want to use Find Way".localized(), preferredStyle: .alert)
        let action = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
        alert.addAction(action)
        alert.view.tintColor = UIColor.Roadout.devBrown
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - IBOutlets -
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var searchBar: UIView!
    
    @IBAction func searchTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        if !suspendSearch {
            guard let coord = self.mapView.myLocation?.coordinate else {
                let vc = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
                self.present(vc, animated: false, completion: nil)
                return
            }
            currentLocationCoord = coord
            let vc = storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBOutlet weak var settingsButton: UXButton!
    
    @IBAction func settingsTapped(_ sender: Any) {
        if ReservationManager.sharedInstance.isReservationActive != 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "Settings Restricted".localized(), message: "We are sorry but settings and account operations are restricted during a reservation. This ensures nothing goes wrong and you can use settings right after your reservation ends".localized(), preferredStyle: .alert)
            alert.view.tintColor = UIColor.Roadout.greyish
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    @IBOutlet weak var searchTapArea: UIButton!
    
    @IBOutlet weak var optionsBtn: UIButton!
    
    @IBAction func optionsTapped(_ sender: Any) {
        self.addToolsCard()
    }
        
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var focusedView: UIView!
    
    @IBOutlet weak var mapHostingView: UIView!
        
    @IBOutlet weak var mapTypeButton: UXButton!
    
    @IBOutlet weak var mapFocusButton: UXButton!
    
    @IBAction func mapTypeTapped(_ sender: Any) {
        if selectedMapType == MapType.roadout {
            mapTypeButton.setImage(UIImage(systemName: "globe.europe.africa.fill"), for: .normal)
            mapTypeButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(scale: .medium), forImageIn: .normal)
            mapView.mapType = .satellite
            
            selectedMapType = .satellite
        } else {
            mapTypeButton.setImage(UIImage(systemName: "map.fill"), for: .normal)
            mapTypeButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(scale: .medium), forImageIn: .normal)
            mapView.mapType = .normal
            
            selectedMapType = .roadout
        }
    }
    
    @IBAction func mapFocusTapped(_ sender: Any) {
        guard let coord = self.mapView.myLocation?.coordinate else { return }
        let camera = GMSCameraPosition.camera(withLatitude: coord.latitude, longitude: coord.longitude, zoom: 16.0)
        mapView.animate(to: camera)
    }
    
    
    @IBOutlet weak var markedSpotButton: UXButton!
    
    func toggleSettingsButtonHide(to value: Bool) {
        settingsButton.isHidden = value
    }
        
    //MARK: - OBSERVERS -
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addToolsCard), name: .addToolsCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeToolsCard), name: .removeToolsCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addResultCard), name: .addResultCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeResultCard), name: .removeResultCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addSectionCard), name: .addSectionCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeSectionCard), name: .removeSectionCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addSpotCard), name: .addSpotCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeSpotCard), name: .removeSpotCardID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addTimeCard), name: .addTimeCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeTimeCard), name: .removeTimeCardID, object: nil)
        
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
        NotificationCenter.default.addObserver(self, selector: #selector(returnFromReservation), name: .returnFromReservationID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(returnToSearchBarWithError), name: .returnToSearchBarWithErrorID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showFindCard), name: .showFindCardID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showRateReservation), name: .showRateReservationID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocation), name: .updateLocationID, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addMarkers), name: .addMarkersID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addSpotMarker), name: .addSpotMarkerID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeSpotMarker), name: .removeSpotMarkerID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMarkedSpot), name: .refreshMarkedSpotID, object: nil)
    }
    
   //MARK: - Markers Configuration -
    
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
        let hashComponents = selectedSpot.rHash.components(separatedBy: "-") //[hash, fNR, hNR, pNR]
        let markerPosition = CLLocationCoordinate2D(latitude: Geohash(geohash: hashComponents[0])!.coordinates.latitude, longitude: Geohash(geohash: hashComponents[0])!.coordinates.longitude)
        
        spotMarker = GMSMarker(position: markerPosition)
        spotMarker.title = "Selected Spot Marker"
        spotMarker.infoWindowAnchor = CGPoint()
        
        spotMarker.icon = UIImage(named: "SpotMarker_" + selectedLocation.accentColor)?.withResize(scaledToSize: CGSize(width: 30.0, height: 30.0))
        spotMarker.map = mapView
    }
    
    @objc func removeSpotMarker() {
        if spotMarker != nil {
            spotMarker.map = nil
        }
    }
    
    @objc func deselectSpotMarker() {
        if self.selectedMarker != nil {
            self.selectedMarker.iconView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "Marker_" + self.selectedMarker.snippet!)?.withResize(scaledToSize: CGSize(width: 20.0, height: 20.0))
            self.selectedMarker.iconView?.addSubview(imageView)
            self.selectedMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        }
    }
    
    @objc func refreshMarkedSpot() {
        if carParkHash == "roadout_carpark_clear" {
            self.markedSpotButton.isHidden = true
        } else {
            self.markedSpotButton.isHidden = false
        }
    }
    
    //MARK: -Marked Spot Menu-
       
       var markedSpotMenuItems: [UIAction] {
             return [
                 UIAction(title: "Remove".localized(), image: UIImage(systemName: "xmark"), handler: { (_) in
                     UIView.animate(withDuration: 0.1, animations: {
                         self.markedSpotButton.transform = CGAffineTransform.identity
                     })
                     
                     UserDefaults.roadout!.setValue("roadout_carpark_clear", forKey: "ro.roadout.Roadout.carParkHash")
                     carParkHash = "roadout_carpark_clear"
                     NotificationCenter.default.post(name: .refreshMarkedSpotID, object: nil)
                 }),
                 UIAction(title: "Navigate".localized(), image: UIImage(systemName: "arrow.triangle.branch"), handler: { (_) in
                     UIView.animate(withDuration: 0.1, animations: {
                         self.markedSpotButton.transform = CGAffineTransform.identity
                     })
                     
                     let hashComponents = carParkHash.components(separatedBy: "-") //[hash, fNR, hNR, pNR]
                     let lat = Geohash(geohash: hashComponents[0])!.coordinates.latitude
                     let long = Geohash(geohash: hashComponents[0])!.coordinates.longitude
                     
                     self.openDirectionsToCoords(lat: lat, long: long)
                 })
             ]
         }
         var markedSpotMenu: UIMenu {
             return UIMenu(title: "Marked Spot".localized(), image: nil, identifier: nil, options: [], children: markedSpotMenuItems)
         }
         
         func openDirectionsToCoords(lat: Double, long: Double) {
             var link: String
             switch UserPrefsUtils.sharedInstance.returnPrefferedMapsApp() {
             case "Google Maps":
                 link = "https://www.google.com/maps/search/?api=1&query=\(lat),\(long)"
             case "Waze":
                 link = "https://www.waze.com/ul?ll=\(lat)%2C-\(long)&navigate=yes&zoom=15"
             default:
                 link = "https://maps.apple.com/?ll=\(lat),\(long)&q=Roadout%20Location"
             }
             guard UIApplication.shared.canOpenURL(URL(string: link)!) else { return }
             UIApplication.shared.open(URL(string: link)!)
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
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.shownTip1") == false {
            settingsButton.tooltip(TutorialView1.instanceFromNib(), orientation: Tooltip.Orientation.top, configuration: { configuration in
                
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
        optionsBtn.setTitle("", for: .normal)
                
        optionsBtn.layer.cornerRadius = 14.0
        
        focusedView.layer.cornerRadius = 17.0
        
        focusedView.layer.shadowColor = UIColor.black.cgColor
        focusedView.layer.shadowOpacity = 0.15
        focusedView.layer.shadowOffset = .zero
        focusedView.layer.shadowRadius = 17.0
        focusedView.layer.shadowPath = UIBezierPath(rect: focusedView.bounds).cgPath
        focusedView.layer.shouldRasterize = true
        focusedView.layer.rasterizationScale = UIScreen.main.scale
        
        refreshMarkedSpot()
        
        //Map Setup
        let camera = GMSCameraPosition.camera(withLatitude: 46.7712, longitude: 23.6236, zoom: 16.0)
        
        if UIDevice.current.hasNotch {
            mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+7-backgroundView.frame.height-34), camera: camera)
        } else {
            mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+7-backgroundView.frame.height), camera: camera)
        }
        let mapPadding = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        mapView.padding = mapPadding
        mapView.delegate = self
        self.mapHostingView.insertSubview(mapView, at: 0)
        
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
        
        markedSpotButton.showsMenuAsPrimaryAction = true
        markedSpotButton.menu = markedSpotMenu
        
        mapFocusButton.setTitle("", for: .normal)
        mapTypeButton.setTitle("", for: .normal)
        settingsButton.setTitle("", for: .normal)
        markedSpotButton.setTitle("", for: .normal)
        
        mapFocusButton.layer.cornerRadius = 15.0
        mapTypeButton.layer.cornerRadius = 15.0
        settingsButton.layer.cornerRadius = 15.0
        markedSpotButton.layer.cornerRadius = 15.0
        
        checkUserIsValid()
        //Should check if not empty
        if parkLocations.count >= cityParkLocationsCount {
            self.addMarkers()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.layer.cornerRadius = 12.0
        backgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
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
            manageCityData()
          } else {
            print("Unable to find style.json")
          }
        } catch {
            print("One or more of the map styles failed to load. \(error)")
        }
    }
    
    
    //MARK: -Data & UI Configuration-
    
    func checkUserIsValid() {
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
        Task {
            do {
                try await AuthManager.sharedInstance.checkIfUserExistsAsync(with: id)
            } catch let err {
                let convertedError = err as? AuthManager.AuthErrors
                if convertedError != .databaseFailure && convertedError != .errorWithJson && ConnectionManager.sharedInstance.reachability.connection != .unavailable {
                    self.userNotFoundAbort()
                }
            }
        }
    }
    
    func userNotFoundAbort() {
        UserDefaults.roadout!.set(false, forKey: "ro.roadout.Roadout.isUserSigned")
        UserDefaults.roadout!.removeObject(forKey: "ro.roadout.Roadout.userID")
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
    
    func manageCityData() {
        //Should check if empty
        if parkLocations.count < cityParkLocationsCount {
            let sb = UIStoryboard(name: "Home", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "GetDataVC") as! GetDataViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func updateBackgroundViewHeight(with cardHeight: CGFloat) {
        backgroundView.setHeight(cardHeight+85, animateTime: 0.1)
        let mapInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: cardHeight-52, right: 0.0)
        mapView.padding = mapInsets
        focusedView.layer.shadowPath = UIBezierPath(rect: focusedView.bounds).cgPath
        let mapPadding = UIEdgeInsets(top: 0, left: 0, bottom: cardHeight-44, right: 0)
        mapView.padding = mapPadding
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
    
}

//MARK: -Google Maps & Location Extensions-
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
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 16.0)
        self.mapView?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    
}

extension HomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if marker != spotMarker {
            if self.view.subviews.last != paidBar && self.view.subviews.last != activeBar && self.view.subviews.last != unlockedView && self.view.subviews.last != reservationView && self.view.subviews.last != noWifiBar && self.isMarkerInteractive {
                selectedLocation.name = marker.title!
                let colorSnippet = marker.snippet!
                selectedLocation.accentColor = colorSnippet
                selectedLocation.latitude = marker.position.latitude
                selectedLocation.longitude = marker.position.longitude
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
                self.removeSpotMarker()
            }
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
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
        
        marker.iconView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 80))
        
        let imageView = UIImageView(frame: CGRect(x: (marker.iconView?.frame.width)!/2 - 14.625, y: (marker.iconView?.frame.height)! - 43.2, width: 29.52, height: 43.2))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "SelectedMarker_" + marker.snippet!)
        imageView.layer.frame = CGRect(x: (marker.iconView?.frame.width)!/2 - 14.625, y: (marker.iconView?.frame.height)! - 43.2, width: 29.52, height: 43.2)
        
        marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
        marker.iconView?.addSubview(imageView)
        marker.iconView!.subviews[0].layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        marker.iconView!.subviews[0].layer.add(animation, forKey: "shakeAnimation")
        UIView.animate(withDuration: 0.3) {
            marker.iconView?.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }
    }
}

//MARK: -Card Functions-
extension HomeViewController {
    //Tools Card
    @objc func addToolsCard() {
        DispatchQueue.main.async {
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 155)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.toolsView.frame = CGRect(x: 10, y: self.screenSize.height-155-dif, width: self.screenSize.width - 20, height: 155)
            self.view.addSubview(self.toolsView)
        }
    }
    @objc func removeToolsCard() {
        DispatchQueue.main.async {
            self.updateBackgroundViewHeight(with: 52)
            self.searchBar.alpha = 1.0
            self.toolsView.removeFromSuperview()
        }
    }
    //Result Card
    @objc func addResultCard() {
        let camera = GMSCameraPosition.camera(withLatitude: selectedLocation.latitude, longitude: selectedLocation.longitude, zoom: 16.0)
        self.mapView?.animate(to: camera)
        
        var index = 0
        for location in parkLocations {
            if location.name == selectedLocation.name {
                selectedParkLocationIndex = index
                break
            }
            index += 1
        }
        
        for marker in markers {
            if marker.position.latitude == selectedLocation.latitude && marker.position.longitude == selectedLocation.longitude {
                self.shakeMarkerView(marker: marker)
                self.selectedMarker = marker
            }
        }
        
        searchBar.alpha = 0.0
        
        self.updateBackgroundViewHeight(with: 142)
        guard let coord = self.mapView.myLocation?.coordinate else {
            var dif = 15.0
            DispatchQueue.main.async {
                if (UIDevice.current.hasNotch) {
                    dif = 49.0
                }
                self.resultView.frame = CGRect(x: 10, y: self.screenSize.height-142-dif, width: self.screenSize.width - 20, height: 142)
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
            self.resultView.frame = CGRect(x: 10, y: self.screenSize.height-142-dif, width: self.screenSize.width - 20, height: 142)
            self.view.addSubview(self.resultView)
        }
        
    }
    @objc func removeResultCard() {
        DispatchQueue.main.async {
            self.updateBackgroundViewHeight(with: 52)
            self.searchBar.alpha = 1.0
            self.resultView.removeFromSuperview()
            self.deselectSpotMarker()
        }
    }
    //Section Card
    @objc func addSectionCard() {
        DispatchQueue.main.async {
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 331)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.sectionView.frame = CGRect(x: 10, y: self.screenSize.height-331-dif, width: self.screenSize.width - 20, height: 331)
            self.view.addSubview(self.sectionView)
        }
    }
    @objc func removeSectionCard() {
        DispatchQueue.main.async {
            self.updateBackgroundViewHeight(with: 142)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.resultView.frame = CGRect(x: 10, y: self.screenSize.height-142-dif, width: self.screenSize.width - 20, height: 142)
            self.view.addSubview(self.resultView)
            self.sectionView.removeFromSuperview()
        }
    }
    //Spot Card
    @objc func addSpotCard() {
        DispatchQueue.main.async {
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 318)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.spotView.frame = CGRect(x: 10, y: self.screenSize.height-318-dif, width: self.screenSize.width - 20, height: 318)
            self.view.addSubview(self.spotView)
        }
    }
    @objc func removeSpotCard() {
        DispatchQueue.main.async {
            self.updateBackgroundViewHeight(with: 331)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.sectionView.frame = CGRect(x: 10, y: self.screenSize.height-331-dif, width: self.screenSize.width - 20, height: 331)
            self.view.addSubview(self.sectionView)
            self.spotView.removeFromSuperview()
        }
    }
    //Reserve Card
    @objc func addTimeCard() {
        DispatchQueue.main.async {
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 252)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.timeView.frame = CGRect(x: 10, y: self.screenSize.height-252-dif, width: self.screenSize.width - 20, height: 252)
            self.view.addSubview(self.timeView)
        }
    }
    @objc func removeTimeCard() {
        DispatchQueue.main.async {
            if returnToResult {
                self.updateBackgroundViewHeight(with: 142)
                var dif = 15.0
                if (UIDevice.current.hasNotch) {
                    dif = 49.0
                }
                self.resultView.frame = CGRect(x: 10, y: self.screenSize.height-142-dif, width: self.screenSize.width - 20, height: 142)
                self.view.addSubview(self.resultView)
                self.timeView.removeFromSuperview()
                
            } else {
                self.updateBackgroundViewHeight(with: 318)
                var dif = 15.0
                if (UIDevice.current.hasNotch) {
                    dif = 49.0
                }
                self.spotView.frame = CGRect(x: 10, y: self.screenSize.height-318-dif, width: self.screenSize.width - 20, height: 318)
                self.view.addSubview(self.spotView)
                self.timeView.removeFromSuperview()
            }
        }
    }
    //Pay Card
    @objc func addPayCard() {
        DispatchQueue.main.async {
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 270)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.payView.frame = CGRect(x: 10, y: self.screenSize.height-270-dif, width: self.screenSize.width - 20, height: 270)
            self.view.addSubview(self.payView)
        }
    }
    @objc func removePayCard() {
        DispatchQueue.main.async {
            self.updateBackgroundViewHeight(with: 252)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.timeView.frame = CGRect(x: 10, y: self.screenSize.height-252-dif, width: self.screenSize.width - 20, height: 252)
            self.view.addSubview(self.timeView)
            self.payView.removeFromSuperview()
        }
    }
    //Reservation Card
    @objc func addReservationCard() {
        DispatchQueue.main.async {
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 265)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.reservationView.frame = CGRect(x: 10, y: self.screenSize.height-265-dif, width: self.screenSize.width - 20, height: 265)
            self.view.addSubview(self.reservationView)
        }
    }
    @objc func removeReservationCard() {
        DispatchQueue.main.async {
            self.updateBackgroundViewHeight(with: 52)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.activeBar.frame = CGRect(x: 10, y: self.screenSize.height-52-dif, width: self.screenSize.width - 20, height: 52)
            self.view.addSubview(self.activeBar)
            self.reservationView.removeFromSuperview()
        }
    }
    //Delay Card
    @objc func addDelayCard() {
        DispatchQueue.main.async {
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 225)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.delayView.frame = CGRect(x: 10, y: self.screenSize.height-225-dif, width: self.screenSize.width - 20, height: 225)
            self.view.addSubview(self.delayView)
        }
    }
    @objc func removeDelayCard() {
        DispatchQueue.main.async {
            self.updateBackgroundViewHeight(with: 265)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.reservationView.frame = CGRect(x: 10, y: self.screenSize.height-265-dif, width: self.screenSize.width - 20, height: 265)
            self.view.addSubview(self.reservationView)
            self.delayView.removeFromSuperview()
        }
    }
    //Pay Delay Card
    @objc func addPayDelayCard() {
        DispatchQueue.main.async {
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 270)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.payView.frame = CGRect(x: 10, y: self.screenSize.height-270-dif, width: self.screenSize.width - 20, height: 270)
            self.view.addSubview(self.payView)
        }
    }
    @objc func removePayDelayCard() {
        DispatchQueue.main.async {
            self.updateBackgroundViewHeight(with: 225)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.delayView.frame = CGRect(x: 10, y: self.screenSize.height-225-dif, width: self.screenSize.width - 20, height: 225)
            self.view.addSubview(self.delayView)
            self.payView.removeFromSuperview()
        }
    }
    //Unlock Card
    @objc func addUnlockCard() {
        DispatchQueue.main.async {
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 221)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.unlockView.frame = CGRect(x: 10, y: self.screenSize.height-221-dif, width: self.screenSize.width - 20, height: 221)
            self.view.addSubview(self.unlockView)
        }
    }
    @objc func removeUnlockCard() {
        DispatchQueue.main.async {
            self.updateBackgroundViewHeight(with: 265)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.reservationView.frame = CGRect(x: 10, y: self.screenSize.height-265-dif, width: self.screenSize.width - 20, height: 265)
            self.view.addSubview(self.reservationView)
            self.unlockView.removeFromSuperview()
        }
    }
    
    @objc func showUnlockedView() {
        DispatchQueue.main.async {
            self.toggleSettingsButtonHide(to: false)
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 155)
            var dif = 15.0
            
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.unlockedView.frame = CGRect(x: 10, y: self.screenSize.height-155-dif, width: self.screenSize.width - 20, height: 155)
            self.view.addSubview(self.unlockedView)
        }
    }

    @objc func addPayDurationCard() {
        DispatchQueue.main.async {
            let camera = GMSCameraPosition.camera(withLatitude: (selectedPayLocation!.latitude), longitude: (selectedPayLocation!.longitude), zoom: 16.0)
            self.mapView?.animate(to: camera)
            
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 206)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.payDurationView.frame = CGRect(x: 10, y: self.screenSize.height-206-dif, width: self.screenSize.width - 20, height: 206)
            self.view.addSubview(self.payDurationView)
        }
    }
    @objc func removePayDurationCard() {
        DispatchQueue.main.async {
            self.updateBackgroundViewHeight(with: 155)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.unlockedView.frame = CGRect(x: 10, y: self.screenSize.height-155-dif, width: self.screenSize.width - 20, height: 155)
            self.view.addSubview(self.unlockedView)
            self.payDurationView.removeFromSuperview()
        }
    }
    
    @objc func addPayParkingCard() {
        DispatchQueue.main.async {
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 271)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.payParkingView.frame = CGRect(x: 10, y: self.screenSize.height-271-dif, width: self.screenSize.width - 20, height: 271)
            self.view.addSubview(self.payParkingView)
        }
    }
    @objc func removePayParkingCard() {
        DispatchQueue.main.async {
            self.updateBackgroundViewHeight(with: 206)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.payDurationView.frame = CGRect(x: 10, y: self.screenSize.height-206-dif, width: self.screenSize.width - 20, height: 206)
            self.view.addSubview(self.payDurationView)
            self.payParkingView.removeFromSuperview()
        }
    }
    
    //MARK: -Bar functions-
    
    @objc func showPaidBar() {
        DispatchQueue.main.async {
            self.toggleSettingsButtonHide(to: true)
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
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 52)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.paidBar.frame = CGRect(x: 10, y: self.screenSize.height-52-dif, width: self.screenSize.width - 20, height: 52)
            self.view.addSubview(self.paidBar)
        }
    }
    
    @objc func showActiveBar() {
        DispatchQueue.main.async {
            self.toggleSettingsButtonHide(to: true)
            if self.view.subviews.last != self.reservationView {
                if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                    self.view.subviews.last!.removeFromSuperview()
                } else {
                    self.searchBar.alpha = 0.0
                }
                self.updateBackgroundViewHeight(with: 52)
                var dif = 15.0
                if (UIDevice.current.hasNotch) {
                    dif = 49.0
                }
                self.activeBar.frame = CGRect(x: 10, y: self.screenSize.height-52-dif, width: self.screenSize.width - 20, height: 52)
                self.view.addSubview(self.activeBar)
            }
        }
    }
    
    @objc func showEndedBar() {
        DispatchQueue.main.async {
            self.toggleSettingsButtonHide(to: false)
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 52)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.endedBar.frame = CGRect(x: 10, y: self.screenSize.height-52-dif, width: self.screenSize.width - 20, height: 52)
            self.view.addSubview(self.endedBar)
        }
    }
    
    @objc func showCancelledBar() {
        DispatchQueue.main.async {
            self.toggleSettingsButtonHide(to: false)
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 52)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.cancelledBar.frame = CGRect(x: 10, y: self.screenSize.height-52-dif, width: self.screenSize.width - 20, height: 52)
            self.view.addSubview(self.cancelledBar)
        }
    }
    
    @objc func showNoWifiBar() {
        DispatchQueue.main.async {
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.removeSpotMarker()
            self.deselectSpotMarker()
            self.updateBackgroundViewHeight(with: 52)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.noWifiBar.frame = CGRect(x: 10, y: self.screenSize.height-52-dif, width: self.screenSize.width - 20, height: 52)
            self.view.addSubview(self.noWifiBar)
        }
    }
    
    @objc func showPaidParkingBar() {
        DispatchQueue.main.async {
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            } else {
                self.searchBar.alpha = 0.0
            }
            self.updateBackgroundViewHeight(with: 52)
            var dif = 15.0
            if (UIDevice.current.hasNotch) {
                dif = 49.0
            }
            self.paidParkingBar.frame = CGRect(x: 10, y: self.screenSize.height-52-dif, width: self.screenSize.width - 20, height: 52)
            self.view.addSubview(self.paidParkingBar)
        }
    }
    
    //MARK: -Return to Search Bar-
    @objc func returnToSearchBar() {
        DispatchQueue.main.async {
            self.toggleSettingsButtonHide(to: false)
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            }
            self.removeSpotMarker()
            self.deselectSpotMarker()
            self.updateBackgroundViewHeight(with: 52)
            self.searchBar.alpha = 1.0
        }
    }
    
    @objc func returnFromReservation() {
        ///Only dismisses view if it's from the reservation ones
        DispatchQueue.main.async {
            self.toggleSettingsButtonHide(to: false)
            let lastSubview = self.view.subviews.last
            if lastSubview == self.activeBar || lastSubview == self.reservationView || lastSubview == self.unlockView || lastSubview == self.delayView || (lastSubview == self.payView && returnToDelay == true) {
                self.view.subviews.last!.removeFromSuperview()
                
                self.removeSpotMarker()
                self.deselectSpotMarker()
                self.showEndedBar()
            }
        }
    }
    
    @objc func returnToSearchBarWithError() {
        DispatchQueue.main.async {
            self.toggleSettingsButtonHide(to: false)
            if self.view.subviews.last != nil && self.view.subviews.last != self.searchBar && self.view.subviews.last != self.mapView {
                self.view.subviews.last!.removeFromSuperview()
            }
            self.removeSpotMarker()
            self.deselectSpotMarker()
            self.updateBackgroundViewHeight(with: 52)
            self.searchBar.alpha = 1.0
            //Show alert
            let alert = UIAlertController(title: "Retrieving Error".localized(), message: "There was an error retrieving reservation details. If you have an active reservation, please quit the app and try again".localized(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .cancel)
            alert.addAction(okAction)
            
            alert.view.tintColor = UIColor.Roadout.darkYellow
            self.present(alert, animated: true)
        }
    }
    
    @objc func removeNoWifiBar() {
        DispatchQueue.main.async {
            if self.view.subviews.last == self.noWifiBar {
                self.view.subviews.last!.removeFromSuperview()
                guard let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") else { return }
                Task {
                    do {
                        try await ReservationManager.sharedInstance.checkForReservationAsync(date: Date(), userID: id as! String)
                        if ReservationManager.sharedInstance.isReservationActive == 0 {
                            //active
                            NotificationCenter.default.post(name: .showActiveBarID, object: nil)
                        } else if ReservationManager.sharedInstance.isReservationActive == 1 {
                            //unlocked
                            NotificationCenter.default.post(name: .showUnlockedViewID, object: nil)
                        } else if ReservationManager.sharedInstance.isReservationActive == 2 {
                            //cancelled
                            NotificationCenter.default.post(name: .showCancelledBarID, object: nil)
                        } else if ReservationManager.sharedInstance.isReservationActive == 3 {
                            //not active
                            NotificationCenter.default.post(name: .returnFromReservationID, object: nil)
                        } else {
                            //error
                            NotificationCenter.default.post(name: .returnToSearchBarWithErrorID, object: nil)
                        }
                    }
                }
            }
        }
    }
}
