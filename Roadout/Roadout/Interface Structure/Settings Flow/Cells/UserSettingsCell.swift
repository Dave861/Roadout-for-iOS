//
//  UserSettingsCell.swift
//  Roadout
//
//  Created by David Retegan on 26.10.2021.
//

import UIKit

class UserSettingsCell: UITableViewCell {
    
    let sb = UIStoryboard(name: "Home", bundle: nil)

    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var card: UIView!
    
    @IBAction func showEditMenu(_ sender: Any) {
        //Handled by menu
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Edit Name".localized(), image: UIImage(systemName: "textformat"), handler: { (_) in
                let vc = self.sb.instantiateViewController(withIdentifier: "EditNameVC") as! EditNameViewController
                self.parentViewController().present(vc, animated: true, completion: nil)
            }),
            UIAction(title: "Edit Password".localized(), image: UIImage(systemName: "key.fill"), handler: { (_) in
                let vc = self.sb.instantiateViewController(withIdentifier: "EditPasswordVC") as! EditPasswordViewController
                self.parentViewController().present(vc, animated: true, completion: nil)
            }),
            UIAction(title: "Delete Account".localized(), image: UIImage(systemName: "trash.fill"), handler: { (_) in
                let vc = self.sb.instantiateViewController(withIdentifier: "DeleteAccountVC") as! DeleteAccountViewController
                self.parentViewController().present(vc, animated: true, completion: nil)
            }),

        ]
    }
    var actionsMenu: UIMenu {
        return UIMenu(title: "Choose what do you want to edit".localized(), image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 14.0
        editBtn.setTitle("", for: .normal)
        
        editBtn.menu = actionsMenu
        editBtn.showsMenuAsPrimaryAction = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
