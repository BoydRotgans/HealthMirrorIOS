//
//  ItemCell.swift
//  ControllVideos
//
//  Created by Boyd Rotgans on 21/01/2020.
//  Copyright © 2020 Ferdinand Sorg. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(text: String, completed: Bool) {
        self.label.text = text
        self.label.backgroundColor = .link
        
        if(completed) {
            self.label.text = "✓ \(text)"
            self.label.backgroundColor = UIColor.init(red: 34.0/255.0, green: 139/255.0, blue: 34/255.0, alpha: 1.0)
        }
        
    }
    


}
