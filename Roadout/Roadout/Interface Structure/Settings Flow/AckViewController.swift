//
//  AckViewController.swift
//  Roadout
//
//  Created by David Retegan on 06.02.2022.
//

import UIKit

class AckViewController: UIViewController {

    let acknowledgementsTitles = ["Alamofire", "BarChartKit", "CHIOTPField", "Google Maps SDK", "SPIndicator"]
    let acknowledgementsCopyrights = ["Copyright (c) 2014-2022 Alamofire Software Foundation", "Copyright (c) 2020 Marek Přidal", "Copyright (c) 2020 Chili", "Copyright (c) 2012-2022 Google Inc.", "Copyright (C) 2011 Charcoal Design", "Copyright © 2021 Ivan Vorobei", "Copyright © 2021 Ivan Vorobei"]
    let acknowledgementsLinks = ["https://github.com/Alamofire/Alamofire", "https://github.com/marekpridal/BarChart", "https://github.com/ChiliLabs/CHIOTPField", "https://github.com/YAtechnologies/GoogleMaps-SP", "https://github.com/ivanvorobei/SPIndicator"]

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
extension AckViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acknowledgementsTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AckCell") as! AckCell
        cell.titleLbl.text = acknowledgementsTitles[indexPath.row]
        cell.copyrightLbl.text = acknowledgementsCopyrights[indexPath.row]
        cell.linkLbl.text = acknowledgementsLinks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: acknowledgementsLinks[indexPath.row]) {
            UIApplication.shared.open(url)
        }
    }
}
