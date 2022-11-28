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
    
    @IBOutlet weak var tryAgainBtn: UIButton!
    
    @IBAction func tryAgainTapped(_ sender: Any) {
        tryAgainBtn.isHidden = true
        saveCityData()
    }
    
    func saveCityData() {
        parkLocations = testParkLocations //will empty here
        Task {
            do {
                try await downloadCityData("Cluj")
                parkLocations = testParkLocations + dbParkLocations
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: false) {
                    NotificationCenter.default.post(name: .addMarkersID, object: nil)
                }
            } catch let err {
                self.showDevErrors(error: err)
            }
        }
    }
    
    func downloadCityData(_ city: String) async throws {
        do {
            try await EntityManager.sharedInstance.saveParkLocationsAsync(city)
        } catch let err {
            throw err
        }
        for pI in 0...dbParkLocations.count-1 {
            do {
                try await EntityManager.sharedInstance.saveParkSectionsAsync(dbParkLocations[pI].rID)
                dbParkLocations[pI].sections = dbParkSections
            } catch let err {
                throw err
            }
        }
    }
    
    func showErrors(error: Error) {
        let alert = UIAlertController(title: "Download Error".localized(), message: "There was an error reaching our server. Try again or force quit the app and reopen. If the problem persists please screenshot this and send a bug report at bugs@roadout.ro".localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel) { _ in
            self.tryAgainBtn.isHidden = false
        }
        alert.addAction(okAction)
        
        let tryAgainAction = UIAlertAction(title: "Try Again".localized(), style: .default) { _ in
            self.saveCityData()
            self.tryAgainBtn.isHidden = true
        }
        alert.addAction(tryAgainAction)
        
        alert.view.tintColor = UIColor(named: "Kinda Red")
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDevErrors(error: Error) {
        let alert = UIAlertController(title: "Download Error".localized(), message: "There was an error reaching our server. Try again or force quit the app and reopen. If the problem persists please screenshot this and send a bug report at bugs@roadout.ro".localized() + error.localizedDescription, preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter New Server"
        }
        
        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel) { _ in
            self.tryAgainBtn.isHidden = false
        }
        alert.addAction(okAction)
        
        let tryAgainAction = UIAlertAction(title: "Try Again".localized(), style: .default) { _ in
            let serverTextField = alert.textFields![0] as UITextField
            roadoutServerURL = serverTextField.text!
            UserDefaults.roadout!.set(roadoutServerURL, forKey: "ro.roadout.Roadout.devServerURL")
            self.saveCityData()
            self.tryAgainBtn.isHidden = true
        }
        alert.addAction(tryAgainAction)
        
        alert.view.tintColor = UIColor(named: "Kinda Red")
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 17.0
        tryAgainBtn.layer.cornerRadius = 14.0
        tryAgainBtn.isHidden = true
        titleLbl.text = "Loading City Data".localized()
        activityIndicator.startAnimating()
        saveCityData()
    }

}
