//
//  HelpCell.swift
//  Roadout
//
//  Created by David Retegan on 14.05.2022.
//

import UIKit

class HelpCell: UICollectionViewCell {
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var tagLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var upCard: UIView!
    @IBOutlet weak var bottomCard: UIView!

    @IBOutlet weak var problemImage: UIImageView!
    @IBOutlet weak var fullProblemImage: UIImageView!
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var fullGradientView: GradientView!
    
    override func awakeFromNib() {
        card.layer.cornerRadius = 16.0
        upCard.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        upCard.layer.cornerRadius = 16.0
        bottomCard.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        bottomCard.layer.cornerRadius = 16.0
        
        problemImage.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        problemImage.layer.cornerRadius = 16.0
        fullProblemImage.layer.cornerRadius = 16.0
        
        gradientView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        gradientView.layer.cornerRadius = 16.0
        fullGradientView.layer.cornerRadius = 16.0
    }
    
    override var isHighlighted: Bool {
        didSet {
            bounce(isHighlighted)
        }
    }

    func bounce(_ bounce: Bool) {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.8, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.transform = bounce ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
        }, completion: nil)
    }
    
    
    func transformToLarge() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
    }
    
    func transformToSmall() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
        }
    }
}

class HelpCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        itemSize = CGSize(width: 260, height: 310)
        minimumInteritemSpacing = 30
        minimumLineSpacing = 27
    }

}
