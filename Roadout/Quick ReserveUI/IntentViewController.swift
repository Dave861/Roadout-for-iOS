//
//  IntentViewController.swift
//  Quick ReserveUI
//
//  Created by David Retegan on 30.11.2021.
//
import UIKit
import IntentsUI

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var explanationLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func updateViews(color: UIColor, status: String, explanation: String, iconImage: UIImage) {
        icon.tintColor = color
        icon.image = iconImage
        statusLbl.text = status
        explanationLbl.text = explanation
        if color == UIColor(named: "Dark Orange")! {
            explanationLbl.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
            explanationLbl.textColor = UIColor.label
        } else {
            explanationLbl.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
            explanationLbl.textColor = UIColor.systemGray
        }
    }
        
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        
        if interaction.intentHandlingStatus == .success {
            self.updateViews(color: UIColor(named: "Icons")!, status: "Success", explanation: "Please open the app to see your reservation", iconImage: UIImage(systemName: "checkmark.seal")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)))
        } else if interaction.intentHandlingStatus == .failure || interaction.intentHandlingStatus == .unspecified {
            self.updateViews(color: UIColor(named: "Redish")!, status: "Failure", explanation: "There was an error. Please send a bug report", iconImage: UIImage(systemName: "xmark.app")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)))
        } else if interaction.intentHandlingStatus == .inProgress || interaction.intentHandlingStatus == .userConfirmationRequired || interaction.intentHandlingStatus == .ready {
            self.updateViews(color: UIColor(named: "Greyish")!, status: "Confirm", explanation: "Old Town - Section A - Spot 12", iconImage: UIImage(systemName: "loupe")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)))
            
        }
        
        completion(true, parameters, CGSize(width: desiredSize.width, height: 80))
    }
    
    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }
    
}
