//
//  AddExpressViewController.swift
//  Roadout
//
//  Created by David Retegan on 23.07.2022.
//

import UIKit

class AddExpressViewController: UIViewController {

    let doneTitle = NSAttributedString(string: "Done".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @objc func blurTapped() {
        self.reloadCheckedItems()
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.reloadCheckedItems()
        UIView.animate(withDuration: 0.1) {
          self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var doneBtn: UXButton!
    
    @IBAction func doneTapped(_ sender: Any) {
        UserDefaults.roadout!.set(favouriteLocationIDs, forKey: "ro.roadout.Roadout.favouriteLocationIDs")
        NotificationCenter.default.post(name: .reloadExpressLocationsID, object: nil)
        UIView.animate(withDuration: 0.1) {
          self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 20.0
        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addShadowToCardView()

        doneBtn.layer.cornerRadius = 12
        doneBtn.setAttributedTitle(doneTitle, for: .normal)
       
    
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
        
        titleLbl.text = "Edit Locations".localized()
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.alpha = 0.7
        }
    }
    
    func addShadowToCardView() {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 20.0
        cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
        cardView.layer.shouldRasterize = true
        cardView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func reloadCheckedItems() {
        favouriteLocationIDs = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.Roadout.favouriteLocationIDs") ?? [String]()
        tableView.reloadData()
    }
   
    
}
extension AddExpressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddExpressCell") as! AddExpressCell
        cell.locationNameLbl.text = parkLocations[indexPath.row].name
        if favouriteLocationIDs.contains(parkLocations[indexPath.row].rID) {
            cell.check.image = UIImage(systemName: "checkmark.circle.fill")
            cell.check.tintColor = UIColor.Roadout.devBrown
        } else {
            cell.check.image = UIImage(systemName: "plus.circle.fill")
            cell.check.tintColor = UIColor.Roadout.expressFocus
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 53
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AddExpressCell
        if cell.check.image == UIImage(systemName: "plus.circle.fill") {
            cell.check.image = UIImage(systemName: "checkmark.circle.fill")
            cell.check.tintColor = UIColor.Roadout.devBrown
            favouriteLocationIDs.append(parkLocations[indexPath.row].rID)
        } else {
            cell.check.image = UIImage(systemName: "plus.circle.fill")
            cell.check.tintColor = UIColor.Roadout.expressFocus
            favouriteLocationIDs = favouriteLocationIDs.remove(parkLocations[indexPath.row].rID)
        }
    }
}
