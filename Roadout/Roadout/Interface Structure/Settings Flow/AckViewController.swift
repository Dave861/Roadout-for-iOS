//
//  AckViewController.swift
//  Roadout
//
//  Created by David Retegan on 06.02.2022.
//

import UIKit

class AckViewController: UIViewController {

    let acknowledgementsTitles = ["Alamofire",
                                  "CHIOTPField",
                                  "GeohashKit",
                                  "Google Maps SDK",
                                  "IOSSecuritySuite",
                                  "PusherSwift"]
    
    let acknowledgementsCopyrights = ["Copyright (c) 2014-2023 Alamofire Software Foundation",
                                      "Copyright (c) 2023 Chili",
                                      "Copyright (c) 2023 Alan Chu",
                                      "Copyright (c) 2012-2023 Google Inc.",
                                      "Copyright (c) 2023, SecuRing spółka z ograniczoną odpowiedzialnością spółka jawna",
                                      "Copyright (c) 2023 Pusher Ltd."]
    
    let acknowledgementsLinks = ["https://github.com/Alamofire/Alamofire",
                                 "https://github.com/ChiliLabs/CHIOTPField",
                                 "https://github.com/ualch9/GeohashKit",
                                 "https://github.com/YAtechnologies/GoogleMaps-SP",
                                 "https://github.com/securing/IOSSecuritySuite",
                                 "https://github.com/pusher/pusher-websocket-swift"]

    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!

    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if self.tableView.layer.mask == nil {
            let maskLayer: CAGradientLayer = CAGradientLayer()

            maskLayer.locations = [0.0, 0.2, 0.8, 1.0]
            let width = self.tableView.frame.size.width
            let height = self.tableView.frame.size.height
            maskLayer.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: height)
            maskLayer.anchorPoint = CGPoint.zero

            self.tableView.layer.mask = maskLayer
        }

        scrollViewDidScroll(self.tableView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let outerColor = UIColor(white: 1.0, alpha: 0.0).cgColor
        let innerColor = UIColor(white: 1.0, alpha: 1.0).cgColor

        var colors = [CGColor]()

        if scrollView.contentOffset.y + scrollView.contentInset.top <= 0 {
            colors = [innerColor, innerColor, innerColor, outerColor]
        } else if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
            colors = [outerColor, innerColor, innerColor, innerColor]
        } else {
            colors = [outerColor, innerColor, innerColor, outerColor]
        }

        if let mask = scrollView.layer.mask as? CAGradientLayer {
            mask.colors = colors

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            mask.position = CGPoint(x: 0.0, y: scrollView.contentOffset.y)
            CATransaction.commit()
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
        }
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
