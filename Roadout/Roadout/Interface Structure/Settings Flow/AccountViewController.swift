//
//  AccountViewController.swift
//  Roadout
//
//  Created by David Retegan on 23.02.2023.
//

import UIKit

class AccountViewController: UIViewController {
    
    var lightColorGradient: UIColor!
    var darkColorGradient: UIColor!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Member Badge -
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var badgeShadowView: UIView!

    @IBOutlet weak var cutoutBadgeView: UIView!
    @IBOutlet weak var nameBadgeLbl: UILabel!
    @IBOutlet weak var titleBadgeLbl: UILabel!
    
    @IBOutlet weak var shuffleBtn: UIButton!
    @IBAction func shuffleTapped(_ sender: Any) {
        titleBadgeLbl.text = getRandomPhrase()
        addBadgeGradient()
        badgeView.layer.sublayers?.remove(at: 1)
        readjustShuffleButton()
    }
    
    //MARK: - Rest of IBOutlets-
    @IBOutlet weak var badgeCanvasView: UIView!
    
    @IBOutlet weak var optionsView: UIView!
    
    @IBOutlet weak var licensePlateView: UIView!
    @IBOutlet weak var licensePlateLbl: UILabel!
    @IBOutlet weak var licensePlateIcon: UIView!
    @IBOutlet weak var licensePlateBtn: UIButton!
    
    @IBAction func plateTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "EditLicensePlateVC") as! EditLicensePlateViewController
        self.present(vc, animated: true)
    }
    
    @IBOutlet weak var manageIcon: UIView!
    @IBOutlet weak var manageBtn: UIButton!
    
    //MARK: - Edit Menu -
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Delete Account".localized(), image: UIImage(systemName: "trash.fill"), handler: { (_) in
                let sb = UIStoryboard(name: "Home", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "DeleteAccountVC") as! DeleteAccountViewController
                self.present(vc, animated: true, completion: nil)
            }),
            UIAction(title: "Edit Password".localized(), image: UIImage(systemName: "key.fill"), handler: { (_) in
                let sb = UIStoryboard(name: "Home", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "EditPasswordVC") as! EditPasswordViewController
                self.present(vc, animated: true, completion: nil)
            }),
            UIAction(title: "Edit Name".localized(), image: UIImage(systemName: "textformat"), handler: { (_) in
                let sb = UIStoryboard(name: "Home", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "EditNameVC") as! EditNameViewController
                self.present(vc, animated: true, completion: nil)
            })
        ]
    }
    var editMenu: UIMenu {
        return UIMenu(title: "Manage your account".localized(), image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    //MARK: - View Configuration -
    
    func manageObs() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadName), name: .reloadUserNameID, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadLicensePlate), name: .reloadLicensePlateID, object: nil)
    }
    
    @objc func reloadLicensePlate() {
        self.licensePlateLbl.text = userLicensePlate != "" ? userLicensePlate : "NO-PLATE".localized()
        self.licensePlateLbl.text = userLicensePlate != nil ? userLicensePlate : "NO-PLATE".localized()
    }
    
    @objc func reloadName() {
        let id = UserDefaults.roadout!.object(forKey: "eu.roadout.Roadout.userID") as! String
        Task {
            do {
                try await UserManager.sharedInstance.getUserNameAsync(id)
                DispatchQueue.main.async {
                    self.nameBadgeLbl.text = UserManager.sharedInstance.userName
                }
            } catch let err {
                print(err)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        manageObs()
        
        badgeCanvasView.layer.cornerRadius = 16.0
        optionsView.layer.cornerRadius = 12.0
        
        manageIcon.layer.cornerRadius = manageIcon.frame.height/4
        
        licensePlateBtn.setTitle("", for: .normal)
        licensePlateIcon.layer.cornerRadius = licensePlateIcon.frame.height/4
        licensePlateView.layer.cornerRadius = licensePlateView.frame.height/5
        licensePlateLbl.text = userLicensePlate != "" ? userLicensePlate : "NO-PLATE".localized()
        licensePlateLbl.text = userLicensePlate != nil ? userLicensePlate : "NO-PLATE".localized()
        
        manageBtn.menu = editMenu
        manageBtn.setTitle("", for: .normal)
        manageBtn.showsMenuAsPrimaryAction = true
        
        badgeView.clipsToBounds = true
        badgeView.layer.masksToBounds = true
        badgeView.layer.cornerRadius = 10
        badgeShadowView.layer.cornerRadius = 10
        shuffleBtn.layer.cornerRadius = shuffleBtn.frame.height/4
        shuffleBtn.setTitle("", for: .normal)
        nameBadgeLbl.text = UserManager.sharedInstance.userName
        titleBadgeLbl.text = getRandomPhrase()
        
        addBadgeShadow()
        addBadgeGradient()
        addBadgeMotionEffect()
        
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                cutoutBadgeView.layer.compositingFilter = "screenBlendMode"
                badgeShadowView.layer.shadowColor = UIColor.black.cgColor
                //Adjust the shuffle button
                shuffleBtn.tintColor = darkColorGradient
                shuffleBtn.backgroundColor = lightColorGradient.withAlphaComponent(0.3)
            case .dark:
                cutoutBadgeView.layer.compositingFilter = "multiplyBlendMode"
                badgeShadowView.layer.shadowColor = UIColor.white.cgColor
                //Adjust the shuffle button
                shuffleBtn.tintColor = lightColorGradient
                shuffleBtn.backgroundColor = darkColorGradient.withAlphaComponent(0.3)
            @unknown default:
                break
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                cutoutBadgeView.layer.compositingFilter = "screenBlendMode"
                badgeShadowView.layer.shadowColor = UIColor.black.cgColor
                //Adjust the shuffle button
                shuffleBtn.tintColor = darkColorGradient
                shuffleBtn.backgroundColor = lightColorGradient.withAlphaComponent(0.3)
            case .dark:
                cutoutBadgeView.layer.compositingFilter = "multiplyBlendMode"
                badgeShadowView.layer.shadowColor = UIColor.white.cgColor
                //Adjust the shuffle button
                shuffleBtn.tintColor = lightColorGradient
                shuffleBtn.backgroundColor = darkColorGradient.withAlphaComponent(0.3)
            @unknown default:
                break
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
        }
    }
    
    func addBadgeMotionEffect() {
        let horizontalEffect = UIInterpolatingMotionEffect(
            keyPath: "center.x",
            type: .tiltAlongHorizontalAxis)
        horizontalEffect.minimumRelativeValue = -20
        horizontalEffect.maximumRelativeValue = 20

        let verticalEffect = UIInterpolatingMotionEffect(
            keyPath: "center.y",
            type: .tiltAlongVerticalAxis)
        verticalEffect.minimumRelativeValue = -20
        verticalEffect.maximumRelativeValue = 20

        let effectGroup = UIMotionEffectGroup()
        effectGroup.motionEffects = [ horizontalEffect,
                                      verticalEffect ]

        badgeView.addMotionEffect(effectGroup)
        badgeShadowView.addMotionEffect(effectGroup)
    }
    
    func addBadgeGradient() {
        let gradientLayer = getRandomGradient()
        gradientLayer.frame = badgeView.bounds
        gradientLayer.cornerRadius = 10

        badgeView.layer.insertSublayer(gradientLayer, at: 0)
    }

    func addBadgeShadow() {
        badgeShadowView.layer.shadowColor = UIColor.black.cgColor
        badgeShadowView.layer.shadowOpacity = 0.15
        badgeShadowView.layer.shadowOffset = .zero
        badgeShadowView.layer.shadowRadius = 10
        badgeShadowView.layer.shadowPath = UIBezierPath(rect: badgeShadowView.bounds).cgPath
        badgeShadowView.layer.shouldRasterize = true
        badgeShadowView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func readjustShuffleButton() {
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                shuffleBtn.tintColor = darkColorGradient
                shuffleBtn.backgroundColor = lightColorGradient.withAlphaComponent(0.3)
            case .dark:
                shuffleBtn.tintColor = lightColorGradient
                shuffleBtn.backgroundColor = darkColorGradient.withAlphaComponent(0.3)
            @unknown default:
                break
        }
    }
    
    func getRandomPhrase() -> String {
        let adjectives = ["Smart", "Wise", "Excited", "Visionary", "Creative", "Ingenious", "Revolutionary", "Ambitious", "Daring"]
        let nouns = ["Driver", "Parker", "Chaffeur", "Navigator", "Steersman", "Pilot"]
        return adjectives.randomElement()! + " " + nouns.randomElement()!
    }
    
    func getRandomGradient() -> CAGradientLayer {
        let lightColors = [
            UIColor.Roadout.mainYellow,
            UIColor.Roadout.secondOrange,
            UIColor.Roadout.icons,
            UIColor.Roadout.goldBrown
        ]
        let darkColors = [
            UIColor.Roadout.kindaRed,
            UIColor.Roadout.darkOrange,
            UIColor.Roadout.darkYellow,
            UIColor.Roadout.redish
        ]
        
        var selectedColors = [UIColor]()
        var lightRandom = lightColors.randomElement()!
        var darkRandom = darkColors.randomElement()!
        
        if Bool.random() {
            if lightRandom == UIColor(named: "Second Orange") && darkRandom == UIColor(named: "Dark Orange") {
                darkRandom = darkColors.randomElement()!
            } else if lightRandom == UIColor(named: "GoldBrown") && darkRandom == UIColor(named: "Dark Yellow") {
                darkRandom = darkColors.randomElement()!
            }
            
            selectedColors.append(lightRandom)
            selectedColors.append(darkRandom)
        } else {
            if lightRandom == UIColor(named: "Second Orange") && darkRandom == UIColor(named: "Dark Orange") {
                lightRandom = lightColors.randomElement()!
            } else if lightRandom == UIColor(named: "GoldBrown") && darkRandom == UIColor(named: "Dark Yellow") {
                lightRandom = lightColors.randomElement()!
            }
            
            selectedColors.append(darkRandom)
            selectedColors.append(lightRandom)
        }
        
        lightColorGradient = lightRandom
        darkColorGradient = darkRandom
        
        // Increase saturation of selected colors
        let saturatedColors = selectedColors.map { color -> UIColor in
            var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
            color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
            return UIColor(hue: hue, saturation: min(saturation * 1.5, 1.0), brightness: brightness, alpha: alpha)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = saturatedColors.map({ $0.cgColor })
        gradientLayer.type = .axial
        
        let startPoint = CGPoint(x: 0.0, y: CGFloat.random(in: 0...1))
        let endPoint = CGPoint(x: 1.0, y: CGFloat.random(in: 0...1))
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = [0.0, 1.0]
        
        return gradientLayer
    }

}
