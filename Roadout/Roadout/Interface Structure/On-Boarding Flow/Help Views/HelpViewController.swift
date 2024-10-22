//
//  HelpViewController.swift
//  Roadout
//
//  Created by David Retegan on 14.05.2022.
//

import UIKit

class HelpViewController: UIViewController {
    
    let doneTitle = NSAttributedString(string: "Thanks! Done".localized(), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)])
    let helpTitle = NSAttributedString(
        string: "I still need help".localized(),
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.Roadout.icons, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .medium)]
    )
    
    var centerCell: HelpCell!
    let problems = [ProblemManager.sharedInstance.problem1,
                    ProblemManager.sharedInstance.problem2,
                    ProblemManager.sharedInstance.problem3,
                    ProblemManager.sharedInstance.problem4]
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var doneBtn: UXButton!
    @IBAction func doneTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var moreBtn: UIButton!
    @IBAction func moreTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HelpContactVC") as! HelpContactViewController
        vc.tintColor = UIColor.Roadout.icons
        self.present(vc, animated: true)
    }
    
    //MARK: - View Configuration -
    
    override func viewDidAppear(_ animated: Bool) {
        let indexPath = IndexPath(item: 0, section: 0)
        centerCell = collectionView.cellForItem(at: indexPath) as? HelpCell
        centerCell.transformToLarge()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBtn.layer.cornerRadius = 13.0
        doneBtn.setAttributedTitle(doneTitle, for: .normal)
        moreBtn.setAttributedTitle(helpTitle, for: .normal)
        
        titleLbl.text = "Help Center".localized()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = .fast
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
        collectionView.collectionViewLayout = HelpCollectionViewLayout()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ReportBugVC") as! ReportBugViewController
            self.present(vc, animated: true)
        }
    }

}
extension HelpViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return problems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HelpCell", for: indexPath) as! HelpCell
        
        cell.tagLbl.text = problems[indexPath.row].tag
        cell.titleLbl.text = problems[indexPath.row].title
        cell.problemImage.image = UIImage(named: problems[indexPath.row].image)
        
        switch problems[indexPath.row].cardType {
            case .fullColor:
                cell.upCard.backgroundColor = UIColor.clear
                cell.bottomCard.backgroundColor = UIColor.clear
                cell.titleLbl.textColor = UIColor(named: "Secondary Detail")!
                cell.tagLbl.textColor = UIColor(named: "Secondary Detail")!
            cell.fullProblemImage.image = UIImage(named: problems[indexPath.row].image)
                cell.fullGradientView.alpha = 1
                cell.gradientView.alpha = 0
                cell.problemImage.alpha = 0
            case .noColor:
                cell.upCard.backgroundColor = UIColor(named: "Secondary Detail")!
                cell.bottomCard.backgroundColor = UIColor(named: "Secondary Detail")!
                cell.titleLbl.textColor = UIColor.Roadout.icons
                cell.tagLbl.textColor = UIColor.systemGray3
                cell.card.backgroundColor = UIColor(named: "Secondary Detail")!
                cell.problemImage.alpha = 1
                cell.fullGradientView.alpha = 0
                cell.gradientView.alpha = 0
                cell.fullProblemImage.alpha = 0
            case .colorUp:
                cell.upCard.backgroundColor = UIColor.Roadout.icons
                cell.bottomCard.backgroundColor = UIColor(named: "Secondary Detail")!
                cell.titleLbl.textColor = UIColor(named: "Secondary Detail")!
                cell.tagLbl.textColor = UIColor(named: "Secondary Detail")!
                cell.card.backgroundColor = UIColor(named: "Secondary Detail")!
                cell.fullGradientView.alpha = 0
                cell.gradientView.alpha = 0
                cell.problemImage.alpha = 1
                cell.fullProblemImage.alpha = 0
            case .colorDown:
                cell.upCard.backgroundColor = UIColor(named: "Secondary Detail")!
                cell.bottomCard.backgroundColor = UIColor.Roadout.icons
                cell.titleLbl.textColor = UIColor.Roadout.icons
                cell.tagLbl.textColor = UIColor.systemGray3
                cell.card.backgroundColor = UIColor(named: "Secondary Detail")!
                cell.problemImage.alpha = 1
                cell.fullGradientView.alpha = 0
                cell.gradientView.alpha = 1
                cell.fullProblemImage.alpha = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProblem = problems[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "HelpDetailVC") as! HelpDetailViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }
        
        let centerPoint = CGPoint(x: self.collectionView.frame.width/2 + scrollView.contentOffset.x, y: self.collectionView.frame.height/2 + scrollView.contentOffset.y)
        
        if let indexPath = self.collectionView.indexPathForItem(at: centerPoint) {
            self.centerCell = self.collectionView.cellForItem(at: indexPath) as? HelpCell
            self.centerCell.transformToLarge()
        }
        
        if let cell = centerCell {
            let offSetX = centerPoint.x - cell.center.x
            
            if offSetX < -120 || offSetX > 120 {
                cell.transformToSmall()
                self.centerCell = nil
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.collectionView.scrollToNearestVisibleCollectionViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionView.scrollToNearestVisibleCollectionViewCell()
        }
    }
    
}
