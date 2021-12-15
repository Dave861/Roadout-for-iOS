//
//  PrizesViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit

class PrizesViewController: UIViewController {
    
    let prizes = ["Road Diploma", "Drive Medal", "Planner Trophy", "Traffic Cup", "Wreath of Gratitude"]
    let prizeImages = ["Diploma", "Medal", "Trophy", "Cup", "Wreath"]
    let prizeRequirements = ["Make 1 reservation and invite 5 friends", "Make 5 reservations and invite 10 friends", "Make 10 reservations, invite 15 friends and make a delay", "Make 15 reservations, invite 20 friends and make 5 delays", "Make 20 reservations, invite 25 friends and make 10 delays"]

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

}
extension PrizesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prizes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrizesCell") as! PrizesCell
        cell.prizeLbl.text = prizes[indexPath.row]
        cell.requirementLbl.text = prizeRequirements[indexPath.row]
        cell.prizeImage.image = UIImage(named: prizeImages[indexPath.row])
        return cell
    }
}
