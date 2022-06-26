//
//  QuestionCell.swift
//  Roadout
//
//  Created by David Retegan on 23.04.2022.
//

import UIKit

class QuestionCell: UITableViewCell {

    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var arrowView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.isHidden = true
        }
    }
    @IBOutlet weak var spacerView: UIView! {
        didSet {
            spacerView.isHidden = false
        }
    }
    @IBOutlet weak var bottomSpacerView: UIView! {
        didSet {
            bottomSpacerView.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
