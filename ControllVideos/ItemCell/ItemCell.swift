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
        self.label.layer.masksToBounds = true
        self.label.layer.cornerRadius = 25.0
        
        if(completed) {
            self.label.text = "✓ \(text)"
            self.label.backgroundColor = UIColor(named: "customGreen")
        }
        
    }
}

