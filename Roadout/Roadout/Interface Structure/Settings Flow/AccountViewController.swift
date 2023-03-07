//
//  AccountViewController.swift
//  Roadout
//
//  Created by David Retegan on 23.02.2023.
//

import UIKit

class AccountViewController: UIViewController {
    
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
        self.licensePlateLbl.text = userLicensePlate
    }
    
    @objc func reloadName() {
        let id = UserDefaults.roadout!.object(forKey: "ro.roadout.Roadout.userID") as! String
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
        licensePlateLbl.text = userLicensePlate
        
        manageBtn.menu = editMenu
        manageBtn.setTitle("", for: .normal)
        manageBtn.showsMenuAsPrimaryAction = true
        
        badgeView.clipsToBounds = true
        badgeView.layer.masksToBounds = true
        badgeView.layer.cornerRadius = 24.0
        badgeShadowView.layer.cornerRadius = 24.0
        nameBadgeLbl.text = UserManager.sharedInstance.userName
        titleBadgeLbl.text = getRandomPhrase()
        
        addBadgeShadow()
        addBadgeGradient()
        addBadgeMotionEffect()
        
        switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                cutoutBadgeView.layer.compositingFilter = "screenBlendMode"
                badgeShadowView.layer.shadowColor = UIColor.black.cgColor
            case .dark:
                cutoutBadgeView.layer.compositingFilter = "multiplyBlendMode"
                badgeShadowView.layer.shadowColor = UIColor.white.cgColor
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
            case .dark:
                cutoutBadgeView.layer.compositingFilter = "multiplyBlendMode"
                badgeShadowView.layer.shadowColor = UIColor.white.cgColor
            @unknown default:
                break
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
        gradientLayer.cornerRadius = 24.0

        badgeView.layer.insertSublayer(gradientLayer, at: 0)
    }

    func addBadgeShadow() {
        badgeShadowView.layer.shadowColor = UIColor.black.cgColor
        badgeShadowView.layer.shadowOpacity = 0.15
        badgeShadowView.layer.shadowOffset = .zero
        badgeShadowView.layer.shadowRadius = 24.0
        badgeShadowView.layer.shadowPath = UIBezierPath(rect: badgeShadowView.bounds).cgPath
        badgeShadowView.layer.shouldRasterize = true
        badgeShadowView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func getRandomPhrase() -> String {
        let adjectives = ["Smart", "Wise", "Excited", "Visionary", "Creative", "Ingenious", "Revolutionary", "Ambitious", "Daring"]
        let nouns = ["Driver", "Parker", "Chaffeur", "Navigator", "Steersman", "Pilot"]
        return adjectives.randomElement()! + " " + nouns.randomElement()!
    }
    
    func getRandomGradient() -> CAGradientLayer {
        let lightColors = [
            UIColor(named: "Main Yellow")!,
            UIColor(named: "Second Orange")!,
            UIColor(named: "Icons")!,
            UIColor(named: "GoldBrown")!
        ]
        let darkColors = [
            UIColor(named: "Dark Yellow")!,
            UIColor(named: "Dark Orange")!,
            UIColor(named: "Kinda Red")!,
            UIColor(named: "Redish")!
        ]

        var selectedColors = [UIColor]()
        if Bool.random() {
            selectedColors.append(lightColors.randomElement()!)
            selectedColors.append(darkColors.randomElement()!)
        } else {
            selectedColors.append(darkColors.randomElement()!)
            selectedColors.append(lightColors.randomElement()!)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = selectedColors.map({ $0.cgColor })
        gradientLayer.type = .axial
        
        let startPoint = CGPoint(x: 0.0, y: CGFloat.random(in: 0...1))
        let endPoint = CGPoint(x: 1.0, y: CGFloat.random(in: 0...1))
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = [0.0, 1.0]
        
        return gradientLayer
    }

}
