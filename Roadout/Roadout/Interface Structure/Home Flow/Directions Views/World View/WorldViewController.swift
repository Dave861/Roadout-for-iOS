//
//  WorldViewController.swift
//  Roadout
//
//  Created by David Retegan on 31.07.2022.
//

import UIKit
import GeohashKit
import Alamofire

class WorldViewController: UIViewController {
    
    let doneTitle = NSAttributedString(string: "Done".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var worldImage: UIImageView!
    
    @IBOutlet weak var doneBtn: UXButton!
    
    @IBAction func doneTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.cachedWorldHash") ?? "" == selectedSpot.rHash &&
            UserDefaults.roadout!.data(forKey: "ro.roadout.Roadout.cachedWorldImage") != nil {
            guard let data = UserDefaults.roadout!.data(forKey: "ro.roadout.Roadout.cachedWorldImage") else { return }
            self.worldImage.image = UIImage(data: data as Data)
        }
        
        titleLbl.text = "World View".localized()
        descriptionLbl.text = "World View is provided by Google Maps and it shows a real world image of how the spot you reserved looked like at some point in time in order to help you locate it more easily".localized()
        
        doneBtn.layer.cornerRadius = 13.0
        doneBtn.setAttributedTitle(doneTitle, for: .normal)
        worldImage.layer.cornerRadius = 23.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.roadout!.string(forKey: "ro.roadout.Roadout.cachedWorldHash") ?? "" != selectedSpot.rHash ||
            UserDefaults.roadout!.data(forKey: "ro.roadout.Roadout.cachedWorldImage") == nil {
            decodeGeohash()
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
        }
    }
    
    //MARK: - Getting Image -
    
    func decodeGeohash() {
        UserDefaults.roadout!.setValue(selectedSpot.rHash, forKey: "ro.roadout.Roadout.cachedWorldHash")
        
        let hashComponents = selectedSpot.rHash.components(separatedBy: "-") //[hash, fNR, hNR, pNR]
        let fov = String(hashComponents[1].dropFirst())
        let heading = String(hashComponents[2].dropFirst())
        let pitch = String(hashComponents[3].dropFirst())
        
        let lat = Geohash(geohash: hashComponents[0])!.coordinates.latitude
        let long = Geohash(geohash: hashComponents[0])!.coordinates.longitude
        
        let worldLocation = WorldLocation(latitude: lat, longitude: long, fov: Int(fov)!, heading: Int(heading)!, pitch: Int(pitch)!)
                
        getWorldImage(for: worldLocation)
    }
    
    func getWorldImage(for worldLocation: WorldLocation) {
        let urlString = "https://maps.googleapis.com/maps/api/streetview?location=\(worldLocation.latitude),\(worldLocation.longitude)&size=900x900&fov=\(worldLocation.fov)&heading=\(worldLocation.heading)&pitch=\(worldLocation.pitch)&key=\(webAPIKey)"
        
        AF.request(urlString).responseData { response in
            if response.error == nil {
                if let data = response.data {
                    self.worldImage.image = UIImage(data: data)
                    UserDefaults.roadout!.setValue(data, forKey: "ro.roadout.Roadout.cachedWorldImage")
                }
            }
        }
    }
}
