//
//  AddExpressViewController.swift
//  Roadout
//
//  Created by David Retegan on 23.07.2022.
//

import UIKit

class AddExpressViewController: UIViewController {

    let addTitle = NSAttributedString(string: "Add".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    
    var selectableLocations = parkLocations.filter { !favouriteLocations.contains($0) }

    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    @objc func blurTapped() {
        UIView.animate(withDuration: 0.1) {
            self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
          self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var addBtn: UIButton!
    
    @IBAction func addTapped(_ sender: Any) {
        favouriteLocationIDs = UserDefaults.roadout!.stringArray(forKey: "ro.roadout.Roadout.favouriteLocationIDs") ?? [String]()
        for i in 0...tableView.indexPathsForSelectedRows!.count-1 {
            let ind = tableView.indexPathsForSelectedRows![i]
            favouriteLocationIDs.append(selectableLocations[ind.row].rID)
         }
        UserDefaults.roadout!.set(favouriteLocationIDs, forKey: "ro.roadout.Roadout.favouriteLocationIDs")
        NotificationCenter.default.post(name: .reloadExpressLocationsID, object: nil)
        UIView.animate(withDuration: 0.1) {
          self.blurEffect.alpha = 0
        } completion: { done in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var placeholderView: UIView!
    
    let cancelTitle = NSAttributedString(string: "Cancel".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])
    
    func addShadowToCardView() {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 20.0
        cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
        cardView.layer.shouldRasterize = true
        cardView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 20.0
        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        addShadowToCardView()

        addBtn.layer.cornerRadius = 12
        addBtn.setAttributedTitle(addTitle, for: .normal)
       
    
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurEffect.addGestureRecognizer(tapRecognizer)
        
        titleLbl.text = "Add Location".localized()
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        managePlaceholder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.blurEffect.alpha = 0.7
        }
    }
    
    func managePlaceholder() {
        if selectableLocations.count == 0 {
            placeholderView.isHidden = false
        } else {
            placeholderView.isHidden = true
        }
    }
    
}
extension AddExpressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectableLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddExpressCell") as! AddExpressCell
        cell.locationNameLbl.text = selectableLocations[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }
}
