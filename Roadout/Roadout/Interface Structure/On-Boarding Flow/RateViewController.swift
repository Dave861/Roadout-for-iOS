//
//  RateViewController.swift
//  Roadout
//
//  Created by David Retegan on 31.05.2022.
//

import UIKit

class RateViewController: UIViewController {
    
    let submitTitle = NSAttributedString(string: "Submit".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let cancelTitle = NSAttributedString(
        string: "Cancel".localized(),
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.Roadout.mainYellow, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
    )
    
    var reservingReasons = [RateReason(description: "Easy to use".localized(), isSelected: false),
                            RateReason(description: "Fast & Reliable".localized(), isSelected: false),
                            RateReason(description: "Intuitive".localized(), isSelected: false),
                            RateReason(description: "Stable".localized(), isSelected: false),
                            RateReason(description: "Buggy".localized(), isSelected: false),
                            RateReason(description: "Hard to understand".localized(), isSelected: false),]
    
    var parkingReasons = [RateReason(description: "Easy to find".localized(), isSelected: false),
                          RateReason(description: "Fast".localized(), isSelected: false),
                          RateReason(description: "Close to destination".localized(), isSelected: false),
                          RateReason(description: "Slow & Unreliable".localized(), isSelected: false),
                          RateReason(description: "Hard to move around".localized(), isSelected: false)]
    
    var reservingScore = -1
    var parkingScore = -1
    
    @IBOutlet weak var bigTitleLbl: UILabel!
    @IBOutlet weak var reservingExperienceLbl: UILabel!
    @IBOutlet weak var parkingExperienceLbl: UILabel!
    @IBOutlet weak var overallLbl: UILabel!
    @IBOutlet weak var scoreTextLbl: UILabel!
    
    @IBOutlet weak var card1: UIView!
    @IBOutlet weak var card2: UIView!
    @IBOutlet weak var card3: UIView!
    
    @IBOutlet weak var reservingImpressionLbl: UILabel!
    @IBOutlet weak var parkingImpressionLbl: UILabel!
    @IBOutlet weak var overallImpressionLbl: UILabel!
    
    @IBOutlet weak var reasonBtn1: UIButton!
    @IBOutlet weak var reasonBtn2: UIButton!
    
    @IBOutlet weak var reservingReasonLbl: UILabel!
    @IBOutlet weak var parkingReasonLbl: UILabel!
    
    @IBAction func reservingReasonTapped(_ sender: Any) {}
    
    @IBAction func parkingReasonTapped(_ sender: Any) {}
    
    @IBOutlet weak var reservingGoodBtn: UXButton!
    @IBOutlet weak var reservingOkBtn: UXButton!
    @IBOutlet weak var reservingBadBtn: UXButton!
    
    @IBOutlet weak var parkingGoodBtn: UXButton!
    @IBOutlet weak var parkingOkBtn: UXButton!
    @IBOutlet weak var parkingBadBtn: UXButton!
    
    
    @IBAction func reservingGoodTapped(_ sender: UIButton) {
        self.updateReservingCardInfo(impression: "Good".localized(), icon: "hand.thumbsup.fill", sender: sender)
        reservingScore = 2
        self.updateOverallImpressionLbl()
    }
    
    @IBAction func reservingOkTapped(_ sender: UIButton) {
        self.updateReservingCardInfo(impression: "OK".localized(), icon: "hand.raised.fill", sender: sender)
        reservingScore = 1
        self.updateOverallImpressionLbl()
    }
    
    @IBAction func reservingBadTapped(_ sender: UIButton) {
        self.updateReservingCardInfo(impression: "Bad".localized(), icon: "hand.thumbsdown.fill", sender: sender)
        reservingScore = 0
        self.updateOverallImpressionLbl()
    }
    
    @IBAction func parkingGoodTapped(_ sender: UIButton) {
        self.updateParkingCardInfo(impression: "Good".localized(), icon: "hand.thumbsup.fill", sender: sender)
        parkingScore = 2
        self.updateOverallImpressionLbl()
    }
    
    @IBAction func parkingOkTapped(_ sender: UIButton) {
        self.updateParkingCardInfo(impression: "OK".localized(), icon: "hand.raised.fill", sender: sender)
        parkingScore = 1
        self.updateOverallImpressionLbl()
    }
    
    @IBAction func parkingBadTapped(_ sender: UIButton) {
        self.updateParkingCardInfo(impression: "Bad".localized(), icon: "hand.thumbsdown.fill", sender: sender)
        parkingScore = 0
        self.updateOverallImpressionLbl()
    }
    
    
    @IBOutlet weak var submitBtn: UXButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBAction func submitTapped(_ sender: Any) {
        //will have api
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalization()
        reservingImpressionLbl.text = "Not Selected".localized()
        parkingImpressionLbl.text = "Not Selected".localized()
        
        card1.layer.cornerRadius = 16.0
        card2.layer.cornerRadius = 16.0
        card3.layer.cornerRadius = 16.0
        
        submitBtn.layer.cornerRadius = 13.0
        submitBtn.setAttributedTitle(submitTitle, for: .normal)
        cancelBtn.setAttributedTitle(cancelTitle, for: .normal)
        
        reservingGoodBtn.layer.cornerRadius = reservingGoodBtn.frame.height/2
        reservingOkBtn.layer.cornerRadius = reservingOkBtn.frame.height/2
        reservingBadBtn.layer.cornerRadius = reservingBadBtn.frame.height/2
        parkingGoodBtn.layer.cornerRadius = parkingGoodBtn.frame.height/2
        parkingOkBtn.layer.cornerRadius = parkingOkBtn.frame.height/2
        parkingBadBtn.layer.cornerRadius = parkingBadBtn.frame.height/2
        
        reservingGoodBtn.setTitle("", for: .normal)
        reservingOkBtn.setTitle("", for: .normal)
        reservingBadBtn.setTitle("", for: .normal)
        parkingGoodBtn.setTitle("", for: .normal)
        parkingOkBtn.setTitle("", for: .normal)
        parkingBadBtn.setTitle("", for: .normal)
        
        reasonBtn1.setTitle("", for: .normal)
        reasonBtn2.setTitle("", for: .normal)
        
        updateOverallImpressionLbl()
        
        
        reasonBtn1.showsMenuAsPrimaryAction = true
        reasonBtn2.showsMenuAsPrimaryAction = true
        reasonBtn1.menu = makeReservingReasonsMenu()
        reasonBtn2.menu = makeParkingReasonsMenu()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
        }
    }
    
    func setLocalization() {
        self.overallLbl.text = "Overall".localized()
        self.scoreTextLbl.text = "Score".localized()
        self.reservingReasonLbl.text = "Tell us why".localized()
        self.parkingReasonLbl.text = "Tell us why".localized()
    }
    
    //MARK: - Button Managers -
    
    func updateReservingCardInfo(impression: String, icon: String, sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        reservingImpressionLbl.text = impression
        
        reservingGoodBtn.backgroundColor = UIColor(named: "Second Background")
        reservingGoodBtn.tintColor = UIColor.darkGray
        reservingGoodBtn.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        
        reservingOkBtn.backgroundColor = UIColor(named: "Second Background")
        reservingOkBtn.tintColor = UIColor.darkGray
        reservingOkBtn.setImage(UIImage(systemName: "hand.raised"), for: .normal)
        
        reservingBadBtn.backgroundColor = UIColor(named: "Second Background")
        reservingBadBtn.tintColor = UIColor.darkGray
        reservingBadBtn.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
        
        sender.backgroundColor = UIColor.Roadout.mainYellow
        sender.tintColor = UIColor(named: "Background")
        sender.setImage(UIImage(systemName: icon), for: .normal)
    }
    
    func updateParkingCardInfo(impression: String, icon: String, sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        parkingImpressionLbl.text = impression
        
        parkingGoodBtn.backgroundColor = UIColor(named: "Second Background")
        parkingGoodBtn.tintColor = UIColor.darkGray
        parkingGoodBtn.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        
        parkingOkBtn.backgroundColor = UIColor(named: "Second Background")
        parkingOkBtn.tintColor = UIColor.darkGray
        parkingOkBtn.setImage(UIImage(systemName: "hand.raised"), for: .normal)
        
        parkingBadBtn.backgroundColor = UIColor(named: "Second Background")
        parkingBadBtn.tintColor = UIColor.darkGray
        parkingBadBtn.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
        
        sender.backgroundColor = UIColor.Roadout.mainYellow
        sender.tintColor = UIColor(named: "Background")
        sender.setImage(UIImage(systemName: icon), for: .normal)
    }
    
    func makeReservingReasonsMenu() -> UIMenu {
        
        var menuItems = [UIAction]()
        
        for index in 0...reservingReasons.count-1 {
            let action = UIAction(title: self.reservingReasons[index].description, image: nil, state: self.reservingReasons[index].isSelected ? .on : .off, handler: { action in
                self.reservingReasons[index].isSelected = !self.reservingReasons[index].isSelected
                self.updateReservingReasonLbl()
                self.reasonBtn1.menu = self.makeReservingReasonsMenu()
            })
            menuItems.append(action)
        }
        
        return UIMenu(title: "Reasons".localized(), image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    func makeParkingReasonsMenu()  -> UIMenu {
        
        var menuItems = [UIAction]()
        
        for index in 0...parkingReasons.count-1 {
            let action = UIAction(title: self.parkingReasons[index].description, image: nil, state: self.parkingReasons[index].isSelected ? .on : .off, handler: { action in
                self.parkingReasons[index].isSelected = !self.parkingReasons[index].isSelected
                self.updateParkingReasonLbl()
                self.reasonBtn2.menu = self.makeParkingReasonsMenu()
            })
            menuItems.append(action)
        }
        
        return UIMenu(title: "Reasons".localized(), image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    func updateReservingReasonLbl() {
        var reasonsCount = 0
        for index in 0...reservingReasons.count-1 {
            if self.reservingReasons[index].isSelected {
                reasonsCount += 1
            }
        }
        if reasonsCount == 0 {
            self.reservingReasonLbl.text = "Tell us why".localized()
        } else {
            self.reservingReasonLbl.text = "\(reasonsCount) " + "reason/s".localized()
        }
    }
    
    func updateParkingReasonLbl() {
        var reasonsCount = 0
        for index in 0...parkingReasons.count-1 {
            if self.parkingReasons[index].isSelected {
                reasonsCount += 1
            }
        }
        if reasonsCount == 0 {
            self.parkingReasonLbl.text = "Tell us why".localized()
        } else {
            self.parkingReasonLbl.text = "\(reasonsCount) " + "reason/s".localized()
        }
    }
    
    func updateOverallImpressionLbl() {
        if parkingScore == -1 || reservingScore == -1 {
            self.overallImpressionLbl.text = "-/4"
        } else {
            self.overallImpressionLbl.text = "\(reservingScore + parkingScore)/4"
        }
        self.overallImpressionLbl.set(textColor: .label, range: self.overallImpressionLbl.range(fromBeginningOf: "/"))
    }

}
