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
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var tryAgainBtn: UXButton!
    
    @IBAction func tryAgainTapped(_ sender: Any) {
        tryAgainBtn.isHidden = true
        progressView.isHidden = false
        saveCityData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 17.0
        tryAgainBtn.layer.cornerRadius = 14.0
        tryAgainBtn.isHidden = true
        progressView.isHidden = false
        titleLbl.text = "Loading City Data".localized()
        activityIndicator.startAnimating()
        saveCityData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        progressView.layer.cornerRadius = 17.0
        progressView.clipsToBounds = true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
        }
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
                self.progressView.progress = 0.0
                self.showErrors(error: err)
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
                progressView.setProgress(Float(pI+1)/Float(dbParkLocations.count), animated: true)
            } catch let err {
                throw err
            }
        }
    }
    
    func showErrors(error: Error) {
        let alert = UIAlertController(title: "Download Error".localized(), message: "There was an error reaching our server. Try again or force quit the app and reopen. If the problem persists please screenshot this and send a bug report at bugs@roadout.ro".localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel) { _ in
            self.tryAgainBtn.isHidden = false
            self.progressView.isHidden = true
        }
        alert.addAction(okAction)
        
        let tryAgainAction = UIAlertAction(title: "Try Again".localized(), style: .default) { _ in
            self.saveCityData()
            self.tryAgainBtn.isHidden = true
            self.progressView.isHidden = false
        }
        alert.addAction(tryAgainAction)
        
        alert.view.tintColor = UIColor.Roadout.kindaRed
        self.present(alert, animated: true, completion: nil)
    }

}
