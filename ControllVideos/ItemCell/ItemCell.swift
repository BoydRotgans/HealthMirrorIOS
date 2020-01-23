//
//  ItemCell.swift
//  ControllVideos
//
//  Created by Boyd Rotgans on 21/01/2020.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var userButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(text: String) {
        self.userButton.setTitle(text, for:.normal)
        
        userButton.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        
    }
    
    @objc func buttonClick() {
        print("set user \(self.userButton.titleLabel?.text as! String)")
        
        // save to userDefaults
        
        UserDefaults.standard.set(self.userButton.titleLabel?.text!, forKey: "selectedUser")
        
        // open next storyboard
        //let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //let newViewController = storyBoard.instantiateViewController(withIdentifier: "TypeViewController") as! UiTypeView
        //self.present(newViewController, animated: true, completion: nil)
    }

}
