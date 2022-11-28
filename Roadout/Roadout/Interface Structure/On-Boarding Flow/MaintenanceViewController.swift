//
//  MaintenanceViewController.swift
//  Roadout
//
//  Created by David Retegan on 22.08.2022.
//

import UIKit

///Further details on Maintenance Screen
///This screen will be shown when server is down, if that is to be done intentionally, firstly the make reservation API will go down, then all existing reservation will be honored, only then will the server be taken down
class MaintenanceViewController: UIViewController {

    let icons = ["server.rack", "lifepreserver"]
    let titles = ["Server Problems".localized(), "No Worries".localized()]
    let descriptions = ["Oops! It seems Roadout’s servers are under maintenance or facing problems. We are sorry for the inconvenince".localized(), "We are already working to fix this, please be patient and check back a little later".localized()]

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var checkBtn: UIButton!
    @IBAction func checkTapped(_ sender: Any) {
        if UserDefaults.roadout!.bool(forKey: "ro.roadout.Roadout.isUserSigned") {
            guard let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") else {
                self.showSorryAlert()
                return
            }
            //API call for continuity when app is opened again (to prevent showing unlocked view and mark reservation as done)
            Task {
                do {
                    try await ReservationManager.sharedInstance.checkForReservationAsync(date: Date(), userID: id as! String)
                    let homeSb = UIStoryboard(name: "Home", bundle: nil)
                    let homeVC = homeSb.instantiateViewController(withIdentifier: "NavVC") as! UINavigationController
                    self.view.window?.rootViewController = homeVC
                    self.view.window?.makeKeyAndVisible()
                } catch let err {
                    print(err)
                    self.showSorryAlert()
                }
            }
        } else {
            UserDefaults.roadout!.removeObject(forKey: "ro.roadout.Roadout.userID")
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeViewController
            self.view.window?.rootViewController = vc
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    let checkTitle = NSAttributedString(string: "Check Again".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
        
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = "Maintenance".localized()
        checkBtn.layer.cornerRadius = 13.0
        checkBtn.setAttributedTitle(checkTitle, for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func showSorryAlert() {
        let alert = UIAlertController(title: "Sorry".localized(), message: "There still appear to be problems, we are working as hard as we can to fix them. Additionally you can try force quitting and reopening Roadout, you can also get support at maintenance@roadout.ro.".localized(), preferredStyle: .alert)
        alert.view.tintColor = UIColor(named: "Second Orange")!
        let okAction = UIAlertAction(title: "OK".localized(), style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    

}
extension MaintenanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaintenanceCell") as! MaintenanceCell
        cell.titleLabel.text = titles[indexPath.row]
        cell.infoLabel.text = descriptions[indexPath.row]
        cell.iconImage.image = UIImage(systemName: self.icons[indexPath.row])!
        
        return cell
    }
    
}
