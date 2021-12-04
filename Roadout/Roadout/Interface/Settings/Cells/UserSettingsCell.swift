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
        let optionMenu = UIAlertController(title: nil, message: "Choose what do you want to edit", preferredStyle: .actionSheet)
        
        let editNameAction = UIAlertAction(title: "Edit Name", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let vc = self.sb.instantiateViewController(withIdentifier: "EditNameVC") as! EditNameViewController
            self.parentViewController().present(vc, animated: true, completion: nil)
        })
        let editPasswordAction = UIAlertAction(title: "Edit Password", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let vc = self.sb.instantiateViewController(withIdentifier: "EditPasswordVC") as! EditPasswordViewController
            self.parentViewController().present(vc, animated: true, completion: nil)
        })
        let deleteAccountAction = UIAlertAction(title: "Delete Account", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Delete Account")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        editNameAction.setValue(UIColor(named: "Icons")!, forKey: "titleTextColor")
        editPasswordAction.setValue(UIColor(named: "Greyish")!, forKey: "titleTextColor")
        deleteAccountAction.setValue(UIColor(named: "Redish")!, forKey: "titleTextColor")
        cancelAction.setValue(UIColor(named: "Main Yellow")!, forKey: "titleTextColor")
        
        optionMenu.addAction(editNameAction)
        optionMenu.addAction(editPasswordAction)
        optionMenu.addAction(deleteAccountAction)
        optionMenu.addAction(cancelAction)
        
        self.parentViewController().present(optionMenu, animated: true, completion: nil)
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Edit Name", image: UIImage(systemName: "pencil"), handler: { (_) in
                let vc = self.sb.instantiateViewController(withIdentifier: "EditNameVC") as! EditNameViewController
                self.parentViewController().present(vc, animated: true, completion: nil)
            }),
            UIAction(title: "Edit Password", image: UIImage(systemName: "key"), handler: { (_) in
                let vc = self.sb.instantiateViewController(withIdentifier: "EditPasswordVC") as! EditPasswordViewController
                self.parentViewController().present(vc, animated: true, completion: nil)
            }),
            UIAction(title: "Delete Account", image: UIImage(systemName: "trash"), handler: { (_) in
                print("Delete Account")
            }),

        ]
    }
    var actionsMenu: UIMenu {
        return UIMenu(title: "Choose what do you want to edit", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        card.layer.cornerRadius = 16.0
        editBtn.setTitle("", for: .normal)
        if #available(iOS 14.0, *) {
            editBtn.menu = actionsMenu
            editBtn.showsMenuAsPrimaryAction = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
