//
//  HelpDetailViewController.swift
//  Roadout
//
//  Created by David Retegan on 14.05.2022.
//

import UIKit

var selectedProblem: HelpCenterProblem!

class HelpDetailViewController: UIViewController {
    
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func closeTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var tagLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var problemImage: UIImageView!
    @IBOutlet weak var solutionTextView: UITextView!
    
    //MARK: - View Configuration -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.setTitle("", for: .normal)
        closeButton.layer.cornerRadius = closeButton.frame.height/2
        
        tagLbl.text = selectedProblem.tag
        titleLbl.text = selectedProblem.title
        problemImage.image = UIImage(named: "Header" + selectedProblem.image)
        
        if selectedProblem.title == ProblemManager.sharedInstance.problem3.title {
            selectedProblem.fillOutSpotInformation()
        }
        
        solutionTextView.text = selectedProblem.solution
        
        if selectedProblem.title == ProblemManager.sharedInstance.problem3.title {
            addAttachmentImage(image: selectedProblem.sectionImage)
        }
        
        solutionTextView.isSelectable = true
        solutionTextView.isEditable = false
        solutionTextView.isUserInteractionEnabled = true
        solutionTextView.dataDetectorTypes = .all
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    func addAttachmentImage(image: String) {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: image)
        
        let attString = NSAttributedString(attachment: attachment)
        
        solutionTextView.textStorage.insert(attString, at: solutionTextView.selectedRange.location)
    }
    
    @objc func panGestureRecognizerHandler(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)

            if panGesture.state == .began {
                originalPosition = view.center
                currentPositionTouched = panGesture.location(in: view)
            } else if panGesture.state == .changed {
                view.frame.origin = CGPoint(
                    x:  view.frame.origin.x,
                    y:  view.frame.origin.y + translation.y
                )
                panGesture.setTranslation(CGPoint.zero, in: self.view)
            } else if panGesture.state == .ended {
                let velocity = panGesture.velocity(in: view)
                if velocity.y >= 150 {
                    UIView.animate(withDuration: 0.2
                        , animations: {
                            self.view.frame.origin = CGPoint(
                                x: self.view.frame.origin.x,
                                y: self.view.frame.size.height
                            )
                    }, completion: { (isCompleted) in
                        if isCompleted {
                            self.dismiss(animated: false, completion: nil)
                        }
                    })
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.view.center = self.originalPosition!
                })
            }
        }
    }
}
