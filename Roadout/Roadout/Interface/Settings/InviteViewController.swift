//
//  InviteViewController.swift
//  Roadout
//
//  Created by David Retegan on 29.10.2021.
//

import UIKit
import BarChartKit

class InviteViewController: UIViewController {

    let mockBarChartDataSet: BarChartView.DataSet? = BarChartView.DataSet(elements: [
        BarChartView.DataSet.DataElement(date: nil, xLabel: "Invites".localized(), bars: [BarChartView.DataSet.DataElement.Bar(value: 20000, color: UIColor(named: "Greyish")!)]),
        BarChartView.DataSet.DataElement(date: nil, xLabel: "Verified".localized(), bars: [BarChartView.DataSet.DataElement.Bar(value: 13000, color: UIColor(named: "Main Yellow")!)])
        ], selectionColor: UIColor(named: "Main Yellow"))
    
    @IBOutlet weak var linkLbl: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var chartView: BarChartView!
    
    let buttonTitle = NSAttributedString(string: "Share".localized(),
                                         attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor : UIColor(named: "Main Yellow")!])
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBAction func shareTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        let textToShare = [linkLbl.text]
        let activityViewController = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var shareBtnOutline: UIView!
    
    @IBOutlet weak var linkCard: UIView!
    @IBOutlet weak var statsCard: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.dataSet = mockBarChartDataSet
        shareBtn.setAttributedTitle(buttonTitle, for: .normal)
        shareBtnOutline.layer.cornerRadius = 12.0
        linkCard.layer.cornerRadius = 16.0
        statsCard.layer.cornerRadius = 16.0
    }

}
