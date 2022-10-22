//
//  DataViewController.swift
//  Roadout
//
//  Created by David Retegan on 19.02.2022.
//

import UIKit

class GetDataViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    func downloadCityData() {
        parkLocations = testParkLocations //will empty here
        EntityManager.sharedInstance.getParkLocations("Cluj") { result in
            switch result {
                case .success():
                for index in 0...dbParkLocations.count-1 {
                    EntityManager.sharedInstance.getParkSections(dbParkLocations[index].rID) { res in
                        switch res {
                            case .success():
                                dbParkLocations[index].sections = dbParkSections
                                parkLocations.append(dbParkLocations[index])
                                if parkLocations.count >= cityParkLocationsCount {
                                     self.activityIndicator.stopAnimating()
                                     self.dismiss(animated: false) {
                                         NotificationCenter.default.post(name: .addMarkersID, object: nil)
                                     }
                                }
                            case .failure(let err):
                                self.showErrors(error: err)
                        }
                    }
                }
                case .failure(let err):
                    self.showErrors(error: err)
            }
        }
    }
    
    func showErrors(error: Error) {
        let alert = UIAlertController(title: "Download Error".localized(), message: "There was an error reaching our server. Try again or force quit the app and reopen. If the problem persists please screenshot this and send a bug report at bugs@roadout.ro".localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        let tryAgainAction = UIAlertAction(title: "Try Again".localized(), style: .default) { _ in
            self.downloadCityData()
        }
        alert.addAction(tryAgainAction)
        
        alert.view.tintColor = UIColor(named: "Kinda Red")
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 17.0
        titleLbl.text = "Loading City Data".localized()
        activityIndicator.startAnimating()
        self.downloadCityData()
    }

    
    
}
