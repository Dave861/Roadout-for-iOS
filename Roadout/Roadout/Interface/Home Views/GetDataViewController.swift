//
//  DataViewController.swift
//  Roadout
//
//  Created by David Retegan on 19.02.2022.
//

import UIKit

class GetDataViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var blurButton: UIButton!
    
    @IBAction func dismissTapped(_ sender: Any) {
        //No dismiss allowed
    }
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    
    @IBOutlet weak var icn1: UIImageView!
    @IBOutlet weak var icn2: UIImageView!
    @IBOutlet weak var icn3: UIImageView!
    
    @IBOutlet weak var sublbl1: UILabel!
    @IBOutlet weak var sublbl2: UILabel!
    @IBOutlet weak var sublbl3: UILabel!
    
    @IBOutlet weak var cityLbl: UILabel!

    func downloadCityData() {
        parkLocations = testParkLocations //will empty here
        EntityManager.sharedInstance.getParkLocations("Cluj") { result in
            switch result {
                case .success():
                for index in 0...dbParkLocations.count-1 {
                    EntityManager.sharedInstance.getParkSections(dbParkLocations[index].rID) { res in
                        switch res {
                            case .success():
                                print("YAYAY")
                                dbParkLocations[index].sections = dbParkSections
                                parkLocations.append(dbParkLocations[index])
                            case .failure(let err):
                                self.showErrors(error: err)
                        }
                    }
                }
                case .failure(let err):
                    self.showErrors(error: err)
            }
        }
        
        if self.icn3.alpha == 1 {
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: .addMarkersID, object: nil)
            }
        }
    }
    
    func showErrors(error: Error) {
        let alert = UIAlertController(title: "Download Error".localized(), message: "There was an error. Try again or force quit the app and reopen. If the problem persists please screenshot this and send a bug report. Error Code: ".localized() + error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        let tryAgainAction = UIAlertAction(title: "Try Again".localized(), style: .default) { _ in
            self.downloadCityData()
        }
        alert.addAction(tryAgainAction)
        
        alert.view.tintColor = UIColor(named: "DevBrown")
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 16.0
        self.downloadCityData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.5) {
            self.blurButton.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 1.1) {
                self.line1.alpha = 1.0
                self.lbl1.alpha = 1.0
                self.icn1.alpha = 1.0
                self.sublbl2.alpha = 1.0
            } completion: { _ in
                UIView.animate(withDuration: 1.1) {
                    self.line2.alpha = 1.0
                    self.lbl2.alpha = 1.0
                    self.icn2.alpha = 1.0
                    self.sublbl3.alpha = 1.0
                } completion: { _ in
                    UIView.animate(withDuration: 1.1) {
                        self.line3.alpha = 1.0
                        self.lbl3.alpha = 1.0
                        self.icn3.alpha = 1.0
                    } completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            self.blurButton.alpha = 0
                        } completion: { done in
                            if parkLocations.count == 10 {
                                self.dismiss(animated: true)  {
                                    NotificationCenter.default.post(name: .addMarkersID, object: nil)
                                }
                            }
                        }
                    }
                }
            }
        }

    }
    
    
}
