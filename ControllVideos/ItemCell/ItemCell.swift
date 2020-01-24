//
//  ItemCell.swift
//  ControllVideos
//
//  Created by Boyd Rotgans on 21/01/2020.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
//    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(text: String) {
        //self.userButton.setTitle(text, for:.normal)
        self.label.text = text
        //userButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        
    }
    
//    @objc func buttonClick() {
//
//        let name = self.userButton.titleLabel?.text as! String
//        print("set user \(name)")
//
//        // save to userDefaults
//        UserDefaults.standard.set(self.userButton.titleLabel?.text!, forKey: "selectedUser")
//        self.isSelected = true
//
//        if(self.isSelected) {
//                self.userButton.setTitle("_ \(name)", for:.normal)
//
//        }
//
//        // open next storyboard
////        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
////        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TypeViewController") as! UiTypeView
////        self.present(newViewController, animated: true, completion: nil)
//    }

}
